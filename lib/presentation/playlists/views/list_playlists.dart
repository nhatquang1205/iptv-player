import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv_player/common/constants/constants.dart';
import 'package:iptv_player/presentation/playlists/bloc/playlist_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.3,
            ),
            itemCount: state.playlists.length,
            itemBuilder: (context, index) {
              final playlist = state.playlists[index];
              return Card(
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
                                Text('${playlist.childCount} channels'),
                              ],
                            )),
                      ],
                    )),
              );
            });
      } else {
        return const Center(child: Text('Failed to fetch playlists'));
      }
    }

    buildPageContent(context, state) {
      return Column(
        children: [
          buildFilter(context),
          buildListPlaylists(context, state),
        ],
      );
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
