import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tiktok_clone/controllers/video_upload_controller.dart';
import 'package:tiktok_clone/helper/utils.dart';
import 'package:tiktok_clone/views/widgets/text_input_field.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

class VideoUpload extends StatefulWidget {
  final String videoPath;
  const VideoUpload({Key? key, required this.videoPath}) : super(key: key);

  @override
  State<VideoUpload> createState() => _VideoUploadState();
}

class _VideoUploadState extends State<VideoUpload> {
  var _songController = TextEditingController();
  var _captionController = TextEditingController();
  late VideoPlayerController _controller;
  @override
  void initState() {
    // TODO: implement initState
    _controller = VideoPlayerController.file(File(widget.videoPath));
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    EasyLoading.removeAllCallbacks();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Upload Video"),),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
              children: [ _controller.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : const CircularProgressIndicator(),
                Positioned(
                  left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    // left: _controller.value.size.width/2,
                    child: Icon( _controller.value.isPlaying ? Icons.pause_circle : Icons.play_circle, size: 50,).onTap(() {
                      _controller.value.isPlaying ? _controller.pause() : _controller.play();
                      setState(() {

                      });
                    }),),
                ]
      ),

                TextInputField(textEditingController: _songController, icon: Icons.music_note, hintText: "Enter Song Name", labelText: "Song Name", textInputType: TextInputType.text),
                TextInputField(textEditingController: _captionController, icon: Icons.closed_caption, hintText: "Enter Caption", labelText: "Caption", textInputType: TextInputType.text),

            ],
          ),
        ),
        bottomNavigationBar: MaterialButton(
            minWidth: Get.width,
            child: "Upload".text.bold.xl.make(),
            color: Colors.red,
            onPressed: (){
              if(_songController.text.isEmpty){
                Utils.showCustomSnack("Song name should not empty");
              }else if(_captionController.text.isEmpty){
                Utils.showCustomSnack("Caption should not empty");
              }else{
                EasyLoading.show(status: "Loading..");
                VideoUploadController().uploadVideoToStorage(_songController.text, _captionController.text, widget.videoPath).then((value) {
                  EasyLoading.dismiss();
                  if(value == true){
                    Get.back();
                    Utils.showCustomSnack("Video successfully uploaded", title: "Success", isError: false);
                  }else{
                    Utils.showCustomSnack(value);
                  }
                });
              }

            }),
      ),
    );
  }
}
