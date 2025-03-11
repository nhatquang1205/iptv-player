import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv_player/data/models/channel.dart';
import 'package:iptv_player/data/models/playlist.dart';
import 'package:iptv_player/data/repositories/playlist_repository.dart';
import 'package:iptv_player/data/repositories/channel_repository.dart';

part 'channel_event.dart';
part 'channel_state.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  final ChannelRepository channelRepository;

  ChannelBloc({
    required this.channelRepository,
  }) : super(ChannelState()) {
    on<ChannelLoad>(_getAllPlaylists);
  }

  Future<void> _getAllPlaylists(
      ChannelLoad event, Emitter<ChannelState> emit) async {
    emit(state.copyWith(status: ChannelStatus.loading));

    try {
      final channels = await channelRepository.getChannels(event.playlistId);

      emit(state.copyWith(channels: channels, status: ChannelStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ChannelStatus.error));
    }
  }
}
