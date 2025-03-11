// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:iptv_player/common/constants/constants.dart';
import 'package:iptv_player/data/models/channel.dart';
import 'package:iptv_player/data/models/playlist.dart';
import 'package:iptv_player/presentation/playlists/bloc/playlist_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:m3u_parser_nullsafe/m3u_parser_nullsafe.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class AddPlaylistView extends StatelessWidget {
  final TypeOfAddPlaylist type;
  final videoInfo = FlutterVideoInfo();

  AddPlaylistView({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PlaylistCubit>().state;
    final colors = [
      '0xFFE57373',
      '0xFFFFD54F',
      '0xFF4DB6AC',
      '0xFF64B5F6',
      '0xFF9575CD',
      '0xFF4DD0E1',
      '0xFF81C784',
      '0xFFFF8A65',
      '0xFFA1887F',
      '0xFF90A4AE'
    ];
    final icons = [
      Icons.link,
      Icons.tv,
      Icons.playlist_play,
      Icons.sports,
      Icons.movie_filter,
      Icons.alarm,
      Icons.music_note,
      Icons.wifi,
      Icons.note,
      Icons.people,
    ];

    Future<String?> getVideoThumbnail(String videoPath) async {
      final String? thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 200,
        quality: 80,
      );
      return thumbnailPath;
    }

    Future<void> pickAndSaveAsyncs() async {
      FilePickerResult? result;
      if (type.type == TypeOfAddPlaylistEnum.uploadFromFiles) {
        result = await FilePicker.platform.pickFiles(
          type: FileType.video,
          allowMultiple: true,
        );
      } else if (type.type == TypeOfAddPlaylistEnum.uploadM3UFile) {
        result = await FilePicker.platform.pickFiles(type: FileType.audio);
      }

      if (result == null || result.count == 0) return;

      List<File> selectedFiles = [];
      context.read<PlaylistCubit>().clearChannels();

      for (final PlatformFile file in result.files) {
        var bytes = await file.xFile.readAsBytes();
        if (file.path == null || bytes.isEmpty) continue;

        final channel = Channel(
          title: file.name,
          url: file.path!,
          thumbnail: '',
          duration: 0,
          createdAt: DateTime.now(),
          isFavorite: false,
        );

        selectedFiles.add(File(file.path!));

        context.read<PlaylistCubit>().addChannel(channel);
      }

      context.read<PlaylistCubit>().addSelectedFiles(selectedFiles);
    }

    generateUploadedChannel() {
      if (state.channels!.isEmpty) {
        return TextButton.icon(
          onPressed: () {
            pickAndSaveAsyncs();
          },
          icon: const Icon(Icons.upload),
          label: Text(type.channelAction ?? ''),
          iconAlignment: IconAlignment.start,
        );
      }
      return TextButton.icon(
          onPressed: () {
            pickAndSaveAsyncs();
          },
          icon: const Icon(Icons.upload),
          iconAlignment: IconAlignment.start,
          label: Text(AppLocalizations.of(context)!
              .numbersOfFileSelected(state.channels!.length)));
    }

    Future<void> savePlaylist() async {
      if (type.type == TypeOfAddPlaylistEnum.importFromLibrary ||
          type.type == TypeOfAddPlaylistEnum.uploadFromFiles) {
        for (var channel in state.channels!) {
          final Directory appDir = await getApplicationDocumentsDirectory();
          final String fileName = basename(channel.url);
          final String savedPath = '${appDir.path}/$fileName';

          final File savedVideo = state.files.firstWhere(
            (file) => file.path == channel.url,
          );

          await savedVideo.copy(savedPath);
          channel.url = savedPath;

          if (type.type == TypeOfAddPlaylistEnum.uploadFromFiles) {
            var videoInfo = await this.videoInfo.getVideoInfo(savedPath);
            String? thumbnailPath = await getVideoThumbnail(channel.url);

            if (thumbnailPath != null && thumbnailPath.isNotEmpty) {
              final thumbnailFile = File(thumbnailPath);
              final String baseThumbnailPath = basename(thumbnailPath);
              final String thumbnailSavedPath =
                  '${appDir.path}/$baseThumbnailPath';
              await thumbnailFile.copy(thumbnailSavedPath);
              channel.thumbnail = thumbnailSavedPath;
              channel.duration = (videoInfo?.duration ?? 0).toInt();
            }
          }
        }
      }

      if (type.type == TypeOfAddPlaylistEnum.inputPlaylistUrl) {}

      if (type.type == TypeOfAddPlaylistEnum.uploadM3UFile) {
        context.read<PlaylistCubit>().clearChannels();
        for (var file in state.files) {
          final m3uList = await M3uList.loadFromFile(file.path);
          if (m3uList.groupTitles.isNotEmpty) {
            var childrenPlaylist = <Playlist>[];
            for (var group in m3uList.groupTitles) {
              final childPlaylist = Playlist(
                name: group,
                thumbnail: '',
                createdAt: DateTime.now(),
                avatarIcon: "0xe380",
                avatarColor: "0xFF64B5F6",
                isUsePassCode: false,
                type: PlaylistType.files,
                children: [],
                channels: [],
              );
              childrenPlaylist.add(childPlaylist);
            }
            for (var item in m3uList.items) {
              final channel = Channel(
                title: item.title,
                url: item.link,
                thumbnail: '',
                duration: 0,
                createdAt: DateTime.now(),
                isFavorite: false,
              );
              childrenPlaylist
                  .where((element) => element.name == item.groupTitle)
                  .first
                  .channels!
                  .add(channel);
            }
            context.read<PlaylistCubit>().addChildrenPlaylist(childrenPlaylist);
          } else {
            for (var item in m3uList.items) {
              final channel = Channel(
                title: item.title,
                url: item.link,
                thumbnail: '',
                duration: 0,
                createdAt: DateTime.now(),
                isFavorite: false,
              );
              context.read<PlaylistCubit>().addChannel(channel);
            }
          }
        }
      }

      await context.read<PlaylistCubit>().savePlaylist();
      Navigator.of(context).pop();
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            TextButton(
                onPressed: () => {savePlaylist()},
                child: Text(AppLocalizations.of(context)!.save))
          ],
          leading: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
                style: TextStyle(fontSize: 16),
                AppLocalizations.of(context)!.cancel),
          ),
          title: Center(
            child: Text(
              type.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                    AppLocalizations.of(context)!.playlistName),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        suffixIcon: type.channelAction != '' &&
                                type.channelAction != null
                            ? generateUploadedChannel()
                            : null,
                      ),
                      onChanged: (value) =>
                          context.read<PlaylistCubit>().updateName(value),
                    )),
                type.type == TypeOfAddPlaylistEnum.inputPlaylistUrl
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontSize: 18,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                              AppLocalizations.of(context)!.inputPlaylistUrl),
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: TextField(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                onChanged: (value) => context
                                    .read<PlaylistCubit>()
                                    .updateUrl(value),
                              )),
                        ],
                      )
                    : SizedBox(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: 20,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w900,
                                    ),
                            AppLocalizations.of(context)!.protectByPasscode),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Switch(
                              value: state.isUsePassCode,
                              onChanged: (value) => {
                                    context
                                        .read<PlaylistCubit>()
                                        .updateIsUsePassCode(value)
                                  }),
                        ),
                      ],
                    ),
                  ),
                ),
                type.type != TypeOfAddPlaylistEnum.inputPlaylistUrl
                    ? Column(
                        children: [
                          Center(
                            child: state.avatarIcon != ''
                                ? CircleAvatar(
                                    radius: 32,
                                    backgroundColor:
                                        Color(int.parse(state.avatarColor)),
                                    child: Icon(IconData(
                                        int.parse(state.avatarIcon),
                                        fontFamily: 'MaterialIcons')),
                                  )
                                : CircleAvatar(
                                    radius: 32,
                                    backgroundColor:
                                        Color(int.parse(state.avatarColor)),
                                  ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1.7,
                              ),
                              itemCount: colors.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    context
                                        .read<PlaylistCubit>()
                                        .updateAvatarColor(colors[index]);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Color(int.parse(colors[index])),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                            child: GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1.7,
                              ),
                              itemCount: icons.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    context
                                        .read<PlaylistCubit>()
                                        .updateAvatarIcon(
                                            icons[index].codePoint.toString());
                                  },
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Color(int.parse(state.avatarColor)),
                                    child: Icon(icons[index]),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            )));
  }
}
