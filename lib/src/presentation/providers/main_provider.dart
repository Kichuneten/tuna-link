// import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tunalink/src/infrastructure/server/test.dart';

//全体で共有したい情報を持っておくProvider
class MainProvider with ChangeNotifier {
  String message = "";
  bool isInit = false;

  Future<void> init() async {
    if (!isInit) {
      message = await testget();
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
