import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tunalink/src/application/storage/userInfoStorage.dart';

Future<int> loginFirebase(String email, String password) async {
  final FirebaseAuth auth = FirebaseAuth.instance;

  try {
    final userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user?.emailVerified ?? false) {
      await saveTokenToSecureStorage();
      return 0; //ログイン成功
    } else {
      await userCredential.user?.sendEmailVerification();
      return 1; //メールアドレスの未認証（認証メールを再送信）
    }
  } on FirebaseAuthException catch (error) {
    debugPrint("Error<LoginProvider>: FirebaseAuthException: $error");
    return 2; //ログイン失敗
  }
}

//基本的にこれでは使わずsaveTokenToSecureStorage()を推奨
Future<String?> getIdToken() async {
  User? user = FirebaseAuth.instance.currentUser;
  String? idToken;
  if (user != null) {
    await user.reload();
    idToken = await user.getIdToken();
  }
  return idToken;
}
