import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/event_state/event_state.dart';
import 'package:music_player/helper/util.dart';
import 'package:music_player/models/models.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  SongBloc() : super(SongUninitialized()) {
    on(_onSongRetrieve);
  }

  Future<void> _onSongRetrieve(
      SongRetrieve event, Emitter<SongState> emit) async {
    try {
      String path = event.playlistPath;
      List<String> filterMp3 = await Util.filterMp3(path);

      List<Song> songs = [];
      for (String mp3 in filterMp3) {
        songs.add(Song(name: Util.getNameSong(mp3), path: mp3));
      }

      emit(SongRetrieveSuccess(songs: songs));
    } catch (e, trace) {
      onError(e, trace);

      emit(SongError());
    }
  }
}
