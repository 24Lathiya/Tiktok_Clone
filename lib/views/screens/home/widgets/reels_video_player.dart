import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cached_video_player/cached_video_player.dart';

class ReelsVideoPlayer extends StatefulWidget {
  final String thumbUrl;
  final String videoUrl;
  final bool isHome;
  const ReelsVideoPlayer(
      {Key? key, required this.thumbUrl, required this.videoUrl, required this.isHome})
      : super(key: key);

  @override
  State<ReelsVideoPlayer> createState() => _ReelsVideoPlayerState();
}

class _ReelsVideoPlayerState extends State<ReelsVideoPlayer> {
  late CachedVideoPlayerController _controller;
  @override
  void initState() {
    // TODO: implement initState

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
  void didUpdateWidget(covariant ReelsVideoPlayer oldWidget) { // this will trigger on change state in parent
    // TODO: implement didUpdateWidget
    widget.isHome ? _controller.play() : _controller.pause();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? _controller.value.isBuffering ? const Center(child: CircularProgressIndicator()) :Center(
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