import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tactibetter/api/api_common.dart';
import 'package:tactibetter/api/proto/payloads/schedule.pb.dart';
import 'package:tactibetter/api/proto/entities/schedule.pb.dart' as proto_schedule;

class ScheduleEntry {
  final DateTime date;
  final DateTime begin;
  final DateTime end;
  final DateTime created;
  final String task;
  final String department;

  const ScheduleEntry({required this.date, required this.begin, required this.end, required this.created, required this.task, required this.department});
}

class Schedule {
  static Future<Response<List<ScheduleEntry>>> getSchedule(String sessionId, {int? weekNumber}) async {
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
      List<ScheduleEntry> entries = getScheduleResponse.schedules.map(_scheduleToScheduleEntry).toList();

      return Response.ok(entries);
    } on SocketException catch(e) {
      return Response.connFail(e);
    }
  }

  static ScheduleEntry _scheduleToScheduleEntry(proto_schedule.Schedule schedule) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(schedule.date.toInt() * 1000, isUtc: true);
    DateTime begin = DateTime.fromMillisecondsSinceEpoch(schedule.begin.toInt() * 1000, isUtc: true);
    DateTime end = DateTime.fromMillisecondsSinceEpoch(schedule.end.toInt() * 1000, isUtc: true);
    DateTime created = DateTime.fromMillisecondsSinceEpoch(schedule.created.toInt() * 1000, isUtc: true);

    return ScheduleEntry(
      date: date.toLocal(),
      begin: begin.toLocal(),
      end: end.toLocal(),
      created: created.toLocal(),
      department: schedule.department,
      task: schedule.task
    );
  }
}