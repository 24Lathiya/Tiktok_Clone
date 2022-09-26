class CommentModel{
  String id;
  String uid;
  String username;
  String comment;
  final datePublished;
  List likes;
  String profilePhoto;


  CommentModel({
   required this.id,
   required this.uid,
   required this.username,
   required this.comment,
   required this.datePublished,
   required this.likes,
   required this.profilePhoto,
});

  Map<String, dynamic> toJson() => {
    'id' : id,
    'uid' : uid,
    'username' : username,
    'comment' : comment,
    'datePublished' : datePublished,
    'likes' : likes,
    'profilePhoto' : profilePhoto,
  };

  static CommentModel fromJson(var snap){
    var json = snap.data() as Map<String, dynamic>;
    return CommentModel(id: json['id'], uid: json['uid'], username: json['username'], comment: json['comment'], datePublished: json['datePublished'], likes: json['likes'], profilePhoto: json['profilePhoto']);
  }
}