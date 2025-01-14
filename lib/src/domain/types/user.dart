import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:tunalink/src/infrastructure/server/server_info.dart';

class MyUser {
  //*constructor
  MyUser({
    required this.userName,
    required this.userID,
    required this.userIconPath, //iconのファイル名
    required this.userText,
    // required this.followerList,
    // required this.followeeList,
    // required this.postsNum,
  });

  String userName;
  String userID;
  String userIconPath;
  String userText;
  // List<String> followeeList;
  // List<String> followerList;
  // int postsNum;
  //*constructor

  //JsonからUserクラスを作成するfactory
  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      userName: json['username'] as String,
      userID: json['userid'] as String,
      userIconPath: (json['usericon'] ?? "null") as String,
      userText: json['usertext'] as String,
      // followeeList: json['followeeList'].cast<String>() as List<String>,
      // followerList: json['followerList'].cast<String>() as List<String>,
      // postsNum: json['postsnum'] as int,
    );
  }

//iconをサーバーからfetchしてImageウィジットを構成。
  Future<Uint8List> fetchIcon() async {
    final response =
        await http.get(Uri.http(httpBaseUrl, '/user_icons/$userIconPath'));

    if (response.statusCode == 200) {
      return response.bodyBytes; //画像のデータ
    } else {
      throw Exception('アイコンの取得に失敗しました');
    }
  }
}
