import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv_player/common/constants/constants.dart';
import 'package:iptv_player/presentation/playlists/bloc/playlist_cubit.dart';
import 'package:iptv_player/presentation/playlists/views/add_playlist.dart';

class AddPlaylistMenu extends StatelessWidget {
  const AddPlaylistMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final typeOfAddPlaylists = getTypeOfAddPlaylist(context);
    return SizedBox(
        height: 250,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              for (var typeOfAddPlaylist in typeOfAddPlaylists)
                ListTile(
                  leading: typeOfAddPlaylist.icon,
                  iconColor: Theme.of(context).primaryColor,
                  title: Text(typeOfAddPlaylist.name),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return DraggableScrollableSheet(
                              initialChildSize: 0.6,
                              minChildSize: 0.6,
                              maxChildSize: 1,
                              expand: false,
                              builder: (context, scrollController) {
                                return typeOfAddPlaylist.type !=
                                        TypeOfAddPlaylistEnum.playSingleStream
                                    ? BlocProvider(
                                        create: (_) => PlaylistCubit(
                                            typeOfAddPlaylist.playlistType!),
                                        child: AddPlaylistView(
                                          type: typeOfAddPlaylist,
                                        ),
                                      )
                                    : Container();
                              });
                        });
                  },
                ),
            ],
          ),
        ));
  }
}
