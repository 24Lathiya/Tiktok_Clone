import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/models/video_model.dart';
import 'package:video_compress/video_compress.dart';

class VideoUploadController extends GetxController{
  Future uploadVideoToStorage(String song, String caption, String videoPath) async{
    // await Future.delayed(const Duration(seconds: 5));
    // return true;
    try{
      var currentTime = DateTime.now().millisecondsSinceEpoch;
      var videoId = 'video_$currentTime';
      var videoUrl = await _getVideoUrl(videoPath, videoId);
      var thumbUrl = await _getThumbUrl(videoPath, videoId);
      var docSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      VideoModel videoModel = VideoModel(userId: FirebaseAuth.instance.currentUser!.uid, userName: docSnapshot.get('name'), userProfile: docSnapshot.get('profile'), userEmail: docSnapshot.get('email'), videoId: videoId, videoUrl: videoUrl, videoThumb: thumbUrl, videoSong: song, videoCaption: caption, videoLiker: [], commentCount: 0, shareCount: 0);
      await FirebaseFirestore.instance.collection('videos').doc(videoId).set(videoModel.toJson());
      return true;
    }on FirebaseException catch(e){
      return e.message;
    }

  }
}

Future _getVideoUrl(String videoPath, String id) async{
  Reference reference =  FirebaseStorage.instance.ref().child('videos').child(id);
//  var compressVideo = await VideoCompress.compressVideo(videoPath, quality: VideoQuality.MediumQuality);
  var snapshot = await reference.putFile(File(videoPath));
  var videoUrl = await snapshot.ref.getDownloadURL();
  return videoUrl;
}

Future _getThumbUrl(String videoPath, String id) async{
  Reference reference = FirebaseStorage.instance.ref().child('thumbnail').child(id);
  var thumb = await VideoCompress.getFileThumbnail(videoPath);
  var snapshot = await reference.putFile(thumb);
  var thumbUrl = await snapshot.ref.getDownloadURL();
  return thumbUrl;
}