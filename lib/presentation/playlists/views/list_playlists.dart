import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv_player/common/constants/constants.dart';
import 'package:iptv_player/data/models/playlist.dart';
import 'package:iptv_player/data/repositories/channel_repository.dart';
import 'package:iptv_player/data/repositories/playlist_repository.dart';
import 'package:iptv_player/presentation/channel/bloc/channel_bloc.dart';
import 'package:iptv_player/presentation/channel/view/list_channels.dart';
import 'package:iptv_player/presentation/playlists/bloc/playlist_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iptv_player/presentation/playlists/views/list_playlists_child.dart';

class ListPlaylistsPage extends StatefulWidget {
  const ListPlaylistsPage({super.key});

  @override
  State<ListPlaylistsPage> createState() => _ListPlaylistsPageState();
}

class _ListPlaylistsPageState extends State<ListPlaylistsPage> {
  PlaylistType? playlistType;
  @override
  Widget build(BuildContext context) {
    _getAllPlaylists(context, playlistType);

    Widget buildFilter(context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                playlistType = null;
              });
              _getAllPlaylists(context, playlistType);
            },
            icon: const Icon(Icons.category_outlined),
            label: Text(AppLocalizations.of(context)!.all),
            iconAlignment: IconAlignment.start,
            style: Theme.of(context).textButtonTheme.style!.copyWith(
                  backgroundColor: WidgetStateProperty.all(playlistType == null
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white),
                  iconColor: WidgetStateProperty.all(playlistType == null
                      ? Colors.white
                      : Theme.of(context).colorScheme.onPrimary),
                  foregroundColor: WidgetStateProperty.all(playlistType == null
                      ? Colors.white
                      : Theme.of(context).colorScheme.onPrimary),
                ),
          ),
          for (var type in PlaylistType.values)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  playlistType = type;
                });
                _getAllPlaylists(context, playlistType);
              },
              icon: const Icon(Icons.filter),
              label: Text(getLocalization(type, context)),
              iconAlignment: IconAlignment.start,
              style: Theme.of(context).textButtonTheme.style!.copyWith(
                    backgroundColor: WidgetStateProperty.all(
                        playlistType == type
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white),
                    iconColor: WidgetStateProperty.all(playlistType == type
                        ? Colors.white
                        : Theme.of(context).colorScheme.onPrimary),
                    foregroundColor: WidgetStateProperty.all(
                        playlistType == type
                            ? Colors.white
                            : Theme.of(context).colorScheme.onPrimary),
                  ),
            ),
        ],
      );
    }

    Widget buildListPlaylists(context, state) {
      if (state.status == PlaylistStatus.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.status == PlaylistStatus.success) {
        return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.3,
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
                    else
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Theme(
                                    data: Theme.of(context),
                                    child: BlocProvider<PlaylistBloc>(
                                      create: (_) => PlaylistBloc(
                                          playlistRepository:
                                              PlaylistRepository()),
                                      child: ListPlaylistsChild(
                                        parentId: playlist.id!,
                                        playlistName: playlist.name,
                                        channelCount:
                                            playlist.playlistChildCount!,
                                      ),
                                    )))),
                      }
                  },
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              playlist.url != '' && playlist.url != null
                                  ? CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Color(
                                          int.parse(playlist.avatarColor)),
                                      child: Icon(IconData(
                                          int.parse(playlist.avatarIcon),
                                          fontFamily: 'MaterialIcons')))
                                  : CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Color(
                                          int.parse(playlist.avatarColor)),
                                      child: Icon(IconData(
                                          int.parse(playlist.avatarIcon),
                                          fontFamily: 'MaterialIcons'))),
                              IconButton(
                                alignment: Alignment.centerRight,
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(playlist.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      '${playlist.childCount == 0 ? playlist.playlistChildCount : playlist.childCount} channels'),
                                ],
                              )),
                        ],
                      )),
                ),
              );
            });
      } else {
        return const Center(child: Text('Failed to fetch playlists'));
      }
    }

    buildPageContent(context, state) {
      return SingleChildScrollView(
          child: Column(
        children: [
          buildFilter(context),
          buildListPlaylists(context, state),
        ],
      ));
    }

    return SafeArea(
        child: Padding(
            padding: EdgeInsets.all(16),
            child: BlocBuilder<PlaylistBloc, PlaylistState>(
                builder: (context, state) {
              return buildPageContent(context, state);
            })));
  }

  void _getAllPlaylists(BuildContext context, PlaylistType? type) {
    context.read<PlaylistBloc>().add(PlaylistLoad(type: type));
  }
}
