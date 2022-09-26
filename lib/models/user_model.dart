class UserModel {
  String uid;
  String name;
  String email;
  String profile;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profile,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "email": email,
        "profile": profile,
      };
  static UserModel fromJson(var snap) {
    var json = snap.data() as Map<String, dynamic>;
    return UserModel(uid: json['uid'], name: json['name'], email: json['email'], profile: json['profile']);
  }
}
