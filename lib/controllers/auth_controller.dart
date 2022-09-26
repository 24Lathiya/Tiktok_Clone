import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/helper/user_preference.dart';
import 'package:tiktok_clone/models/user_model.dart';

class AuthController extends GetxController {
  Future registerUser(String userName, String email, String password, File? image) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password); // register with email and password
      var profile = await _getProfileUrl(image!);
      UserModel userModel = UserModel(uid: userCredential.user!.uid, name: userName, email: email, profile: profile);
      await FirebaseFirestore.instance.collection("users").doc(userCredential.user!.uid).set(userModel.toJson()); // put user data in to cloud storage
      return true;
    } on FirebaseException catch (e) {
      return e.message;
      print("====registation error==== $e");
    }
  }

  Future _getProfileUrl(File image) async {
    Reference reference = FirebaseStorage.instance.ref().child("profile").child(FirebaseAuth.instance.currentUser!.uid); // /storage/profile/
    var snapShort = await reference.putFile(image); // get reference of folder and put image in it
    var downloadUrl = await snapShort.ref.getDownloadURL(); // get image url from above snap
    return downloadUrl;
  }

  Future loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      var snapshot = await FirebaseFirestore.instance.collection("users").doc(userCredential.user!.uid).get();
      print("===snap=== ${snapshot.get('profile')}");
      UserPreference.preferences!.setBool("user_login", true);
      UserPreference.preferences!.setString("user_email", email);
      UserPreference.preferences!.setString("user_name", snapshot.get('name'));
      UserPreference.preferences!.setString("user_profile", snapshot.get('profile'));

      return true;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future logoutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      UserPreference.preferences!.setBool("user_login", false);
      UserPreference.preferences!.setString("user_email", '');
      UserPreference.preferences!.setString("user_name", '');
      UserPreference.preferences!.setString("user_profile", '');
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
