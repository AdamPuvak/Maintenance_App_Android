import 'package:flutter/material.dart';
import '/utilities/globalVar.dart';
import '/pages/home_page.dart';
import '/pages/notifications_page.dart';
import '/pages/settings_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(70.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: customDarkGrey,
      elevation: 0.0,

      leading: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage()),
          );
        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.fromLTRB(10.0, 5.0, 0, 0),
          child: const Icon(
            Icons.settings_rounded,
            color: customYellow,
            size: 40.0,
          ),
        ),
      ),

      title:
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
        child: Image.asset(
          'images/Logo_s_ramom.png',
          height: 55,
        ),
      ),
      centerTitle: true,

      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsPage()),
            );
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.fromLTRB(10.0, 5.0, 0, 0),
            child: const Icon(
              Icons.announcement,
              color: customYellow,
              size: 35.0,
            ),
          ),
        ),
      ],

    );
  }
}