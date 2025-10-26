import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv_player/data/models/channel.dart';
import 'package:iptv_player/data/repositories/channel_repository.dart';
import 'package:iptv_player/l10n/app_localizations.dart';
import 'package:iptv_player/presentation/channel/bloc/channel_bloc.dart';
import 'package:iptv_player/presentation/video_player/video_play_page.dart';

class PlaySingleStreamDialog extends StatefulWidget {
  const PlaySingleStreamDialog({super.key});

  @override
  State<PlaySingleStreamDialog> createState() => _PlaySingleStreamDialogState();
}

class _PlaySingleStreamDialogState extends State<PlaySingleStreamDialog> {
  final TextEditingController _streamNameController = TextEditingController();
  final TextEditingController _streamUrlController = TextEditingController();
  bool _isValidUrl = true;

  @override
  void dispose() {
    _streamNameController.dispose();
    _streamUrlController.dispose();
    super.dispose();
  }

  bool _validateUrl(String url) {
    if (url.isEmpty) return false;

    // Check if it's a valid URL (http/https)
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  void _playStream() {
    final url = _streamUrlController.text.trim();
    final name = _streamNameController.text.trim();

    if (!_validateUrl(url)) {
      setState(() {
        _isValidUrl = false;
      });
      return;
    }

    // Create a temporary channel object for display purposes
    final channel = Channel(
      title: name.isEmpty ? 'Live Stream' : name,
      url: url,
      thumbnail: '',
      duration: 0,
      createdAt: DateTime.now(),
      isFavorite: false,
    );

    // Close the dialog
    Navigator.of(context).pop();

    // Navigate to video player with ChannelBloc provider
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ChannelBloc(
            channelRepository: ChannelRepository(),
          ),
          child: VideoPlayPage(
            videoUrl: url,
            videoType: VideoType.network,
            selectedChannel: channel,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            style: const TextStyle(fontSize: 16),
            AppLocalizations.of(context)!.cancel,
          ),
        ),
        title: Text(
          AppLocalizations.of(context)?.playSingleStream ?? 'Play Single Stream',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stream Name (Optional)',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: _streamNameController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'Enter stream name',
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Stream URL',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: _streamUrlController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _isValidUrl ? Colors.grey : Colors.red,
                    ),
                  ),
                  hintText: 'http://example.com/stream.m3u8',
                  errorText: _isValidUrl
                      ? null
                      : 'Please enter a valid URL',
                ),
                onChanged: (value) {
                  if (!_isValidUrl) {
                    setState(() {
                      _isValidUrl = true;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _playStream,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow),
                    SizedBox(width: 8),
                    Text(
                      'Play',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Enter a stream URL to play it directly without saving to a playlist. Supports HTTP/HTTPS streaming URLs.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
