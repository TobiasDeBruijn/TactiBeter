import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tactibetter/api/schedule.dart';
import 'package:google_fonts/google_fonts.dart';

class ScheduleComponent extends StatelessWidget {
  final ScheduleEntry scheduleEntry;

  final DateFormat _dateOnlyFormat = DateFormat("dd-MM");
  final DateFormat _timeOnlyFormat = DateFormat("HH:mm");
  final DateFormat _weekDayFormay = DateFormat("EEEE");

  ScheduleComponent({Key? key, required this.scheduleEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        children: [
          Text(
            "${_weekDayFormay.format(scheduleEntry.date)} ${_dateOnlyFormat.format(scheduleEntry.date)}",
            style: GoogleFonts.oxygen(fontSize: 20)
          ),
          Text(
            "${_timeOnlyFormat.format(scheduleEntry.begin)} - ${_timeOnlyFormat.format(scheduleEntry.end)}",
            style: GoogleFonts.oxygen()
          ),
          Text(
            "${scheduleEntry.department} - ${scheduleEntry.task}",
            style: GoogleFonts.oxygen()
          ),
        ],
      ),
    );
  }
}