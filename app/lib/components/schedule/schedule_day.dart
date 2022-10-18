import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:tactibeter/api/schedule.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tactibeter/components/schedule/schedule_entry.dart';
import 'package:tactibeter/util/datetime.dart';

class ScheduleDayComponent extends StatelessWidget {
  final ScheduleDay scheduleDay;

  const ScheduleDayComponent({Key? key, required this.scheduleDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        children: [
          Text(
            "${weekDayFormat.format(scheduleDay.date)} ${dateOnlyFormat.format(scheduleDay.date)}",
            style: GoogleFonts.oxygen(fontSize: 20)
          ),
          Text(
            "${timeOnlyFormat.format(scheduleDay.begin)} - ${timeOnlyFormat.format(scheduleDay.end)}",
            style: GoogleFonts.oxygen()
          ),
          _getScheduleDetails(),
        ],
      ),
    );
  }

  /// Returns the Department and Task of the schedule if there's only 1 child entry.
  /// if there are multiple, it'll return an expansion panel containing all children
  Widget _getScheduleDetails() {
    if(scheduleDay.scheduleEntries.length == 1) {
      ScheduleEntry scheduleEntry = scheduleDay.scheduleEntries[0];
      return Text(
        "${scheduleEntry.department} - ${scheduleEntry.task}",
        style: GoogleFonts.oxygen()
      );
    } else {
      return ExpandableNotifier(
        child: Column(
          children: [
            Expandable(
              collapsed: ExpandableButton(
                child: Column(
                  children: [
                    Text("Show ${scheduleDay.scheduleEntries.length} tasks"),
                    const Icon(Icons.expand_more),
                  ],
                ),
              ),
              expanded:ExpandableButton(
                child: Column(
                  children: _getExpandedChildren(),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  List<Widget> _getExpandedChildren() {
    // IDE complains that the cast isnt necessary, it is.
    List<Widget> scheduleEntries = scheduleDay.scheduleEntries.map((e) => ScheduleEntryComponent(scheduleEntry: e) as Widget).toList();

    scheduleEntries.add(const Icon(Icons.expand_less));

    return scheduleEntries;
  }
}