part of 'playlist_bloc.dart';

class PlaylistEvent {}

class PlaylistLoad extends PlaylistEvent {
  final PlaylistType? type;
  PlaylistLoad({required this.type});
}

class PlaylistAdd extends PlaylistEvent {
  final Playlist playlist;
  PlaylistAdd({required this.playlist});
}
