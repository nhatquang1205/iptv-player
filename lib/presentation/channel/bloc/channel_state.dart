part of 'channel_bloc.dart';

enum ChannelStatus {
  initial,
  loading,
  success,
  error,
}

class ChannelState {
  final ChannelStatus status;
  final List<Channel> channels;
  final String message;
  final int total;
  final bool isLoadMore;
  static const limit = 20;

  const ChannelState({
    this.status = ChannelStatus.initial,
    this.channels = const [],
    this.message = '',
    this.total = 0,
    this.isLoadMore = true,
  });

  ChannelState copyWith({
    ChannelStatus? status,
    List<Channel>? channels,
    List<Playlist>? playlists,
    int? playlistId,
    String? message,
    int? total,
    bool? isLoadMore,
  }) {
    return ChannelState(
      status: status ?? this.status,
      channels: channels ?? this.channels,
      message: message ?? this.message,
      total: total ?? this.total,
      isLoadMore: isLoadMore ?? this.isLoadMore,
    );
  }
}
