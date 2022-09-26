import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/auth_controller.dart';
import 'package:tiktok_clone/models/video_model.dart';
class VideoController extends GetxController{
  List<VideoModel> _videoList = [];
  List<VideoModel> get videoList => _videoList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future getVideoList() async{
    try {
       // FirebaseFirestore.instance.collection('videos').snapshots().map((QuerySnapshot snapshot) {
       //  _videoList = [];
       //  for (var element in snapshot.docs) {
       //    videoList.add(VideoModel.fromJson(element));
       //  }
      //   _isLoaded = true;
      //   update();
      // });
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('videos').get();
      _videoList = [];
      for (var snap in snapshot.docs) {
        _videoList.add(VideoModel.fromJson(snap));
      }
      _isLoaded = true;
      update();
    }on FirebaseException catch (e){
      print("===error=== ${e.message}");
    }
  }
 
  Future likeUnlikeVideo(VideoModel videoModel) async{
    var doc = FirebaseFirestore.instance.collection('videos').doc(videoModel.videoId);
    var snapshot = await doc.get();
    var uid = FirebaseAuth.instance.currentUser!.uid;
    if((snapshot.get('videoLiker') as List).contains(uid)){
          await doc.update({'videoLiker': FieldValue.arrayRemove([uid])});
          videoModel.videoLiker.remove(uid);
    }else{
      await doc.update({'videoLiker' : FieldValue.arrayUnion([uid])});
      videoModel.videoLiker.add(uid);
    }
    update();
  }


}