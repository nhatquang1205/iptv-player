part of 'channel_bloc.dart';

class ChannelEvent {}

class ChannelLoad extends ChannelEvent {
  final int? playlistId;
  ChannelLoad({this.playlistId});
}

class ChannelSearch extends ChannelEvent {
  final int? playlistId;
  final String query;
  final bool isFavorite;
  final bool isResetPaging;

  ChannelSearch(
      this.playlistId, this.query, this.isFavorite, this.isResetPaging);
}

class ChannelToggleFavorite extends ChannelEvent {
  final int channelId;
  final bool isFavorite;

  ChannelToggleFavorite(this.channelId, this.isFavorite);
}
