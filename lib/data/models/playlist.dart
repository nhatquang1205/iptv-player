import 'dart:io';

import 'package:iptv_player/common/constants/constants.dart';
import 'package:iptv_player/data/models/channel.dart';

class Playlist {
  int? id;
  String name;
  String avatarIcon;
  String avatarColor;
  bool isUsePassCode;
  PlaylistType type;
  String? passCode;
  DateTime createdAt;
  List<Channel>? channels;
  String? url;
  String? thumbnail;
  int? parentId;
  int? childCount;
  int? playlistChildCount;
  List<Playlist>? children;

  late List<File> files;

  Playlist({
    this.id,
    required this.name,
    required this.avatarIcon,
    required this.avatarColor,
    required this.isUsePassCode,
    required this.createdAt,
    required this.type,
    this.passCode,
    this.channels,
    this.files = const [],
    this.url,
    this.childCount,
    this.playlistChildCount,
    this.thumbnail,
    this.children,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      name: json['name'],
      avatarIcon: json['avatar_icon'],
      avatarColor: json['avatar_color'],
      isUsePassCode: json['is_use_passcode'] == 1,
      passCode: json['pass_code'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      type: PlaylistType.values[json['type']],
      childCount: json['child_count'],
      playlistChildCount: json['playlist_child_count'],
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar_icon': avatarIcon,
      'avatar_color': avatarColor,
      'is_use_passcode': isUsePassCode ? 1 : 0,
      'passcode': passCode,
      'created_at': createdAt.toIso8601String(),
      'url': url,
      'type': type.index,
      'parent_id': parentId,
      'thumbnail': thumbnail,
    };
  }

  Playlist copyWith({
    String? name,
    String? avatarIcon,
    String? avatarColor,
    String? passCode,
    bool? isUsePassCode,
    DateTime? createdAt,
    List<Channel>? channels,
    List<File>? files,
    String? url,
    List<Playlist>? children,
  }) {
    return Playlist(
      name: name ?? this.name,
      avatarIcon: avatarIcon ?? this.avatarIcon,
      avatarColor: avatarColor ?? this.avatarColor,
      passCode: passCode ?? this.passCode,
      isUsePassCode: isUsePassCode ?? this.isUsePassCode,
      createdAt: createdAt ?? this.createdAt,
      channels: channels ?? this.channels,
      files: files ?? this.files,
      url: url ?? this.url,
      type: type,
      children: children ?? this.children,
    );
  }
}
