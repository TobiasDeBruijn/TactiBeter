// ignore_for_file: unnecessary_cast

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
    List<Widget> children = {
      WeekSelector(onChange: (newWeek) => _loadSchedule(weekNumber: newWeek)) as Widget,
    }.toList(growable: true);

    if(_isLoading) {
      children.add(_getIsLoading() as Widget);
    } else {
      _scheduleDays.sort((a, b) => a.date.compareTo(b.date));

      List<Widget> scheduleComponents = _scheduleDays.map(_getScheduleDay).toList();
      if(scheduleComponents.isEmpty) {
        children.add(_getNoScheduleAvailableText() as Widget);
      } else {
        for(Widget w in scheduleComponents) {
          children.add(w as Widget);
        }
      }
    }

    return ListView(
      children: children,
    );
  }

  Widget _getIsLoading() {
    return const Align(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
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