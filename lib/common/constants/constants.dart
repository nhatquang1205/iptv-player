import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final class NavBarIconConstants {
  static const List<String> iconPaths = [
    'assets/icons/LiveTV.svg',
    'assets/icons/Cast.svg',
    'assets/icons/TV.svg',
    'assets/icons/Settings.svg',
  ];

  static const List<String> iconLabels = [
    'Home',
    'Channel',
    'XTream',
    'Setting',
  ];

  static String getLocalizeLabel(int index, BuildContext context) {
    switch (index) {
      case 0:
        return AppLocalizations.of(context)?.home ?? '';
      case 1:
        return AppLocalizations.of(context)?.channels ?? '';
      case 2:
        return AppLocalizations.of(context)?.xtream ?? '';
      case 3:
        return AppLocalizations.of(context)?.settings ?? '';
      default:
        return '';
    }
  }
}

enum TypeOfAddPlaylistEnum {
  inputPlaylistUrl,
  uploadM3UFile,
  uploadFromFiles,
  playSingleStream,
  importFromLibrary,
}

enum PlaylistType {
  url,
  files,
  library,
}

String getLocalization(PlaylistType type, BuildContext context) {
  switch (type) {
    case PlaylistType.url:
      return AppLocalizations.of(context)?.url ?? '';
    case PlaylistType.files:
      return AppLocalizations.of(context)?.files ?? '';
    case PlaylistType.library:
      return AppLocalizations.of(context)?.gallery ?? '';
  }
}

final class TypeOfAddPlaylist {
  String name;
  TypeOfAddPlaylistEnum type;
  Icon icon;
  String? channelAction;
  PlaylistType? playlistType;

  TypeOfAddPlaylist(
      this.name, this.type, this.icon, this.channelAction, this.playlistType);
}

List<TypeOfAddPlaylist> getTypeOfAddPlaylist(BuildContext context) {
  return [
    TypeOfAddPlaylist(
        AppLocalizations.of(context)?.inputPlaylistUrl ?? '',
        TypeOfAddPlaylistEnum.inputPlaylistUrl,
        Icon(Icons.link),
        '',
        PlaylistType.url),
    TypeOfAddPlaylist(
        AppLocalizations.of(context)?.uploadM3UFile ?? '',
        TypeOfAddPlaylistEnum.uploadM3UFile,
        Icon(Icons.upload),
        AppLocalizations.of(context)?.uploadFile ?? '',
        PlaylistType.files),
    TypeOfAddPlaylist(
        AppLocalizations.of(context)?.playSingleStream ?? '',
        TypeOfAddPlaylistEnum.playSingleStream,
        Icon(Icons.play_circle_outline_outlined),
        '',
        null),
    TypeOfAddPlaylist(
        AppLocalizations.of(context)?.uploadFromFiles ?? '',
        TypeOfAddPlaylistEnum.uploadFromFiles,
        Icon(Icons.add),
        AppLocalizations.of(context)?.uploadVideo ?? '',
        PlaylistType.library),
    // TypeOfAddPlaylist(
    //   AppLocalizations.of(context)?.importFromLibrary ?? '',
    //   TypeOfAddPlaylistEnum.importFromLibrary,
    //   Icon(Icons.add),
    //   AppLocalizations.of(context)?.uploadVideo ?? '',
    // ),
  ];
}
