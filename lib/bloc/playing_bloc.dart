import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/event_state/event_state.dart';
import 'package:music_player/helper/util.dart';
import 'package:music_player/models/models.dart';

class PlayingBloc extends Bloc<SongEvent, SongState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<String> filterMp3 = [];

  PlayingBloc() : super(SongUninitialized()) {
    _init();
  }

  void _init() {
    // to handle prev, next and song auto next
    _audioPlayer.currentIndexStream.listen((event) {
      if (event != null) {
        this.add(SongAutoMove(index: event));
      }
    });
  }

  @override
  Stream<SongState> mapEventToState(SongEvent event) async* {
    try {
      if (event is SongPlay) {
        Song currentSong = event.song;
        String path = event.playlistPath;
        filterMp3 = await Util.filterMp3(path);

        // add song path
        filterMp3.insert(0, currentSong.path);

        // remove duplicate
        filterMp3 = filterMp3.toSet().toList();

        await _createPlaylist(filterMp3);

        // stop and play
        await _audioPlayer.stop();
        _audioPlayer.play();

        yield SongPlaying(song: currentSong);
      }

      if (event is SongPlayPause) {
        if (state is SongPlaying) {
          await _audioPlayer.pause();
          yield SongPausing(song: (state as SongPlaying).song);
        } else if (state is SongPausing) {
          _audioPlayer.play();
          yield SongPlaying(song: (state as SongPausing).song);
        }
      }

      if (event is SongNext) {
        if (filterMp3.isNotEmpty && state is SongPlaying) {
          await _audioPlayer.seekToNext();

          // yield handle in currentIndexStream
        }
      }

      if (event is SongPrev) {
        if (filterMp3.isNotEmpty && state is SongPlaying) {
          await _audioPlayer.seekToPrevious();

          // yield handle in currentIndexStream
        }
      }

      if (event is SongShuffle) {
        if (filterMp3.isNotEmpty && state is SongPlaying) {
          // random base on millis
          filterMp3.shuffle(Random(DateTime.now().millisecond));

          // replay song
          await _createPlaylist(filterMp3);

          // stop and play
          await _audioPlayer.stop();
          _audioPlayer.play();

          // handle first song in new playlist
          // if not first, then SongPlaying will emit on currentIndexStream
          if (_audioPlayer.currentIndex == 0) {
            // get current song
            String mp3 = filterMp3.first;
            Song song = Song(name: Util.getNameSong(mp3), path: mp3);

            yield SongPlaying(song: song);
          }
        }
      }

      if (event is SongAutoMove) {
        if (filterMp3.isNotEmpty && state is SongPlaying) {
          Song song = Song(
            name: Util.getNameSong(filterMp3[event.index]),
            path: filterMp3[event.index],
          );

          yield SongPlaying(song: song);
        }
      }
    } catch (e) {
      print(e);
      yield SongError();
    }
  }

  Future<void> _createPlaylist(List<String> playlist) async {
    List<AudioSource> audioSources = [];
    for (String mp3 in playlist) {
      audioSources.add(AudioSource.uri(Uri.parse(mp3)));
    }

    await _audioPlayer
        .setAudioSource(ConcatenatingAudioSource(children: audioSources));

    // set loop
    await _audioPlayer.setLoopMode(LoopMode.all);
  }
}
