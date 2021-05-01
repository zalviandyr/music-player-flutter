import 'package:equatable/equatable.dart';
import 'package:music_player/models/models.dart';

abstract class SongState extends Equatable {
  SongState();
}

class SongUninitialized extends SongState {
  @override
  List<Object?> get props => [];
}

class SongError extends SongState {
  @override
  List<Object?> get props => [];

  @override
  String toString() {
    return 'Ups... ada yang salah nih';
  }
}

class SongRetrieveSuccess extends SongState {
  final List<Song> songs;

  SongRetrieveSuccess({required this.songs});

  @override
  List<Object?> get props => [songs];
}

class SongPlaying extends SongState {
  final Song song;

  SongPlaying({required this.song});

  @override
  List<Object?> get props => [song];
}

class SongPausing extends SongState {
  final Song song;

  SongPausing({required this.song});

  @override
  List<Object?> get props => [song];
}
