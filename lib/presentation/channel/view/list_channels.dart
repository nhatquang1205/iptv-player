import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv_player/common/widgets/video_card.dart';
import 'package:iptv_player/data/models/channel.dart';
import 'package:iptv_player/presentation/channel/bloc/channel_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iptv_player/presentation/video_player/video_play_page.dart';

class ListChannelsPage extends StatefulWidget {
  final int? playlistId;
  final String playlistName;
  final int videoCount;
  final String avatarIcon;
  final String avatarColor;
  ListChannelsPage(
      {super.key,
      this.playlistId,
      required this.playlistName,
      required this.videoCount,
      required this.avatarIcon,
      required this.avatarColor});

  @override
  State<ListChannelsPage> createState() => _ListChannelsPageState();
}

class _ListChannelsPageState extends State<ListChannelsPage> {
  int filterType = 0;
  Widget buildListChannels(context, state) {
    if (state.status == ChannelStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.status == ChannelStatus.success) {
      return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: state.channels.length,
          itemBuilder: (context, index) {
            final channel = state.channels[index] as Channel;
            return Card(
              child: GestureDetector(
                  onTap: () => {
                        // Play video
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayPage(
                              videoUrl: channel.url,
                              videoType: channel.url.startsWith("http")
                                  ? VideoType.network
                                  : VideoType
                                      .file, // or VideoType.file for local files
                            ),
                          ),
                        ),
                      },
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        VideoCard(
                            imagePath: channel.thumbnail,
                            videoName: channel.title,
                            isFavorite: channel.isFavorite,
                            avatarColor: widget.avatarColor,
                            avatarIcon: widget.avatarIcon,
                            onFavoriteToggle: () {
                              // ✅ Toggle favorite
                            }),
                        SizedBox(height: 4),
                        Text(
                          channel.title,
                          maxLines: 1, // ✅ Only one line
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  )),
            );
          });
    } else {
      return const Center(child: Text('Failed to fetch channels'));
    }
  }

  Widget buildSearchTextBox(context) {
    return Padding(
        padding: EdgeInsets.all(8),
        child: TextField(
          decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.searchChannel,
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10)),
        ));
  }

  Widget buildFilter(context) {
    return Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () {
                setState(() {
                  filterType = 0;
                });
                // _getAllPlaylists(context, playlistType);
              },
              label: Text(AppLocalizations.of(context)!.all),
              style: Theme.of(context).textButtonTheme.style!.copyWith(
                    backgroundColor: WidgetStateProperty.all(filterType == 0
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white),
                    foregroundColor: WidgetStateProperty.all(filterType == 0
                        ? Colors.white
                        : Theme.of(context).colorScheme.onPrimary),
                  ),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  filterType = 1;
                });
                // _getAllPlaylists(context, playlistType);
              },
              label: Text(AppLocalizations.of(context)!.recent),
              style: Theme.of(context).textButtonTheme.style!.copyWith(
                    backgroundColor: WidgetStateProperty.all(filterType == 1
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white),
                    foregroundColor: WidgetStateProperty.all(filterType == 1
                        ? Colors.white
                        : Theme.of(context).colorScheme.onPrimary),
                  ),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  filterType = 2;
                });
                // _getAllPlaylists(context, playlistType);
              },
              label: Text(AppLocalizations.of(context)!.favorite),
              style: Theme.of(context).textButtonTheme.style!.copyWith(
                    backgroundColor: WidgetStateProperty.all(filterType == 2
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white),
                    foregroundColor: WidgetStateProperty.all(filterType == 2
                        ? Colors.white
                        : Theme.of(context).colorScheme.onPrimary),
                  ),
            ),
          ],
        ));
  }

  buildPageContent(context, state) {
    return SingleChildScrollView(
        child: Column(
      children: [
        buildSearchTextBox(context),
        buildFilter(context),
        buildListChannels(context, state),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              centerTitle: true,
              title: Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Column(
                    children: [
                      Text(
                        widget.playlistName,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .channelCount(widget.videoCount),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontSize: 16),
                      ),
                    ],
                  )),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context), // ✅ Back button
              ),
            ),
            body: Padding(
                padding: EdgeInsets.all(16),
                child: BlocBuilder<ChannelBloc, ChannelState>(
                    builder: (context, state) {
                  return buildPageContent(context, state);
                }))));
  }
}
