import 'package:intl/intl.dart';

final DateFormat dateOnlyFormat = DateFormat("dd-MM");
final DateFormat timeOnlyFormat = DateFormat("HH:mm");
final DateFormat weekDayFormat = DateFormat("EEEE");

extension DateTimeExtension on DateTime {
  DateTime roundDown({Duration delta = const Duration(days: 1)}) {
    return DateTime.fromMillisecondsSinceEpoch(
        millisecondsSinceEpoch - millisecondsSinceEpoch % delta.inMilliseconds);
  }

  int isoWeekNumber() {
    int daysToAdd = DateTime.thursday - weekday;
    DateTime thursdayDate = daysToAdd > 0 ? add(Duration(days: daysToAdd)) : subtract(Duration(days: daysToAdd.abs()));
    int dayOfYearThursday = thursdayDate.dayOfYear();
    return 1 + ((dayOfYearThursday - 1) / 7).floor();
  }

  int dayOfYear() {
    return difference(DateTime(year, 1, 1)).inDays;
  }
}