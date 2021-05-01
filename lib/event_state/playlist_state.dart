import 'package:equatable/equatable.dart';
import 'package:music_player/models/playlist.dart';

abstract class PlaylistState extends Equatable {
  PlaylistState();
}

class PlaylistUninitialized extends PlaylistState {
  @override
  List<Object> get props => [];
}

class PlaylistSaveSuccess extends PlaylistState {
  @override
  List<Object> get props => [];
}

class PlaylistRetrieveSuccess extends PlaylistState {
  final List<Playlist> listPlaylist;

  PlaylistRetrieveSuccess({required this.listPlaylist});

  @override
  List<Object> get props => [listPlaylist];
}

class PlaylistError extends PlaylistState {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'Ups... ada yang salah nih';
  }
}
