import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tactibetter/util/datetime.dart';

class WeekSelector extends StatefulWidget {
  final Function(int newWeek) onChange;

  const WeekSelector({super.key, required this.onChange});

  @override
  State<WeekSelector> createState() => _WeekSelectorState();
}

class _WeekSelectorState extends State<WeekSelector> {
  late int _weekNumber;

  @override
  void initState() {
    super.initState();
    _weekNumber = _currentWeekNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              customBorder: const CircleBorder(),
              child: const Icon(Icons.arrow_left, size: 30),
              onTap: () {
                setState(() {
                  if(_weekNumber - 1 < 1) {
                    _weekNumber = 52;
                  } else {
                    _weekNumber -= 1;
                  }
                });

                widget.onChange(_weekNumber);
              },
            ),
            Text(
              _getWeekString(),
              key: ValueKey<String>(_getWeekString()),
              style: GoogleFonts.oxygen(fontSize: 25),
            ),
            InkWell(
              customBorder: const CircleBorder(),
              child: const Icon(Icons.arrow_right, size: 30),
              onTap: () {
                setState(() {
                  if(_weekNumber + 1 > 52) {
                    _weekNumber = 1;
                  } else {
                    _weekNumber += 1;
                  }
                });

                widget.onChange(_weekNumber);
              },
            ),
          ],
        ),
      ),
    );
  }

  static int _currentWeekNumber() {
    return DateTime.now().toLocal().isoWeekNumber();
  }

  String _getWeekString() {
    int currentIsoWeek = _currentWeekNumber();

    if(_weekNumber == currentIsoWeek) {
      return "Deze week";
    } else if (_weekNumber == currentIsoWeek + 1) {
      return "Volgende week";
    } else if (_weekNumber == currentIsoWeek - 1) {
      return "Vorige week";
    } else {
      return "Week $_weekNumber";
    }
  }
}