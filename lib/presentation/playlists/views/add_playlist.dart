// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:http/http.dart' as http;
import 'package:iptv_player/common/constants/constants.dart';
import 'package:iptv_player/data/models/channel.dart';
import 'package:iptv_player/data/models/playlist.dart';
import 'package:iptv_player/data/repositories/channel_repository.dart';
import 'package:iptv_player/data/repositories/playlist_repository.dart';
import 'package:iptv_player/presentation/channel/bloc/channel_bloc.dart';
import 'package:iptv_player/presentation/home/home_page.dart';
import 'package:iptv_player/presentation/playlists/bloc/playlist_cubit.dart';
import 'package:iptv_player/presentation/video_player/video_play_page.dart';
import 'package:iptv_player/l10n/app_localizations.dart';
import 'package:m3u_parser_nullsafe/m3u_parser_nullsafe.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class AddPlaylistView extends StatefulWidget {
  final TypeOfAddPlaylist type;

  AddPlaylistView({super.key, required this.type});

  @override
  State<AddPlaylistView> createState() => _AddPlaylistViewState();
}

class _AddPlaylistViewState extends State<AddPlaylistView> {
  final videoInfo = FlutterVideoInfo();
  bool isLoading = false;

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
      if (widget.type.type == TypeOfAddPlaylistEnum.uploadFromFiles) {
        result = await FilePicker.platform.pickFiles(
          type: FileType.video,
          allowMultiple: true,
        );
      } else if (widget.type.type == TypeOfAddPlaylistEnum.uploadM3UFile) {
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
          label: Text(widget.type.channelAction ?? ''),
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

    Future<String?> downloadAndSaveFile(String url, String fileName) async {
      try {
        // Step 1: Download the file as bytes
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          // Step 2: Get the device's temporary or application directory
          final directory =
              await getApplicationDocumentsDirectory(); // or getTemporaryDirectory()

          // Step 3: Create a file path
          final filePath = '${directory.path}/$fileName';

          // Step 4: Write the bytes to a file
          File file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          return filePath; // Return file path after saving
        } else {
          print("Failed to download file: ${response.statusCode}");
          return null;
        }
      } catch (e) {
        print("Error downloading file: $e");
        return null;
      }
    }

    Future<void> deleteFile(String filePath) async {
      try {
        File file = File(filePath);
        if (await file.exists()) {
          await file.delete();
          print("File deleted: $filePath");
        }
      } catch (e) {
        print("Error deleting file: $e");
      }
    }

