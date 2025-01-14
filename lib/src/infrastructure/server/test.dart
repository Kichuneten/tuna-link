import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tunalink/src/application/storage/userInfoStorage.dart';
import 'package:tunalink/src/infrastructure/server/server_info.dart';

Future<String> testget() async {
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

Future<Uint8List> testimage() async {
  debugPrint("hi");
  try {
    var url = Uri.https(httpBaseUrl, '/test_img');
    var response = await http.get(url);
    debugPrint("status:${response.statusCode.toString()}");
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception("failed to fetch the file");
    }
  } finally {}
}



Future testpost(String message) async {
  //トークンを取得しストレージに保存
  String? idToken = await saveTokenToSecureStorage();
  // debugPrint(idToken);

  if (idToken == null) {
    debugPrint("ID Token is null");
    throw Exception('ID Token is null');
  }

  //userNameを保存（他のカラムはdefault値あり）
  final url = Uri.https(httpBaseUrl, '/post');
  try {
    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        "Custom-authorization": 'Bearer $idToken', // トークンをヘッダーに追加
      },
      body: jsonEncode({'message': message}),
    );
  } catch (err) {
    debugPrint('Error<saveUserToDB>:$err');
  }
}
