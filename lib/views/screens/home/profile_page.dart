import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/controllers/auth_controller.dart';
import 'package:tiktok_clone/controllers/profile_controller.dart';
import 'package:tiktok_clone/helper/user_preference.dart';
import 'package:tiktok_clone/helper/utils.dart';
import 'package:tiktok_clone/views/screens/auth/login_page.dart';
import 'package:tiktok_clone/views/screens/followers_page.dart';
import 'package:tiktok_clone/views/screens/followings_page.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key,}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileController profileController = Get.put(ProfileController());
   var uid = FirebaseAuth.instance.currentUser!.uid;
  int likes = 0;
  @override
  void initState() {
    // TODO: implement initState

    profileController.getUserVideos(uid);
    profileController.getFollowerCounts(uid);
    profileController.getFollowingCounts(uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${UserPreference.preferences!.get("user_name")}"), actions: [
        IconButton(onPressed: (){}, icon: const Icon(Icons.more_horiz))
      ],),
      body: GetBuilder<ProfileController>(builder: (controller){
        likes = 0;
        for (var video in controller.videoList) {
          likes = likes + video.videoLiker.length;
        }
        return  SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              CircleAvatar(backgroundImage: NetworkImage("${UserPreference.preferences!.get("user_profile")}"), radius: 40,),
              const SizedBox(
                height: 20,
              ),
              "Logout".text.xl.bold.red500.make().p16().onTap(() async{
                AuthController().logoutUser().then((value) {
                  if (value == true) {
                    Get.offAll(LoginPage());
                  } else {
                    Utils.showCustomSnack(value);
                  }
                });
              }),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      "${controller.followerCount}".text.xl.bold.make(),
                      "Followers".text.make(),
                    ],
                  ).onTap(() {
                    Get.to(FollowersPage(userId: uid));
                  }),
                  const SizedBox(width: 20,),
                  Column(
                    children: [
                      "${controller.followingCount}".text.xl.bold.make(),
                      "Followings".text.make(),
                    ],
                  ).onTap(() {
                    Get.to(FollowingsPage(userId: uid));
                  }),
                  const SizedBox(width: 20,),
                  Column(
                    children: [
                      "$likes".text.xl.bold.make(),
                      "Likes".text.make(),
                    ],
                  ),

                ],),
              const SizedBox(
                height: 20,
              ),
              const Divider(color: Colors.grey,),
              Expanded(
                child:  controller.isLoaded ? controller.videoList.isNotEmpty ? GridView.builder(
                    itemCount: controller.videoList.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,), itemBuilder: (context, index){
                  return Container(decoration: BoxDecoration(
                    color: Vx.randomColor,
                  ),
                    child: Image(image: NetworkImage(controller.videoList[index].videoThumb),),
                  );
                }): Center(child: "data not found".text.xl.make(),)  : const Center(child: CircularProgressIndicator(),),
              ),
            ],
          ),
        );
      }),);
  }
}

