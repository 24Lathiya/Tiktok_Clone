import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/profile_controller.dart';
import 'package:tiktok_clone/models/user_model.dart';
import 'package:tiktok_clone/views/screens/user_page.dart';
import 'package:velocity_x/velocity_x.dart';

class FollowersPage extends StatefulWidget {
  final String userId;
  const FollowersPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  ProfileController profileController = Get.put(ProfileController());
  @override
  void initState() {
    // TODO: implement initState
    profileController.getFollowerList(widget.userId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Followers"),),
      body: GetBuilder<ProfileController>(builder: (controller){
        return controller.isLoaded ? controller.followerList.isNotEmpty ? ListView.builder(
            itemCount: controller.followerList.length,
            itemBuilder: (context, index){
              return ListTile(leading: CircleAvatar(
                backgroundImage: NetworkImage(controller.followerList[index].profile),radius: 25,),
                title: controller.followerList[index].name.text.xl.make(),
                onTap: (){
                  Get.to(UserPage(userModel: controller.followerList[index]));
                },
              );
            }): const Center(child: Text("No follower found"),) : Center(child: CircularProgressIndicator(),);
      }),);
  }
}
