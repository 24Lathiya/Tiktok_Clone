import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/controllers/profile_controller.dart';
import 'package:tiktok_clone/models/user_model.dart';
import 'package:tiktok_clone/views/screens/followers_page.dart';
import 'package:tiktok_clone/views/screens/followings_page.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:get/get.dart';

class UserPage extends StatefulWidget {
  final UserModel userModel;
   const UserPage({Key? key, required this.userModel}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  ProfileController profileController = Get.put(ProfileController());
 int likes = 0;
  @override
  void initState() {
    // TODO: implement initState
    profileController.getUserVideos(widget.userModel.uid);
    profileController.getFollowerCounts(widget.userModel.uid);
    profileController.getFollowingCounts(widget.userModel.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.userModel.name), actions: [
        IconButton(onPressed: (){}, icon: const Icon(Icons.more_horiz))
      ],),
      body: GetBuilder<ProfileController>(builder: (controller){
        likes = 0;
        for (var video in controller.videoList) {
          likes = likes + video.videoLiker.length;
        }
        // print("===likes=== $likes");
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              CircleAvatar(backgroundImage: NetworkImage(widget.userModel.profile), radius: 40,),
              (widget.userModel.uid == FirebaseAuth.instance.currentUser!.uid ? "" : controller.isFollowed? "Following" : "Follow").text.xl.bold.make().p16().onTap(() {
                profileController.followUnfollowUser(widget.userModel);
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
                    Get.to(FollowersPage(userId: widget.userModel.uid));
                  }),
                  const SizedBox(width: 20,),
                  Column(
                    children: [
                      "${controller.followingCount}".text.xl.bold.make(),
                      "Followings".text.make(),
                    ],
                  ).onTap(() {
                    Get.to(FollowingsPage(userId: widget.userModel.uid));
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
      }));
  }
}
