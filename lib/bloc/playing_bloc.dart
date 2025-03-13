import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/event_state/event_state.dart';
import 'package:music_player/helper/util.dart';
import 'package:music_player/models/models.dart';

class PlayingBloc extends Bloc<SongEvent, SongState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<String> _filterMp3 = [];

  PlayingBloc() : super(SongUninitialized()) {
    _init();
    on<SongPlay>(_onSongPlay);
    on<SongPlayPause>(_onSongPlayPause);
    on<SongNext>(_onSongNext);
    on<SongPrev>(_onSongPrev);
    on<SongShuffle>(_onSongShuffle);
    on<SongAutoMove>(_onSongAutoMove);
  }

  void _init() {
    _audioPlayer.currentIndexStream.listen((event) {
      if (event != null) {
        add(SongAutoMove(index: event));
      }
    });
  }

  Future<void> _onSongPlay(SongPlay event, Emitter<SongState> emit) async {
    try {
      final currentSong = event.song;
      final path = event.playlistPath;

      _filterMp3 = await Util.filterMp3(path);
      _filterMp3.insert(0, currentSong.path);
      _filterMp3 = _filterMp3.toSet().toList(); // Remove duplicate

      await _createPlaylist(_filterMp3);

      await _audioPlayer.stop();
      await _audioPlayer.play();

      emit(SongPlaying(song: currentSong));
    } catch (e, trace) {
      onError(e, trace);

      emit(SongError());
    }
  }

  Future<void> _onSongPlayPause(
      SongPlayPause event, Emitter<SongState> emit) async {
    try {
      if (state is SongPlaying) {
        await _audioPlayer.pause();
        emit(SongPausing(song: (state as SongPlaying).song));
      } else if (state is SongPausing) {
        await _audioPlayer.play();
        emit(SongPlaying(song: (state as SongPausing).song));
      }
    } catch (e, trace) {
      onError(e, trace);

      emit(SongError());
    }
  }

  Future<void> _onSongNext(SongNext event, Emitter<SongState> emit) async {
    if (_filterMp3.isNotEmpty && state is SongPlaying) {
      await _audioPlayer.seekToNext();
    }
  }

  Future<void> _onSongPrev(SongPrev event, Emitter<SongState> emit) async {
    if (_filterMp3.isNotEmpty && state is SongPlaying) {
      await _audioPlayer.seekToPrevious();
    }
  }

  Future<void> _onSongShuffle(
      SongShuffle event, Emitter<SongState> emit) async {
    if (_filterMp3.isNotEmpty && state is SongPlaying) {
      _filterMp3.shuffle(Random(DateTime.now().millisecond));
      await _createPlaylist(_filterMp3);
      await _audioPlayer.stop();
      await _audioPlayer.play();

      if (_audioPlayer.currentIndex == 0) {
        final mp3 = _filterMp3.first;
        final song = Song(name: Util.getNameSong(mp3), path: mp3);
        emit(SongPlaying(song: song));
      }
    }
  }

  Future<void> _onSongAutoMove(
      SongAutoMove event, Emitter<SongState> emit) async {
    if (_filterMp3.isNotEmpty && state is SongPlaying) {
      final song = Song(
        name: Util.getNameSong(_filterMp3[event.index]),
        path: _filterMp3[event.index],
      );

      emit(SongPlaying(song: song));
    }
  }

  Future<void> _createPlaylist(List<String> playlist) async {
    final audioSources =
        playlist.map((mp3) => AudioSource.uri(Uri.parse(mp3))).toList();
    await _audioPlayer
        .setAudioSource(ConcatenatingAudioSource(children: audioSources));
    await _audioPlayer.setLoopMode(LoopMode.all);
  }
}
