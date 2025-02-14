import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv_player/common/constants/constants.dart';
import 'package:iptv_player/data/models/channel.dart';
import 'package:iptv_player/data/models/playlist.dart';
import 'package:iptv_player/data/repositories/playlist_repository.dart';

class PlaylistCubit extends Cubit<Playlist> {
  final PlaylistRepository _playlistRepository = PlaylistRepository();
  PlaylistCubit(PlaylistType type)
      : super(Playlist(
            name: "",
            avatarIcon: "0xe380",
            avatarColor: "0xFF64B5F6",
            passCode: "",
            isUsePassCode: false,
            createdAt: DateTime.now(),
            channels: [],
            type: type));

  savePlaylist() async {
    await _playlistRepository.addPlaylist(state);
  }

  addSelectedFiles(List<File> files) {
    emit(state.copyWith(files: files));
  }

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateAvatarIcon(String avatarIcon) {
    emit(state.copyWith(avatarIcon: avatarIcon));
  }

  void updateAvatarColor(String avatarColor) {
    emit(state.copyWith(avatarColor: avatarColor));
  }

  void updatePassCode(String passCode) {
    emit(state.copyWith(passCode: passCode));
  }

  void updateIsUsePassCode(bool isUsePassCode) {
    emit(state.copyWith(isUsePassCode: isUsePassCode));
  }

  void updateCreatedAt(DateTime createdAt) {
    emit(state.copyWith(createdAt: createdAt));
  }

  void updateUrl(String url) {
    emit(state.copyWith(url: url));
  }

  void addChannel(Channel channel) {
    emit(state.copyWith(channels: [...state.channels!, channel]));
  }

  void removeChannel(Channel channel) {
    emit(state.copyWith(
        channels: state.channels!.where((c) => c.id != channel.id).toList()));
  }

  void updateChannel(Channel channel) {
    emit(state.copyWith(
        channels: state.channels!
            .map((c) => c.id == channel.id ? channel : c)
            .toList()));
  }

  void reorderChannel(int oldIndex, int newIndex) {
    final channels = state.channels;
    final channel = channels!.removeAt(oldIndex);
    channels.insert(newIndex, channel);
    emit(state.copyWith(channels: channels));
  }

  void clearChannels() {
    emit(state.copyWith(channels: [], files: List.empty()));
  }

  void updatePlaylist(Playlist playlist) {
    emit(playlist);
  }
}
