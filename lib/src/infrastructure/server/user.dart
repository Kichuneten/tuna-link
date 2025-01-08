import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tunalink/src/application/storage/userInfoStorage.dart';
import 'package:tunalink/src/infrastructure/server/server_info.dart';
import 'package:http/http.dart' as http;

//usersテーブルにusenameとuidを置きに行くpost
//?useridとかusertextとかはデフォ値があるので無視
Future saveUserToDB(String username) async {
  //トークンを取得しストレージに保存
  String? idToken = await saveTokenToSecureStorage();
  // debugPrint(idToken);

  if (idToken == null) {
    debugPrint("ID Token is null");
    throw Exception('ID Token is null');
  }

  //userNameを保存（他のカラムはdefault値あり）
  final url = Uri.https(httpBaseUrl, '/user');
  try {
    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        "Custom-authorization": 'Bearer $idToken', // トークンをヘッダーに追加
      },
      body: jsonEncode({'username': username}),
    );
  } catch (err) {
    debugPrint('Error<saveUserToDB>:$err');
  }
}
