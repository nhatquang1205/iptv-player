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
  CustomVideoPlayerController? _customVideoPlayerController;
  VideoPlayerController? _videoPlayerController;
  bool _isLoading = false;
  Channel? _selectedChannel;

  void initializeVideoPlayer(String videoUrl, VideoType videoType) {
    setState(() {
      _isLoading = true;
    });

    // Dispose previous controllers if they exist
    _customVideoPlayerController?.dispose();
    _videoPlayerController?.dispose();

    if (videoType == VideoType.network) {
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    } else {
      _videoPlayerController =
          VideoPlayerController.file(File(videoUrl));
    }

    _videoPlayerController!.initialize().then((_) {
      setState(() {
        _isLoading = false;
      });
    });

    _customVideoPlayerController = CustomVideoPlayerController(
        context: context, videoPlayerController: _videoPlayerController!);
  }

  void switchChannel(Channel channel) {
    setState(() {
      _selectedChannel = channel;
    });

    final videoType = channel.url.startsWith("http")
        ? VideoType.network
        : VideoType.file;

    initializeVideoPlayer(channel.url, videoType);
  }

  @override
  void initState() {
    super.initState();
    _selectedChannel = widget.selectedChannel;
    initializeVideoPlayer(widget.videoUrl, widget.videoType);
  }

  @override
  void dispose() {
    if (_customVideoPlayerController != null) {
      _customVideoPlayerController!.dispose();
    }
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
    }
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
            _isLoading || _customVideoPlayerController == null
                ? SizedBox(
                    height: 230,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : CustomVideoPlayer(
                    customVideoPlayerController: _customVideoPlayerController!),
            BlocBuilder<ChannelBloc, ChannelState>(
              builder: (context, channelState) {
                if (channelState.channels.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Related Channels',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: channelState.channels.length,
                          itemBuilder: (context, index) {
                            final channel = channelState.channels[index];
                            final isSelected = _selectedChannel?.id == channel.id;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: ChannelSelector(
                                channel: channel,
                                isSelected: isSelected,
                                onChannelSelected: () {
                                  switchChannel(channel);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ));
  }
}
