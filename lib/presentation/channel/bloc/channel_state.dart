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

  const ChannelState({
    this.status = ChannelStatus.initial,
    this.channels = const [],
    this.message = '',
  });

  ChannelState copyWith({
    ChannelStatus? status,
    List<Channel>? channels,
    List<Playlist>? playlists,
    int? playlistId,
    String? message,
  }) {
    return ChannelState(
      status: status ?? this.status,
      channels: channels ?? this.channels,
      message: message ?? this.message,
    );
  }
}
