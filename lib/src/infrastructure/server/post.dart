import 'package:flutter/material.dart';
import 'package:tunalink/src/application/storage/userInfoStorage.dart';
import 'package:tunalink/src/infrastructure/server/server_info.dart';

import 'package:http/http.dart' as http;

Future<String> testpostget() async {
  debugPrint("hi");
  try {
    //トークンを取得しストレージに保存
    String? idToken = await saveTokenToSecureStorage();

    if (idToken == null) {
      debugPrint("ID Token is null");
      throw Exception('ID Token is null');
    }

    var url = Uri.https(httpBaseUrl, '/post');

    // debugPrint("idToken: $idToken");

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        "Custom-authorization": 'Bearer $idToken', // トークンをヘッダーに追加
      },
    );

    debugPrint(
        "status:${response.statusCode.toString()}" ", body: ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "";
    }
  } finally {}
}

Future<String> testsearchpost({String query = "", int after = -1}) async {
  debugPrint("hi");
  try {
    //トークンを取得しストレージに保存
    String? idToken = await saveTokenToSecureStorage();

    if (idToken == null) {
      debugPrint("ID Token is null");
      throw Exception('ID Token is null');
    }

    var url = Uri.https(httpBaseUrl, '/search_posts',
        <String, String>{'searchQuery': query, 'after': after.toString()});

    // debugPrint("idToken: $idToken");

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        "Custom-authorization": 'Bearer $idToken', // トークンをヘッダーに追加
      },
    );

    debugPrint(
        "status:${response.statusCode.toString()}" ", body: ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "";
    }
  } finally {}
}
