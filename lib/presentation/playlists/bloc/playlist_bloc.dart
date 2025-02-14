import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv_player/common/constants/constants.dart';
import 'package:iptv_player/data/models/playlist.dart';
import 'package:iptv_player/data/repositories/playlist_repository.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final PlaylistRepository playlistRepository;

  PlaylistBloc({required this.playlistRepository})
      : super(const PlaylistState()) {
    on<PlaylistAdd>(_postPlaylist);
    on<PlaylistLoad>(_getAllPlaylists);
  }

  @override
  Stream<PlaylistState> mapEventToState(PlaylistEvent event) async* {
    // if (event is PlaylistLoad) {
    //   yield PlaylistLoading();
    //   try {
    //     final playlists = await playlistRepository.fetchPlaylists();
    //     yield PlaylistLoaded(playlists: playlists);
    //   } catch (e) {
    //     yield PlaylistError(message: e.toString());
    //   }
    // }
  }

  Future<void> _postPlaylist(
      PlaylistAdd event, Emitter<PlaylistState> emit) async {
    emit(state.copyWith(status: PlaylistStatus.loading));

    try {
      await playlistRepository.addPlaylist(event.playlist);

      emit(state.copyWith(
          playlists: [event.playlist, ...state.playlists],
          status: PlaylistStatus.success));
    } catch (e) {
      emit(state.copyWith(status: PlaylistStatus.error));
    }
  }

  Future<void> _getAllPlaylists(
      PlaylistLoad event, Emitter<PlaylistState> emit) async {
    emit(state.copyWith(status: PlaylistStatus.loading));

    try {
      final playlists = await playlistRepository.getPlaylists(event.type);

      emit(
          state.copyWith(playlists: playlists, status: PlaylistStatus.success));
    } catch (e) {
      emit(state.copyWith(status: PlaylistStatus.error));
    }
  }
}
