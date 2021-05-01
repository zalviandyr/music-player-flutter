import 'package:equatable/equatable.dart';
import 'package:music_player/models/models.dart';

abstract class SongEvent extends Equatable {
  SongEvent();
}

class SongRetrieve extends SongEvent {
  final String playlistPath;

  SongRetrieve({required this.playlistPath});

  @override
  List<Object?> get props => [playlistPath];
}

class SongPlay extends SongEvent {
  final String playlistPath;
  final Song song;

  SongPlay({required this.playlistPath, required this.song});

  @override
  List<Object?> get props => [playlistPath, song];
}

class SongPlayPause extends SongEvent {
  @override
  List<Object?> get props => [];
}

class SongPrev extends SongEvent {
  @override
  List<Object?> get props => [];
}

class SongNext extends SongEvent {
  @override
  List<Object?> get props => [];
}

class SongShuffle extends SongEvent {
  @override
  List<Object?> get props => [];
}

class SongAutoMove extends SongEvent {
  final int index;

  SongAutoMove({required this.index});
  @override
  List<Object?> get props => [];
}
