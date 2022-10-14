import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tactibetter/api/timesheet.dart';
import 'package:tactibetter/util/datetime.dart';

class TimesheetBlockViewPage extends StatefulWidget {
  final TimesheetBlock timesheetBlock;

  const TimesheetBlockViewPage({super.key, required this.timesheetBlock});

  @override
  State<TimesheetBlockViewPage> createState() => _TimesheetBlockViewState();
}

class _TimesheetBlockViewState extends State<TimesheetBlockViewPage> {

  late TimeOfDay _start;

  @override
  void initState() {
    super.initState();
    _start = TimeOfDay(hour: widget.timesheetBlock.begin.hour, minute: widget.timesheetBlock.begin.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FloatingActionButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back),
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${weekDayFormat.format(widget.timesheetBlock.date)} - ${dateOnlyFormat.format(widget.timesheetBlock.date)}",
            style: GoogleFonts.oxygen(fontSize: 30, fontWeight: FontWeight.bold)
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: ,
              )
            ],
          )
        ],
      )
    );
  }


  void _selectStartTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _start,
    );

    if (newTime != null) {
      setState(() {
        _start = newTime;
      });
    }
  }
}