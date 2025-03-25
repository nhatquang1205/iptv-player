import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv_player/common/constants/constants.dart';
import 'package:iptv_player/data/models/playlist.dart';
import 'package:iptv_player/data/repositories/channel_repository.dart';
import 'package:iptv_player/presentation/channel/bloc/channel_bloc.dart';
import 'package:iptv_player/presentation/channel/view/list_channels.dart';
import 'package:iptv_player/presentation/playlists/bloc/playlist_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListPlaylistsChild extends StatefulWidget {
  final int parentId;
  final String playlistName;
  final int channelCount;

  const ListPlaylistsChild(
      {super.key,
      required this.parentId,
      required this.playlistName,
      required this.channelCount});

  @override
  _ListPlaylistsChildState createState() => _ListPlaylistsChildState();
}

class _ListPlaylistsChildState extends State<ListPlaylistsChild> {
  @override
  Widget build(BuildContext context) {
    _getPlaylistsByParentId(context, widget.parentId);

    Widget buildListPlaylists(context, state) {
      if (state.status == PlaylistStatus.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.status == PlaylistStatus.success) {
        return ConstrainedBox(
            constraints: BoxConstraints(minHeight: 0),
            child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 8,
                  childAspectRatio: 4,
                ),
                itemCount: state.playlists.length,
                itemBuilder: (context, index) {
                  final playlist = state.playlists[index] as Playlist;
                  return Card(
                    child: GestureDetector(
                      onTap: () => {
                        if (playlist.type == PlaylistType.library ||
                            (playlist.type == PlaylistType.files &&
                                playlist.playlistChildCount == 0 &&
                                playlist.childCount! > 0))
                          {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return BlocProvider(
                                create: (context) => ChannelBloc(
                                    channelRepository: ChannelRepository())
                                  ..add(ChannelLoad(playlistId: playlist.id)),
                                child: Theme(
                                    data: Theme.of(context),
                                    child: ListChannelsPage(
                                        playlistName: playlist.name,
                                        playlistId: playlist.id,
                                        videoCount: playlist.childCount!,
                                        avatarIcon: playlist.avatarIcon,
                                        avatarColor: playlist.avatarColor)),
                              );
                            })),
                          }
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            playlist.url != '' && playlist.url != null
                                ? CircleAvatar(
                                    radius: 24,
                                    backgroundColor:
                                        Color(int.parse(playlist.avatarColor)),
                                    child: Icon(IconData(
                                        int.parse(playlist.avatarIcon),
                                        fontFamily: 'MaterialIcons')))
                                : CircleAvatar(
                                    radius: 24,
                                    backgroundColor:
                                        Color(int.parse(playlist.avatarColor)),
                                    child: Icon(IconData(
                                        int.parse(playlist.avatarIcon),
                                        fontFamily: 'MaterialIcons'))),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(playlist.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        '${playlist.childCount == 0 ? playlist.playlistChildCount : playlist.childCount} channels'),
                                  ],
                                )),
                            IconButton(
                              alignment: Alignment.centerRight,
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }));
      } else {
        return const Center(child: Text('Failed to fetch playlists'));
      }
    }

    buildPageContent(context, state) {
      return SingleChildScrollView(
          child: Column(
        children: [
          buildListPlaylists(context, state),
        ],
      ));
    }

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              centerTitle: true,
              title: Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 8),
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
                            .channelCount(widget.channelCount),
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
            body: SafeArea(
                child: Padding(
                    padding: EdgeInsets.all(16),
                    child: BlocBuilder<PlaylistBloc, PlaylistState>(
                        builder: (context, state) {
                      return buildPageContent(context, state);
                    })))));
  }

  void _getPlaylistsByParentId(BuildContext context, int parentId) {
    context
        .read<PlaylistBloc>()
        .add(PlaylistLoadByParentId(parentId: parentId));
  }
}
