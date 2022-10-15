import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tactibetter/api/api_common.dart';
import 'package:tactibetter/api/login.dart';
import 'package:tactibetter/api/timesheet.dart';
import 'package:tactibetter/components/day_selector.dart';
import 'package:tactibetter/components/timesheet/block_in_list.dart';
import 'package:tactibetter/pages/timesheet/view_block.dart';

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
        onPressed: () async {
          TimesheetBlock? result = await Navigator.of(context).push(MaterialPageRoute(builder: (builder) => TimesheetBlockViewPage(
              title: "Aanmaken",
              departments: _timesheet!.departments,
              taskGroups: _timesheet!.taskGroups,
              createForDateTime: DateTime.now().toLocal(),
          )));

          if(result == null) return;

          // TODO save to API
          setState(() {
            _timesheet!.blocks.add(result);
          });
        },
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
      children: List.generate(_timesheet!.blocks.length, (idx) => _EditableTimesheetBlock(
          value: _timesheet!.blocks[idx],
          departments: _timesheet!.departments,
          taskGroups: _timesheet!.taskGroups,
          onChange: (newValue) => setState(() => _timesheet!.blocks[idx] = newValue))
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

class _EditableTimesheetBlock extends StatelessWidget {
  final TimesheetBlock value;
  final List<NamedId> departments, taskGroups;
  final Function(TimesheetBlock value) onChange;

  const _EditableTimesheetBlock({super.key, required this.value, required this.departments, required this.taskGroups, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () async {
          TimesheetBlock? result = await Navigator.of(context).push(MaterialPageRoute(builder: (builder) => TimesheetBlockViewPage(
            timesheetBlock: value,
            title: "Bewerken",
            departments: departments,
            taskGroups: taskGroups,
          )));
          if(result == null) return;

          // TODO save the block

          onChange(result);
        },
        child: TimesheetBlockInListComponent(timesheetBlock: value),
      ),
    );
  }
}