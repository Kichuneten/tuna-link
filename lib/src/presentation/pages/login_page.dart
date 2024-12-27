import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tunalink/src/application/storage/userInfoStorage.dart';
import 'package:tunalink/src/presentation/theme/sizes.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (userCredential.user?.emailVerified ?? false) {
        await saveUIDToSecureStorage();

        messenger.showSnackBar(
          SnackBar(
            content: Text(
              'ログインしました: ${FirebaseAuth.instance.currentUser!.email}',
            ),
          ),
        );
        context.go('/');
      } else {
        await userCredential.user?.sendEmailVerification();
        messenger.showSnackBar(
          const SnackBar(
            content: Text('メールアドレスが認証されていません\n 認証メールを再送信しました。'),
          ),
        );
      }
    } on FirebaseAuthException catch (error) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text("ログインに失敗しました\n入力内容を確かめて再度試してください"),
        ),
      );
      debugPrint("Error<LoginProvider>: FirebaseAuthException: $error");
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sw(context, 15),
            ),
            child: Column(
              children: [
                const SizedBox(height: 100),
                const Row(
                  children: [
                    Text(
                      'ログイン',
                      style: TextStyle(fontSize: MyFontSize.ll),
                    ),
                    Spacer(),
                  ],
                ),
                const SizedBox(height: 30),
                const Row(
                  children: [
                    Text('メールアドレス'),
                    Spacer(),
                  ],
                ),
                Consumer<LoginProvider>(
                  builder: (context, provider, _) => SizedBox(
                    height: 100,
                    child: TextFormField(
                      controller: provider.emailController,
                      decoration: const InputDecoration(
                        hintText: '',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontSize: MyFontSize.m),
                    ),
                  ),
                ),
                const Row(
                  children: [
                    Text('パスワード'),
                    Spacer(),
                  ],
                ),
                Consumer<LoginProvider>(
                  builder: (context, provider, _) => SizedBox(
                    height: 100,
                    child: TextFormField(
                      controller: provider.passwordController,
                      decoration: const InputDecoration(
                        hintText: '',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      style: const TextStyle(fontSize: MyFontSize.m),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Spacer(),
                    Consumer<LoginProvider>(
                      builder: (context, provider, _) => ElevatedButton(
                        onPressed: () => provider.login(context),
                        child: const Text('ログイン'),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 50),
                TextButton(
                  onPressed: () => context.go('/register'),
                  child: const Text('新規登録はこちら'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
