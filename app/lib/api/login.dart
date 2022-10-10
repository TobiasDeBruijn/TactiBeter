import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tactibetter/api/api_common.dart';
import 'package:tactibetter/api/proto/payloads/login.pb.dart';
import 'package:tactibetter/api/proto/payloads/session.pb.dart';

class Session {
  final String id;
  final int expiry;

  Session({required this.id, required this.expiry});
}

class Login {
  static Future<Response<Session>> login(String username, String password) async {
    try {
      http.Response response = await http.post(Uri.parse("$server/v1/login"),
        headers: getProtobufHeaders(),
        body: LoginRequest(username: username, password: password).writeToBuffer()
      );

      if(response.statusCode == 200) {
        LoginResponse loginResponse = LoginResponse.fromBuffer(response.bodyBytes);
        return Response.ok(Session(id: loginResponse.sessionid, expiry: loginResponse.expiresAt.toInt()));
      } else {
        return Response.fail(response);
      }
    } on SocketException catch(e) {
      return Response.connFail(e);
    }
  }

  static Future<Response<Session>> checkSession(String id) async {
    try {
      http.Response response = await http.post(Uri.parse("$server/v1/session"), 
        headers: getHeaders(id),
      );

      if(response.statusCode == 200) {
        GetSessionResponse getSessionResponse = GetSessionResponse.fromBuffer(response.bodyBytes);
        return Response.ok(Session(id: id, expiry: getSessionResponse.expiry.toInt()));
      } else {
        return Response.fail(response);
      }
    } on SocketException catch(e) {
      return Response.connFail(e);
    }
  }
}