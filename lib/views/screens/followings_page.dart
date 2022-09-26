import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/profile_controller.dart';
import 'package:tiktok_clone/views/screens/user_page.dart';
import 'package:velocity_x/velocity_x.dart';

class FollowingsPage extends StatefulWidget {
  final String userId;
  const FollowingsPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<FollowingsPage> createState() => _FollowingsPageState();
}

class _FollowingsPageState extends State<FollowingsPage> {
  ProfileController profileController = Get.put(ProfileController());
  @override
  void initState() {
    // TODO: implement initState
    profileController.getFollowingList(widget.userId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Followings"),),
      body: GetBuilder<ProfileController>(builder: (controller){
        return controller.isLoaded ? controller.followingList.isNotEmpty ? ListView.builder(
            itemCount: controller.followingList.length,
            itemBuilder: (context, index){
              return ListTile(leading: CircleAvatar(
                backgroundImage: NetworkImage(controller.followingList[index].profile),radius: 25,),
                title: controller.followingList[index].name.text.xl.make(),
                onTap: (){
                  Get.to(UserPage(userModel: controller.followingList[index]));
                },
              );
            }): const Center(child: Text("No following found"),) : const Center(child: CircularProgressIndicator(),);
      }),);
  }
}
