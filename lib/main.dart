import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiktok_clone/controllers/auth_controller.dart';
import 'package:tiktok_clone/controllers/video_controller.dart';
import 'package:tiktok_clone/helper/user_preference.dart';
import 'package:tiktok_clone/views/screens/auth/login_page.dart';
import 'package:tiktok_clone/views/screens/auth/sign_up_page.dart';
import 'package:tiktok_clone/views/screens/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserPreference.preferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  Get.put(VideoController());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    _loadVideoData();
    super.initState();
  }

  Future _loadVideoData() async{
    await Get.find<VideoController>().getVideoList();
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tiktok Clone',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: UserPreference.preferences!.getBool("user_login") == null
          ? SignUpPage()
          : UserPreference.preferences!.getBool("user_login")!
              ? MainPage()
              : LoginPage(),
      builder: EasyLoading.init(),
    );
  }
}
