import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//const String server = "https://api.array21.dev/tactibetter/api";
//const String server = "http://145.107.89.232:8080/api";
const String server = "http://10.10.5.1:8080/api";

Map<String, String> getProtobufHeaders() {
  return {
    'Content-Type': 'application/protobuf',
    'Accept': 'application/protobuf'
  };
}

Map<String, String> getHeaders(String sessionId) {
  Map<String, String> headers = getProtobufHeaders();
  headers['Authorization'] = sessionId;

  return headers;
}

DateTime epochToDateTimeLocal(int epoch) {
  DateTime dt = DateTime.fromMillisecondsSinceEpoch(epoch * 1000, isUtc: true);
  return dt.toLocal();
}

class Response<T> {
  late final int status;
  late final String? message;

  late final T? value;

  Response.ok(this.value) {
    status = 200;
  }

  Response.connFail(SocketException e) {
    status = -1;
    message = e.message;

    debugPrint("Failed to send request: $message");
  }

  Response.fail(http.Response response) {
    status = response.statusCode;
    if(response.body == "") {
      message = "Er is iets verkeerd gegaan, probeer het later opnieuw (E0)";
    } else {
      message = response.body;
    }

    debugPrint("Got HTTP status $status: $message");
  }

  bool handleNotOk(BuildContext context) {
    if(status == 200) {
      return true;
    } else {
      _showSnackbar(context);
      return false;
    }
  }

  void _showSnackbar(BuildContext context) {
    Future<void>.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message!)));
    });
  }
}