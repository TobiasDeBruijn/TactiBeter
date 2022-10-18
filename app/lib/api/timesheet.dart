import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:tactibeter/api/proto/payloads/timesheet.pb.dart';
import 'package:tactibeter/util/datetime.dart';

import 'api_common.dart';
import 'package:http/http.dart' as http;
import 'package:tactibeter/api/proto/entities/timesheet.pb.dart' as proto;

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
    if(sessionId == "developeraccess") {
      Duration roundTo = const Duration(minutes: 15);
      DateTime nowLocal = DateTime.now().toLocal();

      if(date != null) {
        nowLocal = DateTime.fromMillisecondsSinceEpoch(date * 1000).add(Duration(hours: nowLocal.hour));
      }

      return Response.ok(
        Timesheet(
          blocks: [
            TimesheetBlock(
              date: nowLocal.roundDown(),
              begin: nowLocal.roundDown(delta: roundTo),
              end: nowLocal.roundDown(delta: roundTo).add(const Duration(hours: 3)),
              department: "0",
              taskGroup: "0",
              isSubmitted: true,
              isApproved: false,
            ),
            TimesheetBlock(
              date: nowLocal.roundDown(),
              begin: nowLocal.roundDown(delta: roundTo).add(const Duration(hours: 3)),
              end: nowLocal.roundDown(delta: roundTo).add(const Duration(hours: 6)),
              department: "0",
              taskGroup: "1",
              isSubmitted: true,
              isApproved: false,
            ),
          ],
          departments: [
            const NamedId(id: "0", name: "Logistics"),
          ],
          taskGroups: [
            const NamedId(id: "0", name: "Sort goods"),
            const NamedId(id: "1", name: "Cleaning"),
          ],
        )
      );
    }

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

  static Future<Response<void>> saveTimesheet({required String sessionId, required List<TimesheetBlock> blocks, String? note}) async {
    if(sessionId == 'developeraccess') {
      return Response.ok(null);
    }

    debugPrint("Saving time sheet");
    try {
      SaveTimesheetRequest saveTimesheetRequest = SaveTimesheetRequest(
        blocks: blocks.map((e) => proto.TimesheetBlock(
          date: Int64(e.date.millisecondsSinceEpoch ~/ 1000),
          begin: Int64(e.begin.millisecondsSinceEpoch ~/ 1000),
          end: Int64(e.end.millisecondsSinceEpoch ~/ 1000),
          department: e.department,
          task: e.taskGroup,
          approved: false,
          submitted: false,
        )).toList(),
        note: note
      );

      http.Response response = await http.post(Uri.parse("$server/v1/timesheet/set"),
        headers: getHeaders(sessionId),
        body: saveTimesheetRequest.writeToBuffer(),
      );

      switch(response.statusCode) {
        case 200:
          return Response.ok(null);
        default:
          return Response.fail(response);
      }
    } on SocketException catch(e) {
      return Response.connFail(e);
    }
  }
}