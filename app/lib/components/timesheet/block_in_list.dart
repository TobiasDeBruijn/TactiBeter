import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tactibetter/api/timesheet.dart';
import 'package:tactibetter/util/datetime.dart';

class TimesheetBlockInListComponent extends StatelessWidget {
  final TimesheetBlock timesheetBlock;

  const TimesheetBlockInListComponent({super.key, required this.timesheetBlock});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${timeOnlyFormat.format(timesheetBlock.begin)} - ${timeOnlyFormat.format(timesheetBlock.end)}",
            style: GoogleFonts.oxygen(fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Opgegeven: ${timesheetBlock.isSubmitted ? "Ja" : "Nee"}",
                  style: GoogleFonts.oxygen()
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Akkoord: ${timesheetBlock.isApproved ? "Ja" : "Nee" }",
                ),
              )
            ],
          )
        ]
      ),
    );
  }
}