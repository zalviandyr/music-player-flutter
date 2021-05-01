import 'package:equatable/equatable.dart';

abstract class PlaylistEvent extends Equatable {
  PlaylistEvent();
}

class PlaylistRetrieve extends PlaylistEvent {
  @override
  List<Object> get props => [];
}

class PlaylistSave extends PlaylistEvent {
  final String dirPath;
  final List<String> pathMp3;

  PlaylistSave({required this.dirPath, required this.pathMp3});

  @override
  List<Object> get props => [dirPath, pathMp3];
}
