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
    on<ChannelSearch>(_searchPlaylist);
    on<ChannelToggleFavorite>(_toggleFavorite);
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

  Future<void> _searchPlaylist(
      ChannelSearch event, Emitter<ChannelState> emit) async {
    emit(state.copyWith(status: ChannelStatus.loading));

    try {
      if (event.isResetPaging) {
        emit(state.copyWith(total: 0, channels: []));
      }
      final channels = await channelRepository.searchChannels(event.playlistId,
          event.query, event.isFavorite, ChannelState.limit, state.total);

      emit(state.copyWith(
          total: channels.length + state.total,
          isLoadMore: channels.isNotEmpty,
          channels: [...state.channels, ...channels],
          status: ChannelStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ChannelStatus.error));
    }
  }

  Future<void> _toggleFavorite(
      ChannelToggleFavorite event, Emitter<ChannelState> emit) async {
    emit(state.copyWith(status: ChannelStatus.loading));

    try {
      await channelRepository.toggleFavorite(event.channelId, event.isFavorite);

      final channels = state.channels.map((e) {
        if (e.id == event.channelId) {
          e.isFavorite = event.isFavorite;
        }
        return e;
      }).toList();

      emit(state.copyWith(channels: channels, status: ChannelStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ChannelStatus.error));
    }
  }
}
