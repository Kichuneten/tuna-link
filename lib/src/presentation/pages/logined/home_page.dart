import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tunalink/src/presentation/providers/main_provider.dart';
import 'package:tunalink/src/presentation/widgets/post_widget.dart';
import 'package:tunalink/src/presentation/widgets/scaffold_components.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mainProvider = context.read<MainProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      mainProvider.init();
    });

    return Scaffold(
      drawer: const MyDrawer(),
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: false,
                floating: true,
                title: const Text("ホーム"),
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      // ここで正しい context を取得
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              )
            ];
          },
          body: const Column(
            children: [
              PostWidget(),

              //?以下cloud run ->cloud storageのファイル取得のテスト。うまくいきました。　
              // FutureBuilder(
              //   future: testimage(),
              //   builder: (context, snapshot) {
              //     if (!snapshot.hasData) {
              //       return const CircularProgressIndicator();
              //     }
              //     return SizedBox(
              //       width: 100,
              //       height: 100,
              //       child: Image.memory(snapshot.data!),
              //     );
              //   },
              // )
            ],
          )),
      bottomNavigationBar: const MyBottomNaviBar(currentIndex: 0),
    );
  }
}
