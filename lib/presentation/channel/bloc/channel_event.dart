part of 'channel_bloc.dart';

class ChannelEvent {}

class ChannelLoad extends ChannelEvent {
  final int? playlistId;
  ChannelLoad({this.playlistId});
}
