part of 'playlist_bloc.dart';

enum PlaylistStatus {
  initial,
  loading,
  success,
  error,
}

class PlaylistState {
  final PlaylistStatus status;
  final List<Playlist> playlists;
  final String message;

  const PlaylistState({
    this.status = PlaylistStatus.initial,
    this.playlists = const [],
    this.message = '',
  });

  PlaylistState copyWith({
    PlaylistStatus? status,
    List<Playlist>? playlists,
    String? message,
  }) {
    return PlaylistState(
      status: status ?? this.status,
      playlists: playlists ?? this.playlists,
      message: message ?? this.message,
    );
  }
}
