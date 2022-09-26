import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cached_video_player/cached_video_player.dart';

class ReelsVideoPlayer extends StatefulWidget {
  final String thumbUrl;
  final String videoUrl;
  const ReelsVideoPlayer(
      {Key? key, required this.thumbUrl, required this.videoUrl})
      : super(key: key);

  @override
  State<ReelsVideoPlayer> createState() => _ReelsVideoPlayerState();
}

class _ReelsVideoPlayerState extends State<ReelsVideoPlayer> with WidgetsBindingObserver{
  late CachedVideoPlayerController _controller;
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    // print("===url ${widget.videoUrl}");
    _controller = CachedVideoPlayerController.network(widget.videoUrl);
    _controller.addListener(() {
      setState(() {});
    });

    _controller.initialize().then((_) {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      switch(state) {
        case AppLifecycleState.resumed:
          print("====== resumed");
         if(_controller.value.isInitialized){
           _controller.play();
         }
        // Handle this case
          break;
        case AppLifecycleState.inactive:
          print("====== inactive");
        // Handle this case
          break;
        case AppLifecycleState.paused:
          print("====== paused");
          if(_controller.value.isInitialized){
            _controller.pause();
          }
        // Handle this case
          break;
        case AppLifecycleState.detached:
          print("====== detached");
        // Handle this case
          break;
      }
    });
    super.didChangeAppLifecycleState(state);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? _controller.value.isBuffering ? Center(child: CircularProgressIndicator()) :Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
             child: CachedVideoPlayer(_controller),
          ),
        )
            : /*AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: CachedNetworkImage(
                  imageUrl: widget.thumbUrl,
                ),
              ),*/
        CachedNetworkImage(
          imageUrl: widget.thumbUrl,
        ),
      ),
    );
  }
}