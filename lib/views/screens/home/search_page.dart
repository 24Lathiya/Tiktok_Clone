import 'package:flutter/material.dart';
import 'package:tiktok_clone/controllers/search_controller.dart';
import 'package:tiktok_clone/views/screens/user_page.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchController searchController = Get.put(SearchController());
  var searchEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search"),),
      body: SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: TextField(
              showCursor: true,
              controller: searchEditingController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter User Name",
                  suffixIcon: InkWell(
                    onTap: () {
                      searchController.searchUser(searchEditingController.text.trim());
                    },
                    child: const Icon(
                      Icons.search,
                    ),
                  ),),
            ),
          ),
          GetBuilder<SearchController>(builder: (controller){
           return  Expanded(
             child: controller.searchList.isNotEmpty ? ListView.builder(
                 itemCount: controller.searchList.length,
                 itemBuilder: (context, index){
                   return ListTile(leading: CircleAvatar(
                     backgroundImage: NetworkImage(controller.searchList[index].profile),radius: 25,),
                     title: controller.searchList[index].name.text.xl.make(),
                     onTap: (){
                      Get.to(UserPage(userModel: controller.searchList[index]));
                     },
                   );
                 }): Center(child: Text( searchEditingController.text.isEmpty ?"Search user name" : "No user found"),),
           );
          }),

        ],
      ),
    ),);
  }
}
