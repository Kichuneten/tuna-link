import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tunalink/src/application/storage/userInfoStorage.dart';
import 'package:tunalink/src/presentation/theme/sizes.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
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
                      '新規登録',
                      style: TextStyle(fontSize: MyFontSize.ll),
                    ),
                    Spacer(),
                  ],
                ),
                const SizedBox(height: 30),
                const InputLabel(text: 'ユーザーネーム\n（TunaLink内の表示名になります）'),
                InputField(
                    controller:
                        context.read<RegisterViewModel>().usernameController),
                const InputLabel(text: 'メールアドレス'),
                InputField(
                    controller:
                        context.read<RegisterViewModel>().emailController),
                const InputLabel(text: 'パスワード'),
                InputField(
                    controller:
                        context.read<RegisterViewModel>().passwordController,
                    isPassword: true),
                Row(
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<RegisterViewModel>().register(context),
                      child: const Text('新規登録'),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 50),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('登録済みの方はこちら'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InputLabel extends StatelessWidget {
  final String text;

  const InputLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text),
        const Spacer(),
      ],
    );
  }
}

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isPassword;

  const InputField(
      {super.key, required this.controller, this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        obscureText: isPassword,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        style: const TextStyle(fontSize: MyFontSize.m),
      ),
    );
  }
}

class RegisterViewModel extends ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> register(BuildContext context) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await saveEmailToSecureStorage(userCredential.user?.email);
      await saveUIDToSecureStorage();

      final uid = await getUIDFromSecureStorage();
      if (uid != null) {
        // await saveUserToDB(usernameController.text, uid);
      } else {
        throw Exception("uid has null value");
      }

      await userCredential.user?.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('認証メールを送りました: ${userCredential.user?.email}'),
        ),
      );

      context.go('/login');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Error')),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
