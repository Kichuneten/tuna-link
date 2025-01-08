import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:tunalink/src/presentation/router/go_router.dart';
// import 'package:tunalink/src/presentation/providers/main_provider.dart';

class MyBottomNaviBar extends StatelessWidget {
  final int currentIndex;

  const MyBottomNaviBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
      unselectedItemColor: const Color.fromARGB(255, 118, 118, 118),
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            // //今のroute
            // final currentLocation =
            //     goRouter.routerDelegate.currentConfiguration.uri.toString();
            // //もしhomeでこれが押されたなら
            // if (currentLocation == "/") {
            //   debugPrint("im home already");
            //   final feedProvider =
            //       Provider.of<FeedProvider>(context, listen: false);
            //   feedProvider.controller.animateTo(
            //     0, // 移動先の位置（0=トップ）
            //     duration: const Duration(milliseconds: 300), // アニメーションの時間
            //     curve: Curves.easeOut, // アニメーションのカーブ
            //   );
            //   break;
            // }
            context.go('/');
            break;
          case 1:
            // //今のroute
            // final currentLocation =
            //     goRouter.routerDelegate.currentConfiguration.uri.toString();
            // //もしhomeでこれが押されたなら
            // if (currentLocation == "/search") {
            //   final searchProvider =
            //       Provider.of<SearchProvider>(context, listen: false);
            //   //feedのトップまでスクロールする
            //   searchProvider.controller.animateTo(
            //     0, // 移動先の位置（0=トップ）
            //     duration: const Duration(milliseconds: 300), // アニメーションの時間
            //     curve: Curves.easeOut, // アニメーションのカーブ
            //   );
            //   break;
            // }
            context.go('/search');
            break;
          case 2:
            context.go('/notification');
            break;
          case 3:
            // //今のroute
            // final currentLocation =
            //     goRouter.routerDelegate.currentConfiguration.uri.toString();
            // //もしhomeでこれが押されたなら
            // if (currentLocation == "/mypage") {
            //   final userPageProvider =
            //       Provider.of<UserPageProvider>(context, listen: false);
            //   //feedのトップまでスクロールする
            //   userPageProvider.controller.animateTo(
            //     0, // 移動先の位置（0=トップ）
            //     duration: const Duration(milliseconds: 300), // アニメーションの時間
            //     curve: Curves.easeOut, // アニメーションのカーブ
            //   );
            //   break;
            // }
            context.go('/mypage');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(size: 25, Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(size: 25, Icons.search_rounded), label: 'Search'),
        BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(size: 25, Icons.notifications_none),
                // Transform.translate(
                //   offset: const Offset(18, -3),
                //   child: Consumer<NotificationProvider>(
                //     builder: (context, provider, child) {
                //       return provider
                //               .filteredList(["like", "reply"])
                //               .where((mynotification) => !mynotification.isRead)
                //               .isEmpty
                //           ? const SizedBox()
                //           : Container(
                //               height: 18,
                //               width: 18,
                //               decoration: const BoxDecoration(
                //                   color: Colors.red,
                //                   borderRadius:
                //                       BorderRadius.all(Radius.circular(10))),
                //               child: Center(
                //                 child: Text(
                //                   provider
                //                       .filteredList(["like", "reply"])
                //                       .where((mynotification) =>
                //                           !mynotification.isRead)
                //                       .length
                //                       .toString(),
                //                   style:
                //                       const TextStyle(fontSize: MyFontSize.m),
                //                 ),
                //               ),
                //             );
                //     },
                //   ),
                // ),
              ],
            ),
            label: 'Notifications'),
        BottomNavigationBarItem(
            icon: Icon(size: 25, Icons.person), label: 'MyPage'),
      ],
    );
  }
}