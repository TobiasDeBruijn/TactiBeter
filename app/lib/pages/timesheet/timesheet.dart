import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tactibetter/api/api_common.dart';
import 'package:tactibetter/api/login.dart';
import 'package:tactibetter/api/timesheet.dart';
import 'package:tactibetter/components/day_selector.dart';
import 'package:tactibetter/components/timesheet/block_in_list.dart';
import 'package:tactibetter/util/datetime.dart';

class TimesheetPage extends StatefulWidget {
  final Session session;

  const TimesheetPage({super.key, required this.session});

  @override
  State<StatefulWidget> createState() => _TimesheetState();
}

class _TimesheetState extends State<TimesheetPage> {
  bool _isLoading = true;

  Timesheet? _timesheet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: "Urenregistratie toevoegen",
        onPressed: () => {},
        child: const Icon(Icons.add)
      ),
      body: ListView(
        children: [
          DaySelectorComponent(
            onChange: (dateTime) => _loadTimeSheet(dateTime),
          ),
          _isLoading ? _getIsLoading() : _getIsLoaded(),
          // TODO debug buttons
        ],
      ),
    );
  }

  Widget _getIsLoading() {
    return const Align(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }

  Widget _getIsLoaded() {
    if(_timesheet == null || _timesheet!.blocks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          "Er zijn nog geen uren opgegeven voor deze dag",
          style: GoogleFonts.oxygen()
        ),
      );
    }

    return Column(
      children: _timesheet!.blocks.map((e) => _getTimesheetBlockTappable(e)).toList(),
    );
  }

  Widget _getTimesheetBlockTappable(TimesheetBlock block) {
    return Card(
      child: InkWell(
        onTap: () => {}, // TODO
        child: TimesheetBlockInListComponent(timesheetBlock: block),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadTimeSheet(null);
  }

  void _loadTimeSheet(DateTime? dateTime) async {
    setState(() {
      _isLoading = true;
    });

    DateTime selectedUtc = dateTime != null ? dateTime.toUtc() : DateTime.now();
    DateTime startOfDay = DateTime(selectedUtc.year, selectedUtc.month, selectedUtc.day);
    Response<Timesheet> response = await TimesheetApi.getTimesheet(sessionId: widget.session.id, date: startOfDay.millisecondsSinceEpoch ~/ 1000);
    if(!mounted) return;

    setState(() {
      _isLoading = false;
    });

    switch(response.status) {
      case -1:
        debugPrint("Request failed");
        Future<void>.delayed(Duration.zero, () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Er is iets verkeerd gegaan. Probeer het later opnieuw. (E1)")));
        });
        break;
      case 200:
        setState(() {
          _timesheet = response.value!;
        });
        break;
      default:
        debugPrint("Got status code ${response.status}");
        Future<void>.delayed(Duration.zero, () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message!)));
        });
        break;
    }

    // TODO
  }
}