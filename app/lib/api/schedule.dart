import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tactibetter/api/api_common.dart';
import 'package:tactibetter/api/proto/payloads/schedule.pb.dart';

class ScheduleDay {
  final DateTime date;
  final DateTime begin;
  final DateTime end;
  final List<ScheduleEntry> scheduleEntries;

  const ScheduleDay({required this.date, required this.begin, required this.end, required this.scheduleEntries});
}

class ScheduleEntry {
  final DateTime begin;
  final DateTime end;
  final DateTime created;
  final String task;
  final String department;

  const ScheduleEntry({required this.begin, required this.end, required this.created, required this.task, required this.department});
}

class Schedule {
  static Future<Response<List<ScheduleDay>>> getSchedule(String sessionId, {int? weekNumber}) async {
    String maybeQuery = "";
    if(weekNumber != null) {
      maybeQuery = "?week_number=$weekNumber";
    }

    try {
      http.Response response = await http.get(Uri.parse("$server/v1/schedule$maybeQuery"),
        headers: getHeaders(sessionId),
      );

      if(response.statusCode != 200) {
        return Response.fail(response);
      }

      GetScheduleResponse getScheduleResponse = GetScheduleResponse.fromBuffer(response.bodyBytes);
      List<ScheduleDay> scheduleDays = getScheduleResponse.scheduleDays.map((day) => ScheduleDay(
          date: epochToDateTimeLocal(day.date.toInt()),
          begin: epochToDateTimeLocal(day.begin.toInt()),
          end: epochToDateTimeLocal(day.end.toInt()),
          scheduleEntries: day.scheduleEntries.map((entry) => ScheduleEntry(
              begin: epochToDateTimeLocal(entry.begin.toInt()),
              end: epochToDateTimeLocal(entry.end.toInt()),
              created: epochToDateTimeLocal(entry.created.toInt()),
              task: entry.task,
              department: entry.department)
          ).toList()
      )).toList();

      return Response.ok(scheduleDays);
    } on SocketException catch(e) {
      return Response.connFail(e);
    }
  }
}