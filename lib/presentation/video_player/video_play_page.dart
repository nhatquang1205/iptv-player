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
  String? _errorMessage;
  Channel? _selectedChannel;
  bool _shouldLoadChannels = false;

  Future<void> initializeVideoPlayer(String videoUrl, VideoType videoType) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Dispose previous controllers if they exist (no await needed)
      if (_customVideoPlayerController != null) {
        _customVideoPlayerController!.dispose();
        _customVideoPlayerController = null;
      }
      if (_videoPlayerController != null) {
        _videoPlayerController!.dispose(); // Removed blocking await
        _videoPlayerController = null;
      }

      // Create video player controller with optimized settings
      if (videoType == VideoType.network) {
        _videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(videoUrl),
          videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: true,
            allowBackgroundPlayback: false,
          ),
          httpHeaders: {
            'Connection': 'keep-alive',
          },
        );
      } else {
        _videoPlayerController = VideoPlayerController.file(File(videoUrl));
      }

      // Initialize with timeout
      await _videoPlayerController!.initialize().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Video initialization timeout. Please check your connection.');
        },
      );

      if (!mounted) return;

      _customVideoPlayerController = CustomVideoPlayerController(
          context: context, videoPlayerController: _videoPlayerController!);

      setState(() {
        _isLoading = false;
        _errorMessage = null;
      });

      // Defer channel list loading until after video is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _shouldLoadChannels = true;
          });
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load video: ${e.toString()}';
      });
    }
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
            // Video player or loading/error state
            _buildVideoPlayerWidget(),
            // Channel list (only shown after video is ready)
            if (_shouldLoadChannels) _buildChannelList(),
          ],
        ));
  }

  Widget _buildVideoPlayerWidget() {
    if (_errorMessage != null) {
      return SizedBox(
        height: 230,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_selectedChannel != null) {
                      final videoType = _selectedChannel!.url.startsWith("http")
                          ? VideoType.network
                          : VideoType.file;
                      initializeVideoPlayer(_selectedChannel!.url, videoType);
                    } else {
                      initializeVideoPlayer(widget.videoUrl, widget.videoType);
                    }
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_isLoading || _customVideoPlayerController == null) {
      return SizedBox(
        height: 230,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Loading video...'),
            ],
          ),
        ),
      );
    }

    return CustomVideoPlayer(
        customVideoPlayerController: _customVideoPlayerController!);
  }

  Widget _buildChannelList() {
    return BlocBuilder<ChannelBloc, ChannelState>(
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
    );
  }
}
