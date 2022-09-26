import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/comment_controller.dart';
import 'package:tiktok_clone/helper/utils.dart';
import 'package:tiktok_clone/models/comment_model.dart';
import 'package:tiktok_clone/models/video_model.dart';
import 'package:tiktok_clone/views/widgets/text_input_field.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentPage extends StatefulWidget {
  final VideoModel videoModel;
  const CommentPage({Key? key, required this.videoModel}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  var commentEditingController = TextEditingController();
  CommentController commentController = Get.put(CommentController());
  @override
  void initState() {
    // TODO: implement initState
    _loadComments();
    super.initState();
  }

  Future _loadComments() async{
  //  Get.lazyPut(() => CommentController());
    await commentController.getComments(widget.videoModel.videoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Comments"),),
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Column(
       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GetBuilder<CommentController>(builder: (controller){

                return controller.isLoaded ? ListView.builder(
                    itemCount: controller.commentList.length,
                    itemBuilder: (context, index){
                      int reverseIndex = controller.commentList.length - 1 - index;
                      CommentModel commentModel = controller.commentList[reverseIndex];
                    //  print("=====: ${commentModel.datePublished}");
                      return ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(commentModel.profilePhoto), radius: 20,),
                        title: Row(
                          children: [
                            commentModel.username.text.bold.xl.red500.make(),
                            SizedBox(width: 10,),
                            commentModel.comment.text.xl.make(),
                          ],
                        ),
                        subtitle: Row(
                          children: [

                            timeago.format( commentModel.datePublished.toString().contains("Timestamp") ? commentModel.datePublished.toDate() : commentModel.datePublished).text.make(),
                            SizedBox(width: 10,),
                            "${commentModel.likes.length} likes".text.make(),
                          ],
                        ),
                        trailing: Icon( Icons.favorite, color: commentModel.likes.contains(FirebaseAuth.instance.currentUser!.uid) ? Colors.red : Colors.white,).onTap(() {
                          commentController.likeUnlikeComments(commentModel, widget.videoModel.videoId);
                        }),
                      );
                    }) : Center(child: CircularProgressIndicator(),);
              },),
            ),
            Container(
              height: 110,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: Get.width - 80,
                      child: TextInputField(textEditingController:commentEditingController, icon: Icons.edit, hintText: "Enter Comment", labelText: "Comment", textInputType: TextInputType.text)),
                  "Sent".text.bold.xl2.make().p8().onTap(() {
                    if(commentEditingController.text.isEmpty){
                      Utils.showCustomSnack("Comment should not be empty!");
                    }else{
                      commentController.postComment(widget.videoModel, commentEditingController.text.trim()).then((value){
                        if(value == true){
                          Utils.showCustomSnack("Comment on video", title: "Success", isError: false);
                        }else {
                          Utils.showCustomSnack(value);
                        }
                      });
                    }
                    commentEditingController.clear();
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
