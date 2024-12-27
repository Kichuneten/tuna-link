import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tunalink/src/infrastructure/server/server_info.dart';

Future<String> testget() async {
  debugPrint("hi");
  try {
    var url = Uri.http(httpBaseUrl, '/test');
    var response = await http.get(url);
    debugPrint(
        "status:${response.statusCode.toString()}" ", body: ${response.body}");
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "";
    }
  } finally {}
}

Future<Uint8List> testimage() async {
  debugPrint("hi");
  try {
    var url = Uri.http(httpBaseUrl, '/test_img');
    var response = await http.get(url);
    debugPrint(
        "status:${response.statusCode.toString()}");
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception("failed to fetch the file");
    }
  } finally {}
}
