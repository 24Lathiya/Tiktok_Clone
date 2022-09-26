
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiktok_clone/controllers/video_controller.dart';
import 'package:tiktok_clone/models/user_model.dart';
import 'package:tiktok_clone/views/screens/comment_page.dart';
import 'package:tiktok_clone/views/screens/home/widgets/icon_text_widget.dart';
import 'package:tiktok_clone/views/screens/home/widgets/reels_video_player.dart';
import 'package:tiktok_clone/views/screens/user_page.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver{
  // VideoController videoController = Get.put(VideoController());
  bool isHome = true;
  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); // remove status bar
    // _loadVideos();
    super.initState();
  }
  // Future _loadVideos() async{
  //   await videoController.getVideoList();
  // }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder<VideoController>(builder: (videoController){

          return videoController.isLoaded ? PageView.builder(
              itemCount: videoController.videoList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var videoModel = videoController.videoList[index];
                return Stack(children: [
                  /*Container(
                    child: Center(
                      child: Text("Video $index"),
                    ),
                    color: Vx.randomColor,
                  ),*/
                  ReelsVideoPlayer(thumbUrl: videoModel.videoThumb, videoUrl: videoModel.videoUrl, isHome: isHome),
                  Positioned(
                    right: 0,
                    bottom: 80,
                    child: Column(
                      children: [
                        Stack(children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(videoModel.userProfile),
                             // child: Image(image: NetworkImage("${videoModel.userProfile}")) ,
                              radius: 25,
                            ),
                          ),
                          const Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Icon(
                              Icons.add_circle,
                              color: Colors.red,
                            ),
                          )
                        ]
                        ).onTap(() async{
                          isHome = false;
                          setState(() {});
                          UserModel userModel  = UserModel(uid: videoModel.userId, name: videoModel.userName, email: videoModel.userEmail, profile: videoModel.userProfile);
                          Get.to(UserPage(userModel: userModel))!.then((value) {
                            isHome = true;
                          setState(() {});
                          });
                        }),
                        Column(children: [const SizedBox(height: 20,), Icon(Icons.favorite, size: 30, color: videoModel.videoLiker.contains(FirebaseAuth.instance.currentUser!.uid) ? Colors.red : Colors.white, shadows: const [BoxShadow(color: Colors.black, blurRadius: 2)],).onTap(() {
                          videoController.likeUnlikeVideo(videoModel);
                        }), const SizedBox(height: 10,), "${videoModel.videoLiker.length}".text.xl.shadow(1, 1, 1, Colors.black).make()],),
                        // IconTextWidget(icon: Icons.favorite, count: "${videoModel.videoLiker.length}"),
                        IconTextWidget(icon: Icons.message, count: "${videoModel.commentCount}").onTap(() async{
                          isHome = false;
                          setState(() {});
                          Get.to(CommentPage(videoModel: videoModel,))?.then((value) {
                            isHome = true;
                            setState(() {});
                          });
                        }),
                        IconTextWidget(icon: Icons.share, count: "${videoModel.shareCount}"),
                      ],
                    ),
                  ),
                  Positioned(
                      left: 10,
                      right: 10,
                      bottom: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              videoModel.userName.text.bold.xl.shadow(1, 1, 1, Colors.black).make(),
                              videoModel.videoCaption.text.shadow(1, 1, 1, Colors.black).make(),
                              videoModel.videoSong.text.shadow(1, 1, 1, Colors.black).make(),
                            ],),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 0.5)],
                            ),

                            child: const Icon(Icons.music_note_rounded),
                          ),
                          /*CircleAvatar(
                            child: Icon(Icons.music_note_rounded,),
                            radius: 25,
                          )*/
                        ],
                      ))
                ]);
              }) : const Center(child: CircularProgressIndicator());
        }));
  }
}
