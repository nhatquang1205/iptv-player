import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

enum VideoType { network, file }

class VideoPlayPage extends StatefulWidget {
  final String videoUrl;
  final VideoType videoType;

  VideoPlayPage({required this.videoUrl, required this.videoType});

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayPageState createState() => _VideoPlayPageState();
}

class _VideoPlayPageState extends State<VideoPlayPage> {
  late CustomVideoPlayerController _customVideoPlayerController;
  double _volume = 1.0;
  double _playbackSpeed = 1.0;

  void initializeVideoPlayer() {
    VideoPlayerController _videoPlayerController;
    if (widget.videoType == VideoType.network) {
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    } else {
      _videoPlayerController =
          VideoPlayerController.file(File(widget.videoUrl));
    }
    _videoPlayerController.initialize().then((_) {
      setState(() {});
    });
    _customVideoPlayerController = CustomVideoPlayerController(
        context: context, videoPlayerController: _videoPlayerController);
  }

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text('Video Player'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomVideoPlayer(
                customVideoPlayerController: _customVideoPlayerController),
          ],
        ));
  }
}
