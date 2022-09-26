import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/auth_controller.dart';
import 'package:tiktok_clone/helper/user_preference.dart';
import 'package:tiktok_clone/helper/utils.dart';
import 'package:tiktok_clone/views/screens/auth/login_page.dart';
import 'package:tiktok_clone/views/screens/home/video_page.dart';
import 'package:tiktok_clone/views/screens/home/home_page.dart';
import 'package:tiktok_clone/views/screens/home/message_page.dart';
import 'package:tiktok_clone/views/screens/home/profile_page.dart';
import 'package:tiktok_clone/views/screens/home/search_page.dart';
import 'package:tiktok_clone/views/screens/home/widgets/custom_icon.dart';
import 'package:velocity_x/velocity_x.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _selectedIndex = 0;
  onTapItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  var pages = [
    HomePage(),
    SearchPage(),
    VideoPage(),
    MessagePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: onTapItem,
          // showSelectedLabels: false,
          // showUnselectedLabels: false,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(icon: CustomIcon(), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: "Message"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
          ]),
    );
  }
}
