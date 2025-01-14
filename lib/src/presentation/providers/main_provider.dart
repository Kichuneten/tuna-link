// import 'dart:typed_data';

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tunalink/src/domain/types/user.dart';
import 'package:tunalink/src/infrastructure/server/user.dart';

//全体で共有したい情報を持っておくProvider
class MainProvider with ChangeNotifier {
  String message = "";
  bool isInit = false;
  late MyUser me;

  Future<void> init() async {
    if (!isInit) {
      // message = await testsearchpost();
      // message= await testget();
      //await testpost("hello, this is dart 3.5");

      String? rawmyinfo=await getMyInfo();
      if(rawmyinfo==null)throw Error();

      debugPrint(jsonDecode(rawmyinfo)[0].toString());
      me=MyUser.fromJson(jsonDecode(rawmyinfo)[0]);
      debugPrint("my name is ${me.userName}");
      isInit = true;
    }
    notifyListeners();
  }

  bool isDisposed = false;
  @override
  void notifyListeners() {
    if (!isDisposed) super.notifyListeners();
  }

  @override
  void dispose() {
    isDisposed = true;
    isInit=false;
    super.dispose();
  }
}
