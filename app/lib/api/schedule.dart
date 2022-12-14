import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tactibeter/api/api_common.dart';
import 'package:tactibeter/api/proto/payloads/schedule.pb.dart';
import 'package:tactibeter/util/datetime.dart';

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
    if(sessionId == "developeraccess") {
      Duration roundTo = const Duration(hours: 1);
      DateTime nowLocal = DateTime.now().toLocal();

      if(weekNumber != null) {
        int weekNow = nowLocal.isoWeekNumber();
        int delta = weekNumber - weekNow;

        if(delta > 0) {
          nowLocal = nowLocal.add(Duration(days: delta * 7));
        } else {
          nowLocal = nowLocal.subtract(Duration(days: delta.abs() * 7));
        }
      }

      return Response.ok([
        ScheduleDay(
          begin: nowLocal.roundDown(delta: roundTo),
          end: nowLocal.roundDown(delta: roundTo).add(const Duration(hours: 6)),
          date: nowLocal.roundDown(),
          scheduleEntries: [
            ScheduleEntry(
              begin: nowLocal.roundDown(delta: roundTo),
              end: nowLocal.roundDown(delta: roundTo).add(const Duration(hours: 3)),
              created: nowLocal.roundDown().subtract(const Duration(days: 7)),
              task: "Sort goods",
              department: "Logistics"
            ),
            ScheduleEntry(
              begin: nowLocal.roundDown(delta: roundTo).add(const Duration(hours: 3)),
              end: nowLocal.roundDown(delta: roundTo).add(const Duration(hours: 6)),
              created: nowLocal.roundDown().subtract(const Duration(days: 7)),
              task: "Cleaning",
              department: "Logistics"
            )
          ]
        )
      ]);
    }

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