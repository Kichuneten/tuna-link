import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tunalink/src/presentation/pages/logined/home_page.dart';
import 'package:tunalink/src/presentation/pages/login_page.dart';
import 'package:tunalink/src/presentation/pages/logined/notification_page.dart';
import 'package:tunalink/src/presentation/pages/register_page.dart';
import 'package:tunalink/src/presentation/pages/logined/search_page.dart';
import 'package:tunalink/src/presentation/pages/logined/user_page.dart';

final GoRouter goRouter = GoRouter(
  redirect: (context, state) {
    //ログインしているか
    //? userがnullか、あるいはemail認証されていないならfalseになるようにする
    final isLoggedIn = FirebaseAuth.instance.currentUser == null
        ? false
        : FirebaseAuth.instance.currentUser!.emailVerified;

    final goingToLogin = (state.fullPath == '/login' ||
        state.fullPath == '/register' ||
        state.fullPath == '/verify');

    if (!isLoggedIn && !goingToLogin) {
      return '/login'; // 未ログイン時はログイン画面にリダイレクト
    }

    return null; // 他のルートは変更なし
  },
  initialLocation: '/',
  routes: [
    //?ログインしてないページ
    //ログイン画面
    GoRoute(
        path: '/login',
        builder: (context, state) {
          return const LoginPage();
        }),

    //新規登録画面（ユーザーネームとメアドとパスワード）
    GoRoute(
      path: '/register',
      builder: (context, state) {
        debugPrint("let's register");
        return const RegisterPage();
      },
    ),
    // //登録の認証画面（メアド（初期値で入力済み）とパスワード）
    // GoRoute(
    //   path: '/verify',
    //   builder: (context, state) {
    //     return const VerifyPage();
    //   },
    // ),

    //home
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return const NoTransitionPage(
          child: HomePage(),
        );
      },
    ),
    //search
    GoRoute(
      path: '/search',
      pageBuilder: (context, state) {
        debugPrint('register page');
        return const NoTransitionPage(
          child: SearchPage(),
        );
      },
    ),
    //notification
    GoRoute(
      path: '/notification',
      pageBuilder: (context, state) {
        return const NoTransitionPage(
          child: NotificaitonPage(),
        );
      },
    ),
    //mypage
    GoRoute(
      path: '/mypage',
      pageBuilder: (context, state) {
        return const NoTransitionPage(
          child: UserPage(),
        );
      },
    ),
  ],
);
