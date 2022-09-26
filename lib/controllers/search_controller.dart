import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/models/user_model.dart';

class SearchController extends GetxController{
  List<UserModel> _searchList = [];
  List<UserModel> get searchList => _searchList;


   Future searchUser(String query) async {
     var snapshot = await FirebaseFirestore.instance.collection('users').where('name', isEqualTo: query).get();
     _searchList = [];
     for (var snap in snapshot.docs) {
       _searchList.add(UserModel.fromJson(snap));
     }
     update();
   }
}