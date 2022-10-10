import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tactibetter/api/api_common.dart';
import 'package:tactibetter/api/login.dart';
import 'package:tactibetter/api/schedule.dart';
import 'package:tactibetter/components/schedule.dart';
import 'package:tactibetter/components/weekselector.dart';

class SchedulePage extends StatefulWidget {
  final Session session;
  const SchedulePage({Key? key, required this.session}) : super(key: key);

  @override
  State<SchedulePage> createState() => _ScheduleState();
}

class _ScheduleState extends State<SchedulePage> {
  List<ScheduleEntry> _scheduleEntries = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WeekSelector(onChange: (newWeek) => _loadSchedule(weekNumber: newWeek)),
        _isLoading ? _getIsLoading() : _getIsLoaded(),
      ],
    );
  }

  Widget _getIsLoading() {
    return const Align(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }

  Widget _getIsLoaded() {
    List<Widget> scheduleComponents = _scheduleEntries.map(_getScheduleComponent).toList();
    return Column(
      children: [
        scheduleComponents.isNotEmpty ? _getScheduleListView(scheduleComponents) : _getNoScheduleAvailableText()
      ],
    );
  }

  ListView _getScheduleListView(List<Widget> children) {
    return ListView(
      shrinkWrap: true,
      children: children,
    );
  }

  Text _getNoScheduleAvailableText() {
    return Text(
      "Er is geen rooster bekend voor deze week",
      style: GoogleFonts.oxygen(fontSize: 20),
      textAlign: TextAlign.center,
    );
  }

  Widget _getScheduleComponent(ScheduleEntry entry) {
    return Card(
      child: InkWell(
        onTap: () => {},
        child: ScheduleComponent(scheduleEntry: entry),
      ),
    );
  }

  @override void initState() {
    super.initState();
    _loadSchedule();
  }

  void _loadSchedule({int? weekNumber}) async {
    setState(() {
      _isLoading = true;
    });

    Response<List<ScheduleEntry>> response = await Schedule.getSchedule(widget.session.id, weekNumber: weekNumber);
    if(!mounted) return;

    setState(() {
      _isLoading = false;
    });

    switch(response.status) {
      case -1:
        debugPrint("Request failed");
        Future<void>.delayed(Duration.zero, () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Er is iets verkeerd gegaan. Probeer het later opnieuw.")));
        });
        break;
      case 200:
        setState(() {
          _scheduleEntries = response.value!;
        });
        break;
      default:
        debugPrint("Got status code ${response.status}");
        Future<void>.delayed(Duration.zero, () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message!)));
        });
        break;
    }
  }
}