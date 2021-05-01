import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/event_state/event_state.dart';
import 'package:music_player/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  PlaylistBloc() : super(PlaylistUninitialized());

  @override
  Stream<PlaylistState> mapEventToState(PlaylistEvent event) async* {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      if (event is PlaylistSave) {
        List<Playlist> playlist = Playlist.fromJsonToList(
          sharedPreferences.getStringList(Playlist.sharedPref()),
        );

        // save data
        String dirName = event.dirPath.split('/').last;
        Playlist saveData = Playlist(
          name: dirName,
          path: event.dirPath,
          countMusic: event.pathMp3.length,
        );

        // avoid duplicate path
        List<Playlist> newPlaylist = [];
        playlist.asMap().entries.map((entry) {
          if (entry.value != saveData) {
            newPlaylist.add(entry.value);
          }
        }).toList();

        newPlaylist.add(saveData);

        sharedPreferences.setStringList(
          Playlist.sharedPref(),
          Playlist.fromListToListString(newPlaylist),
        );

        yield PlaylistRetrieveSuccess(listPlaylist: newPlaylist);
      }

      if (event is PlaylistRetrieve) {
        List<Playlist> listPlaylist = [];
        List<String> playlist =
            sharedPreferences.getStringList(Playlist.sharedPref()) ?? [];

        for (String data in playlist) {
          listPlaylist.add(Playlist.fromJson(data));
        }

        yield PlaylistRetrieveSuccess(listPlaylist: listPlaylist);
      }
    } catch (e) {
      print(e);
      yield PlaylistError();
    }
  }
}
