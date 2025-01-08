import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tunalink/src/presentation/providers/main_provider.dart';
import 'package:tunalink/src/presentation/widgets/bottom_navi_bar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mainProvider = context.read<MainProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      mainProvider.init();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('検索'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(width: 10.0),
            const Text("検索画面"),
            const SizedBox(width: 100.0),
            Text(context.watch<MainProvider>().message)
          ],
        ),
      ),
      bottomNavigationBar: const MyBottomNaviBar(currentIndex: 1),
    );
  }
}
