import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/helper/user_preference.dart';
import 'package:tiktok_clone/models/follower_model.dart';
import 'package:tiktok_clone/models/following_model.dart';
import 'package:tiktok_clone/models/user_model.dart';
import 'package:tiktok_clone/models/video_model.dart';

class ProfileController extends GetxController{
  List<VideoModel> _videoList = [];
  List<VideoModel> get videoList => _videoList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  bool _isFollowed = false;
  bool get isFollowed => _isFollowed;

  Future getUserVideos(String userId) async {
    var snapshot = await FirebaseFirestore.instance.collection('videos').where('userId', isEqualTo: userId).get();
    _videoList = [];
    for (var snap in snapshot.docs) {
      _videoList.add(VideoModel.fromJson(snap));
    }
    _isLoaded = true;
    update();
  }

  int _followerCount = 0;
  int get followerCount => _followerCount;
  Future getFollowerCounts(String userId) async {
    var snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).collection('followers').get();
    _followerCount = snapshot.docs.isEmpty ? 0 : snapshot.docs.length;
    update();
  }
  int _followingCount = 0;
  int get followingCount => _followingCount;
  Future getFollowingCounts(String userId) async {
    var snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).collection('followings').get();
    _followingCount = snapshot.docs.isEmpty ? 0 : snapshot.docs.length;
    update();
  }

  List<UserModel> _followerList = [];
  List<UserModel> get followerList => _followerList;
  Future getFollowerList(String userId) async {
    _followerList = [];
    var snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).collection('followers').get();
   if(snapshot.docs.isNotEmpty){
     snapshot.docs.forEach((snap) {
       if (snap.get('uid') == FirebaseAuth.instance.currentUser!.uid) {
         _isFollowed = true;
       }
         _followerList.add(UserModel.fromJson(snap));
     });
   }
  _isLoaded = true;
   update();
  }

  List<UserModel> _followingList = [];
  List<UserModel> get followingList => _followingList;

  Future getFollowingList(String userId) async {
    _followingList = [];
    var snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).collection('followings').get();
    if(snapshot.docs.isNotEmpty) {
      snapshot.docs.forEach((snap) {
        _followingList.add(UserModel.fromJson(snap));
      });
    }
    _isLoaded = true;
    update();
  }

  Future followUnfollowUser(UserModel userModel) async{
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var refFollowing = FirebaseFirestore.instance.collection('users').doc(uid).collection('followings').doc(userModel.uid);
    var snapFollowing = await refFollowing.get();

    UserModel followingModel = UserModel(uid: userModel.uid, name: userModel.name, email: userModel.email, profile: userModel.profile);

    if (!snapFollowing.exists) {
      await refFollowing
          .set(followingModel.toJson());
    }else{
      await refFollowing.delete();
    }

    var refFollower = FirebaseFirestore.instance.collection('users').doc(userModel.uid).collection('followers').doc(uid);
    var snapFollower = await refFollower.get();
    UserModel followerModel = UserModel(uid: uid, name: UserPreference.preferences!.get("user_name").toString(), email: UserPreference.preferences!.get("user_email").toString(), profile: UserPreference.preferences!.get("user_profile").toString());
    if(!snapFollower.exists){
      await refFollower.set(followerModel.toJson());
      _followerList.add(followerModel);
      _isFollowed = true;
    }else{
      await refFollower.delete();
      _followerList.remove(followerModel);
      _isFollowed = false;
    }
    update();
  }
}