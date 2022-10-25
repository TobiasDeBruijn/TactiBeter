import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tactibeter/util/datetime.dart';

class DaySelectorComponent extends StatefulWidget {
  final Function(DateTime dateTime) onChange;

  const DaySelectorComponent({super.key, required this.onChange});

  @override
  State<DaySelectorComponent> createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelectorComponent> {

  late DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now().toLocal();
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
                  _dateTime = _dateTime.subtract(const Duration(days: 1));
                });

                widget.onChange(_dateTime);
              },
            ),
            Text(
              _getDayString(),
              key: ValueKey<String>(_getDayString()),
              style: GoogleFonts.oxygen(fontSize: 25)
            ),
            InkWell(
              customBorder: const CircleBorder(),
              child: const Icon(Icons.arrow_right, size: 30),
              onTap: () {
                setState(() {
                  _dateTime = _dateTime.add(const Duration(days: 1));
                });

                widget.onChange(_dateTime);
              },
            )
          ],
        ),
      ),
    );
  }

  String _getDayString() {
    DateTime now = DateTime.now().toLocal();
    Duration delta = now.difference(_dateTime);

    if(delta.inHours < 24) {
      return "Vandaag";
    }

    if(_dateTime.isAfter(now)) {
      // In the future
      if(delta.inDays == 1) {
        return "Morgen";
      }

      if(delta.inDays == 2) {
        return "Overmorgen";
      }
    } else {
      // In the past
      if(delta.inDays == 1) {
        return "Gisteren";
      }

      if(delta.inDays == 2) {
        return "Eergisteren";
      }
    }

    return "${weekDayFormat.format(_dateTime)} ${dateOnlyFormat.format(_dateTime)}";
  }
}