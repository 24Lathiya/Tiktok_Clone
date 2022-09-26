import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/models/comment_model.dart';
import 'package:tiktok_clone/models/video_model.dart';
class CommentController extends GetxController{
  List<CommentModel> _commentList = [];
  List<CommentModel> get commentList => _commentList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future getComments(String videoId) async{
      try{
        var snapshot = await FirebaseFirestore.instance.collection('videos').doc(videoId).collection('comments').get();
        _commentList = [];
        for (var element in snapshot.docs) {
          _commentList.add(CommentModel.fromJson(element));
        }
       _isLoaded = true;
        update();
      }on FirebaseException catch (e){
        return e.message;
      }
  }
  
  Future postComment(VideoModel videoModel, String comment) async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
      var currentDate = DateTime.now();
      CommentModel commentModel = CommentModel(id: "comment_${currentDate.millisecondsSinceEpoch}",
          uid: snapshot.get('uid'),
          username: snapshot.get('name'),
          comment: comment,
          datePublished: currentDate,
          likes: [],
          profilePhoto: snapshot.get('profile'));
      var reference = FirebaseFirestore.instance.collection('videos').doc(videoModel.videoId);
      await reference.collection('comments').doc("comment_${currentDate.millisecondsSinceEpoch}").set(commentModel.toJson());
      var snap = await reference.get();
      await reference.update({'commentCount' : snap.get('commentCount') + 1});
      _commentList.add(commentModel);
      videoModel.commentCount = _commentList.length;

      update();
      return true;
    }on FirebaseException catch (e){
      return e.message;
    }
  }

  Future likeUnlikeComments(CommentModel commentModel, String videoId) async{
    var doc = FirebaseFirestore.instance.collection('videos').doc(videoId).collection('comments').doc(commentModel.id);
    var snapshot = await doc.get();
    var uid = FirebaseAuth.instance.currentUser!.uid;
    if((snapshot.get('likes') as List).contains(uid)){
      await doc.update({'likes': FieldValue.arrayRemove([uid])});
      commentModel.likes.remove(uid);
    }else{
      await doc.update({'likes' : FieldValue.arrayUnion([uid])});
      commentModel.likes.add(uid);
    }
    update();
  }
}