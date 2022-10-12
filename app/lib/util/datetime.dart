import 'package:intl/intl.dart';

final DateFormat dateOnlyFormat = DateFormat("dd-MM");
final DateFormat timeOnlyFormat = DateFormat("HH:mm");
final DateFormat weekDayFormat = DateFormat("EEEE");

int isoWeekNumber(DateTime date) {
  int daysToAdd = DateTime.thursday - date.weekday;
  DateTime thursdayDate = daysToAdd > 0 ? date.add(Duration(days: daysToAdd)) : date.subtract(Duration(days: daysToAdd.abs()));
  int dayOfYearThursday = dayOfYear(thursdayDate);
  return 1 + ((dayOfYearThursday - 1) / 7).floor();
}

int dayOfYear(DateTime date) {
  return date.difference(DateTime(date.year, 1, 1)).inDays;
}