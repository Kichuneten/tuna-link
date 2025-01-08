import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  // ログアウト処理
  Future<void> _logout(BuildContext context) async {
    var messanger = ScaffoldMessenger.of(context);

    try {
      await FirebaseAuth.instance.signOut();
      // ログイン画面などに戻る処理を追加

      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
      });
      messanger.showSnackBar(
        const SnackBar(content: Text('ログアウトしました')),
      );
    } catch (e) {
      // エラーハンドリング
      debugPrint('ログアウトに失敗しました: $e');
      messanger.showSnackBar(
        const SnackBar(content: Text('ログアウトに失敗しました')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async => await _logout(context),
      child: const Text('ログアウト'),
    );
  }
}
