import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tactibeter/api/timesheet.dart';
import 'package:tactibeter/util/datetime.dart';

class TimesheetBlockViewPage extends StatefulWidget {
  final TimesheetBlock? timesheetBlock;
  final List<NamedId> departments, taskGroups;
  final DateTime? createForDateTime;
  
  final String title;

  const TimesheetBlockViewPage({super.key, this.timesheetBlock, required this.title, required this.departments, required this.taskGroups, this.createForDateTime});

  @override
  State<TimesheetBlockViewPage> createState() => _TimesheetBlockViewState();
}

class _TimesheetBlockViewState extends State<TimesheetBlockViewPage> {

  late TimesheetBlock _updatedTimeSheet;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    if(widget.timesheetBlock == null) {
      DateTime date = widget.createForDateTime ?? DateTime.now().toLocal().roundDown();

      DateTime end = date.roundDown(delta: const Duration(minutes: 15));
      DateTime begin = end.subtract(const Duration(hours: 4));

      _updatedTimeSheet = TimesheetBlock(
        begin: begin,
        end: end,
        department: widget.departments.first.id,
        taskGroup: widget.taskGroups.first.id,
        date: DateTime(date.year, date.month, date.day),
        isApproved: false,
        isSubmitted: false,
      );
    } else {
      _updatedTimeSheet = widget.timesheetBlock!;
    }

    _startTime = TimeOfDay(hour: _updatedTimeSheet.begin.hour, minute: _updatedTimeSheet.begin.minute);
    _endTime = TimeOfDay(hour: _updatedTimeSheet.end.hour, minute: _updatedTimeSheet.end.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.oxygen(fontSize: 30),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop(_updatedTimeSheet);
        },
        tooltip: "Opslaan",
        child: const Icon(Icons.save),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${weekDayFormat.format(_updatedTimeSheet.date)} ${dateOnlyFormat.format(_updatedTimeSheet.date)}",
              style: GoogleFonts.oxygen(fontSize: 30, fontWeight: FontWeight.bold)
            ),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: [
                TableRow(
                  children: [
                    _getTextCell("Startijd"),
                    Card(
                      child: InkWell(
                        onTap: () => _selectStartTime(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _startTime.format(context),
                            style: GoogleFonts.oxygen(fontSize: 25),
                          ),
                        ),
                      ),
                    ),
                  ]
                ),
                TableRow(
                  children: [
                    _getTextCell("Eindtijd"),
                    Card(
                      child: InkWell(
                        onTap: () => _selectEndTime(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _endTime.format(context),
                            style: GoogleFonts.oxygen(fontSize: 25),
                          ),
                        ),
                      )
                    )
                  ]
                ),
                TableRow(
                  children: [
                    _getTextCell("Departement"),
                    _SelectCard(
                      initialValue: _updatedTimeSheet.department,
                      values: widget.departments,
                      onChange: (value) => setState(() {
                        _updatedTimeSheet.department = value;
                      })
                    ),
                  ]
                ),
                TableRow(
                  children: [
                    _getTextCell("Taak"),
                    _SelectCard(
                      initialValue: _updatedTimeSheet.taskGroup,
                      values: widget.taskGroups,
                      onChange: (value) => setState(() {
                        _updatedTimeSheet.taskGroup = value;
                      })
                    ),
                  ]
                ),
                TableRow(
                  children: [
                    _getTextCell("Opgegeven"),
                    _getTextCell(_updatedTimeSheet.isSubmitted ? "Ja" : "Nee"),
                  ]
                ),
                TableRow(
                  children: [
                    _getTextCell("Akkoord"),
                    _getTextCell(_updatedTimeSheet.isApproved ? "Ja" : "Nee"),
                  ]
                )
              ],
            )
          ],
        ),
      )
    );
  }

  TableCell _getTextCell(String text) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Text(
          text,
          style: GoogleFonts.oxygen(fontSize: 25)
      ),
    );
  }

  void _selectStartTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );

    if (newTime != null) {
      setState(() {
        _updatedTimeSheet.begin = DateTime(
          _updatedTimeSheet.begin.year,
          _updatedTimeSheet.begin.month,
          _updatedTimeSheet.begin.day,
          newTime.hour,
          newTime.minute,
        );
        _startTime = newTime;
      });
    }
  }

  void _selectEndTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );

    if(newTime != null) {
      setState(() {
        _updatedTimeSheet.end = DateTime(
          _updatedTimeSheet.end.year,
          _updatedTimeSheet.end.month,
          _updatedTimeSheet.end.day,
          newTime.hour,
          newTime.minute,
        );
        _endTime = newTime;
      });
    }
  }
}

class _SelectCard extends StatelessWidget {
  final String initialValue;
  final List<NamedId> values;
  final Function(String value) onChange;

  const _SelectCard({super.key, required this.initialValue, required this.values, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButton(
          value: initialValue,
          items: values.map((e) => DropdownMenuItem(
            value: e.id,
            child: Text(
                e.name
            ),
          )).toList(),
          isExpanded: true,
          onChanged: (value) => onChange(value!),
        ),
      ),
    );
  }
}