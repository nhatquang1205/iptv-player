part of 'playlist_bloc.dart';

class PlaylistEvent {}

class PlaylistLoad extends PlaylistEvent {
  final PlaylistType? type;
  PlaylistLoad({required this.type});
}

class PlaylistLoadByParentId extends PlaylistEvent {
  final int parentId;
  PlaylistLoadByParentId({required this.parentId});
}

class PlaylistAdd extends PlaylistEvent {
  final Playlist playlist;
  PlaylistAdd({required this.playlist});
}
