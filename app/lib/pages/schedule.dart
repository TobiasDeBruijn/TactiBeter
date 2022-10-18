import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tactibeter/api/api_common.dart';
import 'package:tactibeter/api/login.dart';
import 'package:tactibeter/api/schedule.dart';
import 'package:tactibeter/components/schedule/schedule_day.dart';
import 'package:tactibeter/components/weekselector.dart';

class SchedulePage extends StatefulWidget {
  final Session session;
  const SchedulePage({Key? key, required this.session}) : super(key: key);

  @override
  State<SchedulePage> createState() => _ScheduleState();
}

class _ScheduleState extends State<SchedulePage> {
  List<ScheduleDay> _scheduleDays = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        WeekSelector(onChange: (newWeek) => _loadSchedule(weekNumber: newWeek)),
        _isLoading ? _getIsLoading() : _getIsLoaded(),
        _getDebugButtons(),
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
    _scheduleDays.sort((a, b) => a.date.compareTo(b.date));

    List<Widget> scheduleComponents = _scheduleDays.map(_getScheduleDay).toList();
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

  Widget _getScheduleDay(ScheduleDay day) {
    return Card(
      child: InkWell(
        onTap: () => {},
        child: ScheduleDayComponent(scheduleDay: day),
      ),
    );
  }

  @override void initState() {
    super.initState();
    _loadSchedule();
  }

  Widget _getDebugButtons() {
    return const SizedBox.shrink();

    if(kReleaseMode) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          child: const Text("Set fake schedule"),
          onPressed: () {
            DateTime localNow = DateTime.now().toLocal();
            setState(() {
              _scheduleDays = [
                ScheduleDay(
                    date: localNow,
                    begin: localNow,
                    end: localNow.add(const Duration(hours: 5)),
                    scheduleEntries: [
                      ScheduleEntry(
                          begin: localNow,
                          end: localNow.add(const Duration(hours: 1)),
                          created: localNow.subtract(const Duration(days: 5)),
                          department: "Example dep",
                          task: "Task A",
                      ),
                      ScheduleEntry(
                          begin: localNow.add(const Duration(hours: 1)),
                          end: localNow.add(const Duration(hours: 3)),
                          created: localNow.subtract(const Duration(days: 5)),
                          department: "Example dep",
                          task: "Task B"
                      ),
                      ScheduleEntry(
                          begin: localNow.add(const Duration(hours: 3)),
                          end: localNow.add(const Duration(hours: 7)),
                          created: localNow.subtract(const Duration(days: 5)),
                          department: "Example dep",
                          task: "Task C"
                      ),
                    ]
                )
              ];
            });
          },
        )
      ],
    );
  }

  void _loadSchedule({int? weekNumber}) async {
    setState(() {
      _isLoading = true;
    });

    Response<List<ScheduleDay>> response = await Schedule.getSchedule(widget.session.id, weekNumber: weekNumber);
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
          _scheduleDays = response.value!;
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