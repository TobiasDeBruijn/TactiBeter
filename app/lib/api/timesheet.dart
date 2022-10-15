import 'dart:io';

import 'api_common.dart';
import 'package:http/http.dart' as http;
import 'package:tactibetter/api/proto/entities/timesheet.pb.dart' as proto;

class Timesheet {
  final List<NamedId> departments, taskGroups;
  final String? note;
  final List<TimesheetBlock> blocks;

  const Timesheet({required this.departments, required this.taskGroups, required this.blocks, this.note});
}

class NamedId {
  final String id, name;

  const NamedId({required this.id, required this.name});
}

class TimesheetBlock {
  DateTime date, begin, end;
  String department, taskGroup;
  final bool isSubmitted, isApproved;

  TimesheetBlock({required this.date, required this.begin, required this.end, required this.department, required this.taskGroup, required this.isSubmitted, required this.isApproved});
}

class TimesheetApi {
  static Future<Response<Timesheet>> getTimesheet({required String sessionId, int? date}) async {
    String queryString = date != null ? "?date=$date" : "";

    try {
      http.Response response = await http.get(Uri.parse("$server/v1/timesheet$queryString"),
        headers: getHeaders(sessionId),
      );

      switch(response.statusCode) {
        case 200:
          proto.Timesheet timesheet = proto.Timesheet.fromBuffer(response.bodyBytes);
          Timesheet sheet = Timesheet(
            note: timesheet.noteText.isEmpty ? null : timesheet.noteText,
            departments: timesheet.departments.map((e) => NamedId(id: e.id, name: e.name)).toList(),
            taskGroups: timesheet.taskGroups.map((e) => NamedId(id: e.id, name: e.name)).toList(),
            blocks: timesheet.blocks.map((e) => TimesheetBlock(
              date: epochToDateTimeLocal(e.date.toInt()),
              begin: epochToDateTimeLocal(e.begin.toInt()),
              end: epochToDateTimeLocal(e.end.toInt()),
              department: e.department,
              taskGroup: e.task,
              isApproved: e.approved,
              isSubmitted: e.submitted
            )).toList()
          );

          return Response.ok(sheet);
        default:
          return Response.fail(response);
      }
    } on SocketException catch(e) {
      return Response.connFail(e);
    }
  }
}