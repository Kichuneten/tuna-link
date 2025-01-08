import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tunalink/src/presentation/widgets/logout_button.dart';



class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(child: Text("TUNALINK")),
          // DrawerHeader(
          //   // decoration: BoxDecoration(color: Colors.blue),
          //   child: Consumer<MainProvider>(
          //     builder: (context, mainProvider, child) {
          //       return GestureDetector(
          //         child: Column(
          //           children: [
          //             Row(
          //               children: [
          //                 const Spacer(),
          //                 SizedBox(
          //                   width: 80,
          //                   height: 80,
          //                   child: ClipOval(
          //                     child: mainProvider.iconImageWidget,
          //                   ),
          //                 ),
          //                 const Spacer()
          //               ],
          //             ),
          //             Text(mainProvider.myUser != null
          //                 ? mainProvider.myUser!.userName
          //                 : "******"),
          //             Text(mainProvider.myUser != null
          //                 ? mainProvider.myUser!.userID
          //                 : "***"),
          //           ],
          //         ),
          //         onTap: () {
          //           context.go("/mypage");
          //           Navigator.pop(context);
          //         },
          //       );
          //     },
          //   ),
          // ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              context.go("/");
              Navigator.pop(context); // Drawerを閉じる
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              context.push("/settings");
              Navigator.pop(context); // Drawerを閉じる
            },
          ),
          const LogoutButton(),
        ],
      ),
    );
  }
}
