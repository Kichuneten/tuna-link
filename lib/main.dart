import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tunalink/src/presentation/pages/login_page.dart';
import 'package:tunalink/src/presentation/pages/register_page.dart';
import 'package:tunalink/src/presentation/providers/main_provider.dart';
import 'package:tunalink/src/presentation/router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //初期化を保証する

  await Firebase.initializeApp(); // Firebaseの初期化

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MainProvider()),
      ChangeNotifierProvider(create: (_) => LoginProvider()),
      ChangeNotifierProvider(create: (_) => RegisterViewModel()),
    ],
    child: const MyApp(),
  ));
}

// GoRouterを動的に更新するためのグローバルStream
final authStream = FirebaseAuth.instance.authStateChanges();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      //routerの設定（go router使用）
      routeInformationProvider: goRouter.routeInformationProvider,
      routerDelegate: goRouter.routerDelegate,
      routeInformationParser: goRouter.routeInformationParser,
      //テーマの設定
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.transparent, // 色の変化を無効化
        ),
      ),
      themeMode: ThemeMode.system,
    );
  }
}