    Future<void> savePlaylist() async {
      setState(() {
        isLoading = true;
      });
      if (widget.type.type == TypeOfAddPlaylistEnum.importFromLibrary ||
          widget.type.type == TypeOfAddPlaylistEnum.uploadFromFiles) {
        for (var channel in state.channels!) {
          final Directory appDir = await getApplicationDocumentsDirectory();
          final String fileName = path.basename(channel.url);
          final String savedPath = '${appDir.path}/$fileName';

          final File savedVideo = state.files.firstWhere(
            (file) => file.path == channel.url,
          );

          await savedVideo.copy(savedPath);
          channel.url = savedPath;

          if (widget.type.type == TypeOfAddPlaylistEnum.uploadFromFiles) {
            var videoInfo = await this.videoInfo.getVideoInfo(savedPath);
            String? thumbnailPath = await getVideoThumbnail(channel.url);

            if (thumbnailPath != null && thumbnailPath.isNotEmpty) {
              final thumbnailFile = File(thumbnailPath);
              final String baseThumbnailPath = path.basename(thumbnailPath);
              final String thumbnailSavedPath =
                  '${appDir.path}/$baseThumbnailPath';
              await thumbnailFile.copy(thumbnailSavedPath);
              channel.thumbnail = thumbnailSavedPath;
              channel.duration = (videoInfo?.duration ?? 0).toInt();
            }
          }
        }
      }

      if (widget.type.type == TypeOfAddPlaylistEnum.inputPlaylistUrl) {
        var filePath =
            await downloadAndSaveFile(state.url!, state.url!.split('/').last);

        if (filePath == null) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to download playlist. Please check the URL and try again.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        try {
          final m3uList = await M3uList.loadFromFile(filePath);
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
                thumbnail: item.attributes['tvg-logo'] ?? '',
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

          await deleteFile(filePath);
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to parse playlist file. Please ensure it\'s a valid M3U file.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          await deleteFile(filePath);
          return;
        }
      }

      if (widget.type.type == TypeOfAddPlaylistEnum.uploadM3UFile) {
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
                thumbnail: item.attributes['tvg-logo'] ?? '',
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

      // Save playlist and get the newly created playlist ID
      final playlistId = await context.read<PlaylistCubit>().savePlaylist();

      setState(() {
        isLoading = false;
      });

      if (!mounted) return;

      // Get the current playlist state which contains children info
      final playlistState = context.read<PlaylistCubit>().state;
      final playlistRepository = PlaylistRepository();
      int? targetPlaylistId = playlistId;

      // Check if playlist has children (like M3U groups)
      if (playlistState.children != null && playlistState.children!.isNotEmpty) {
        // Get child playlists from database to get their IDs
        final childPlaylists = await playlistRepository.getPlaylistsByParentId(playlistId);
        if (childPlaylists.isNotEmpty) {
          // Use first child's ID as target
          targetPlaylistId = childPlaylists.first.id;
        }
      }

      // Load channels from the target playlist (either main or first child)
      final channelRepository = ChannelRepository();
      final channels = await channelRepository.getChannels(targetPlaylistId);

      // If there are channels, navigate to video player with first channel
      if (channels.isNotEmpty && mounted) {
        final firstChannel = channels.first;
        final videoType = firstChannel.url.startsWith("http")
            ? VideoType.network
            : VideoType.file;

        // Navigate to video player and auto-play first channel
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => ChannelBloc(channelRepository: channelRepository)
                ..add(ChannelLoad(playlistId: targetPlaylistId)),
              child: VideoPlayPage(
                selectedChannel: firstChannel,
                videoUrl: firstChannel.url,
                videoType: videoType,
              ),
            ),
          ),
        );
      } else {
        // No channels, just go to home page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            TextButton(
                onPressed: () => {savePlaylist()},
                child: Text(
                    style: TextStyle(fontSize: 16),
                    AppLocalizations.of(context)!.save))
          ],
          leadingWidth: 80,
          leading: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
                style: TextStyle(fontSize: 16),
                AppLocalizations.of(context)!.cancel),
          ),
          title: Text(
            widget.type.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: true,
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
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
                            suffixIcon: widget.type.channelAction != '' &&
                                    widget.type.channelAction != null
                                ? generateUploadedChannel()
                                : null,
                          ),
                          onChanged: (value) =>
                              context.read<PlaylistCubit>().updateName(value),
                        )),
                    widget.type.type == TypeOfAddPlaylistEnum.inputPlaylistUrl
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
                                  AppLocalizations.of(context)!
                                      .inputPlaylistUrl),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(8),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontSize: 20,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w900,
                                    ),
                                AppLocalizations.of(context)!
                                    .protectByPasscode),
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
                    widget.type.type != TypeOfAddPlaylistEnum.inputPlaylistUrl
                        ? Column(
                            children: [
                              Center(
                                child: state.avatarIcon != ''
                                    ? Builder(
                                        builder: (context) {
                                          final iconData = IconData(
                                            int.parse(state.avatarIcon),
                                            fontFamily: 'MaterialIcons',
                                          );
                                          return CircleAvatar(
                                            radius: 32,
                                            backgroundColor:
                                                Color(int.parse(state.avatarColor)),
                                            child: Icon(iconData),
                                          );
                                        },
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
                                            .updateAvatarIcon(icons[index]
                                                .codePoint
                                                .toString());
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
                  ),
                ),
              ));
  }
}
