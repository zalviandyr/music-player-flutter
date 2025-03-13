import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/event_state/event_state.dart';
import 'package:music_player/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  PlaylistBloc() : super(PlaylistUninitialized()) {
    on<PlaylistSave>(_onPlaylistSave);
    on<PlaylistRetrieve>(_onPlaylistRetrieve);
  }

  Future<void> _onPlaylistSave(
      PlaylistSave event, Emitter<PlaylistState> emit) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final existingPlaylists = Playlist.fromJsonToList(
          sharedPreferences.getStringList(Playlist.sharedPref()));

      final dirName = event.dirPath.split('/').last;
      final saveData = Playlist(
        name: dirName,
        path: event.dirPath,
        countMusic: event.pathMp3.length,
      );

      // Hindari duplikasi playlist berdasarkan path
      final newPlaylist = existingPlaylists
          .where((playlist) => playlist.path != saveData.path)
          .toList();

      newPlaylist.add(saveData);

      await sharedPreferences.setStringList(
        Playlist.sharedPref(),
        Playlist.fromListToListString(newPlaylist),
      );

      emit(PlaylistRetrieveSuccess(listPlaylist: newPlaylist));
    } catch (e, trace) {
      onError(e, trace);

      emit(PlaylistError());
    }
  }

  Future<void> _onPlaylistRetrieve(
      PlaylistRetrieve event, Emitter<PlaylistState> emit) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final playlistData =
          sharedPreferences.getStringList(Playlist.sharedPref()) ?? [];

      final listPlaylist =
          playlistData.map((data) => Playlist.fromJson(data)).toList();

      emit(PlaylistRetrieveSuccess(listPlaylist: listPlaylist));
    } catch (e, trace) {
      onError(e, trace);

      emit(PlaylistError());
    }
  }
}
