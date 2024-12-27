import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:tunalink/src/infrastructure/server/server_info.dart';

class Post {
  //constructor
  Post({
    required this.userIcon, //iconのファイル名
    required this.title,
    required this.userName,
    required this.userID,
    required this.message,
    required this.postDate,
    required this.postID,
    required this.parent,
    required this.iconData,
    required this.favolist,
    required this.commentnum,
    required this.files,
    required this.filesData,
  });

  String userIcon;
  String title;
  String userName;
  String userID;
  String message;
  String postDate;
  int postID;
  int parent; //親の投稿（コメント先）のpostid 親無しは-1
  Uint8List iconData;
  List favolist;
  int commentnum;
  List<dynamic> files;
  List<dynamic> filesData;
  //constructor

  //JsonからPostクラスを作成するfactory
  // factory（同期版）
  factory Post.fromJson(
      Map<String, dynamic> json, Uint8List iconData, List filesData) {
    // 投稿時刻のデータ
    DateTime utcTime = DateTime.parse(json['postdate']);
    // ユーザーのローカルタイムゾーンに変換
    DateTime localTime = utcTime.toLocal();
    // フォーマット
    String formattedTime =
        DateFormat('yyyy/MM/dd a hh:mm:ss').format(localTime);

    return Post(
      userIcon: json['userIcon'] as String,
      title: json['title'] as String,
      userName: json['userName'] as String,
      userID: json['userID'] as String,
      message: json['message'] as String,
      postDate: formattedTime,
      postID: json["id"],
      parent: json["parent"],
      iconData: iconData,
      filesData: filesData,
      favolist: json['favolist'],
      commentnum: json['commentnum'],
      files: json['files'] ?? [],
    );
  }

  // 静的な非同期メソッド（userIconを利用）
  static Future<Post> fromJsonAsync(Map<String, dynamic> json) async {
    // userIcon を取得
    final String userIcon = json['userIcon'] as String;

    // userIcon を利用して iconData を取得
    final Uint8List iconData = await fetchIconData(userIcon);

    final List<dynamic> files = json['files'] ?? [];

    final List<dynamic> filesData = [];
    for (var file in files) {
      filesData.add(await fetchFileData(file)); //!今のところ画像のみを想定している
    }

    // Post インスタンスを生成
    return Post.fromJson(json, iconData, filesData);
  }

  //iconのbytedataを取得する静的メソッド
  static Future<Uint8List> fetchIconData(iconpath) async {
    final response =
        await http.get(Uri.http(httpBaseUrl, '/user_icons/$iconpath'));

    if (response.statusCode == 200) {
      return response.bodyBytes; //getしたicon画像
    } else {
      throw Exception('アイコン画像の取得に失敗しました');
    }
  }

  static Future<Uint8List> fetchFileData(filepath) async {
    final response = await http.get(Uri.http(httpBaseUrl, '/file/$filepath'));

    if (response.statusCode == 200) {
      return response.bodyBytes; //getしたfile
    } else {
      throw Exception('ファイルの取得に失敗しました');
    }
  }

  Future<Image> buildIcon(double width, double height) async {
    return Image.memory(
      iconData, //getしたicon画像
      width: width, // 幅を45ピクセルに設定
      height: height, // 高さを45ピクセルに設定
      fit: BoxFit.cover,
    );
  }

  Widget fileWidget(BuildContext context, double height) {
    List<Widget> widgets = [];

    for (var i = 0; i < filesData.length; i++) {
      if (filesData.length - i == 1) {
        widgets.add(
          Row(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: "Image Preview",
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return Center(
                          child: Material(
                            color: Colors.transparent, // 背景を透明に設定
                            child: GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).pop(), // タップで閉じる
                              child: SizedBox(
                                  width: 300,
                                  height: 300,
                                  child: Image.memory(filesData[i])),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Image.memory(
                    filesData[i], //getしたicon画像
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ]),
        );
      } else if (filesData.length - i > 1) {
        widgets.add(
          Row(children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: "Image Preview",
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return Center(
                          child: Material(
                            color: Colors.transparent, // 背景を透明に設定
                            child: GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).pop(), // タップで閉じる
                              child: SizedBox(
                                  width: 300,
                                  height: 300,
                                  child: Image.memory(filesData[i-1])),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Image.memory(
                    filesData[i], //getしたicon画像
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: "Image Preview",
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return Center(
                          child: Material(
                            color: Colors.transparent, // 背景を透明に設定
                            child: GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).pop(), // タップで閉じる
                              child: SizedBox(
                                  width: 300,
                                  height: 300,
                                  child: Image.memory(filesData[i])),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Image.memory(
                    filesData[i + 1], //getしたicon画像
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ]),
        );
        i++;
      }
    }
    return Column(
      children: widgets,
    );
  }
}
