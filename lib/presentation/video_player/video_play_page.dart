import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv_player/data/models/channel.dart';
import 'package:iptv_player/presentation/channel/bloc/channel_bloc.dart';
import 'package:iptv_player/presentation/channel/view/channel_card.dart';

enum VideoType { network, file }

class VideoPlayPage extends StatefulWidget {
  final String videoUrl;
  final VideoType videoType;
  final Channel? selectedChannel;

  VideoPlayPage(
      {required this.videoUrl, required this.videoType, this.selectedChannel});

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayPageState createState() => _VideoPlayPageState();
}

class _VideoPlayPageState extends State<VideoPlayPage> {
  late CustomVideoPlayerController _customVideoPlayerController;
  bool _isLoading = false;
  Channel? _selectedChannel;

  void initializeVideoPlayer() {
    setState(() {
      _isLoading = true;
      _selectedChannel = widget.selectedChannel;
    });
    VideoPlayerController _videoPlayerController;
    if (widget.videoType == VideoType.network) {
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    } else {
      _videoPlayerController =
          VideoPlayerController.file(File(widget.videoUrl));
    }
    _videoPlayerController.initialize().then((_) {
      setState(() {
        _isLoading = false;
      });
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
          title: Text('Video Player ${_selectedChannel?.title ?? ''}'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _isLoading
                ? SizedBox(
                    height: 230,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : CustomVideoPlayer(
                    customVideoPlayerController: _customVideoPlayerController),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height - 350,
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                        children: context
                            .read<ChannelBloc>()
                            .state
                            .channels
                            .map((channel) {
                      return Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: ChannelSelector(
                            channel: channel,
                            onChannelSelected: () {
                              setState(() {
                                _selectedChannel = channel;
                              });
                            },
                          ));
                    }).toList())),
              ),
            ),
          ],
        ));
  }
}
