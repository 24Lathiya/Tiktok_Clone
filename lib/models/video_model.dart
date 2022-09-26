class VideoModel{
  String userId;
  String userName;
  String userProfile;
  String userEmail;
  String videoId;
  String videoUrl;
  String videoThumb;
  String videoSong;
  String videoCaption;
  List videoLiker;
  int commentCount;
  int shareCount;

  VideoModel ({required this.userId, required this.userName, required this.userProfile, required this.userEmail, required this.videoId, required this.videoUrl, required this.videoThumb, required this.videoSong, required this.videoCaption, required this.videoLiker, required this.commentCount, required this.shareCount});
  
  Map<String, dynamic> toJson() =>{
    'userId' : userId,
    'userName' : userName,
    'userProfile' : userProfile,
    'userEmail' : userEmail,
    'videoId' : videoId,
    'videoUrl' : videoUrl,
    'videoThumb' : videoThumb,
    'videoSong' : videoSong,
    'videoCaption' : videoCaption,
    'videoLiker' : videoLiker,
    'commentCount' : commentCount,
    'shareCount' : shareCount,
  };
  
  static VideoModel fromJson(var snap){
    var json = snap.data() as Map<String, dynamic>;
    return VideoModel(userId: json['userId'], userName: json['userName'], userProfile: json['userProfile'], userEmail: json['userEmail'], videoId: json['videoId'], videoUrl: json['videoUrl'], videoThumb: json['videoThumb'], videoSong: json['videoSong'], videoCaption: json['videoCaption'], videoLiker: json['videoLiker'], commentCount: json['commentCount'], shareCount: json['shareCount']);
  }
}