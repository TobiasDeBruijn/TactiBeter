import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tactibeter/api/schedule.dart';
import 'package:tactibeter/util/datetime.dart';

class ScheduleEntryComponent extends StatelessWidget {
  final ScheduleEntry scheduleEntry;

  const ScheduleEntryComponent({super.key, required this.scheduleEntry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${timeOnlyFormat.format(scheduleEntry.begin)} - ${timeOnlyFormat.format(scheduleEntry.end)}",
            style: GoogleFonts.oxygen(fontSize: 20),
          ),
          Text(
            "${scheduleEntry.department} - ${scheduleEntry.task}",
            style: GoogleFonts.oxygen(),
          )
        ],
      ),
    );
  }
}