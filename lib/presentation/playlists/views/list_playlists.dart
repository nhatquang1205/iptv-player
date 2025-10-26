import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv_player/common/constants/constants.dart';
import 'package:iptv_player/common/constants/language_constants.dart';
import 'package:iptv_player/data/models/playlist.dart';
import 'package:iptv_player/data/repositories/channel_repository.dart';
import 'package:iptv_player/data/repositories/playlist_repository.dart';
import 'package:iptv_player/l10n/app_localizations.dart';
import 'package:iptv_player/presentation/channel/bloc/channel_bloc.dart';
import 'package:iptv_player/presentation/channel/view/all_channels.dart';
import 'package:iptv_player/presentation/playlists/bloc/playlist_bloc.dart';
import 'package:iptv_player/presentation/playlists/views/list_playlists_child.dart';

class ListPlaylistsPage extends StatefulWidget {
  final bool isRefreshList;
  const ListPlaylistsPage({super.key, this.isRefreshList = false});

  @override
  State<ListPlaylistsPage> createState() => _ListPlaylistsPageState();
}

class _ListPlaylistsPageState extends State<ListPlaylistsPage> {
  PlaylistType? playlistType;

  @override
  void didUpdateWidget(covariant ListPlaylistsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRefreshList) {
      _getAllPlaylists(context, playlistType);
    }
  }

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

    void showActionMenu(
        BuildContext context, TapDownDetails details, int? playlistId) {
      final Offset offset = details.globalPosition;

      showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
          offset.dx,
          offset.dy,
          offset.dx + 1,
          offset.dy + 1,
        ),
        items: [
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.delete),
              iconColor: Theme.of(context).colorScheme.error,
              title: Text(
                translation(context).delete,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () {
                context
                    .read<PlaylistBloc>()
                    .add(PlaylistRemove(playlistId: playlistId!));

                Navigator.pop(context);
              },
            ),
          ),
        ],
      ).then((value) {
        if (value != null) {
          print("Selected: $value");
        }
      });
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
              crossAxisSpacing: 12,
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
                                channelRepository: ChannelRepository()),
                            child: Theme(
                                data: Theme.of(context),
                                child: ListAllChannelsPage(
                                  playlistName: playlist.name,
                                  playlistId: playlist.id,
                                  videoCount: playlist.childCount!,
                                )),
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
                              GestureDetector(
                                onTapDown: (details) => showActionMenu(
                                    context, details, playlist.id),
                                child: Icon(Icons.more_vert_outlined),
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
                                      '${playlist.childCount == 0 ? playlist.playlistChildCount : playlist.childCount} ${translation(context).channels}'),
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

    Widget buildBanner(context) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16, top: 8),
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: AssetImage('assets/images/home_banner.png'),
            fit: BoxFit.fitHeight,
          ),
        ),
      );
    }

    buildPageContent(context, state) {
      return SingleChildScrollView(
          child: Column(
        children: [
          buildFilter(context),
          buildBanner(context),
          buildListPlaylists(context, state),
        ],
      ));
    }

    return SafeArea(
        child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: BlocBuilder<PlaylistBloc, PlaylistState>(
                builder: (context, state) {
              return buildPageContent(context, state);
            })));
  }

  void _getAllPlaylists(BuildContext context, PlaylistType? type) {
    context.read<PlaylistBloc>().add(PlaylistLoad(type: type));
  }
}
