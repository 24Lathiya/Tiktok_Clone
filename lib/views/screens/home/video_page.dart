import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/views/screens/video_upload.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:get/get.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      alignment: Alignment.center,
      child: "Add Video".text.bold.xl.make().pLTRB(30, 15, 30, 15).box.red500.rounded.make().onTap(() {
        _showOptionDialog(context);
      }),
    ),);
  }

  Future _showOptionDialog(BuildContext context) {
    return showDialog(context: context, builder: (context) => SimpleDialog(
      children: [
      SimpleDialogOption(child: Row(
        children: const [
          Icon(Icons.image),
          SizedBox(width: 10,),
          Text("Gallery"),
        ],
      ), onPressed: (){
        Get.back();
        _getVideoFromGallery();
      },),
      SimpleDialogOption(child: Row(
        children: const [
          Icon(Icons.camera),
          SizedBox(width: 10,),
          Text("Camera"),
        ],
      ), onPressed: (){
        Get.back();
        _getVideoFromCamera();
      },),
      SimpleDialogOption(child: Row(
        children: const [
          Icon(Icons.cancel),
          SizedBox(width: 10,),
          Text("Cancel"),
        ],
      ), onPressed: (){
        Get.back();
      },),
    ],));
  }

  void _getVideoFromGallery() async{
    var video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if(video != null){
      Get.to(VideoUpload(videoPath: video.path,));
    }
  }
  void _getVideoFromCamera() async{
    var video = await ImagePicker().pickVideo(source: ImageSource.camera);
    if(video != null){
      Get.to(VideoUpload(videoPath: video.path,));
    }
  }
}
