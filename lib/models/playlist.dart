import 'dart:convert';

import 'package:equatable/equatable.dart';

class Playlist extends Equatable {
  final String name;
  final String path;
  final int countMusic;

  Playlist({
    required this.name,
    required this.path,
    required this.countMusic,
  });

  static String sharedPref() => 'playlist';

  factory Playlist.fromJson(dynamic json) {
    var data = jsonDecode(json);
    return Playlist(
        name: data['name'],
        path: data['path'],
        countMusic: data['count_music']);
  }

  static List<Playlist> fromJsonToList(dynamic json) {
    List<Playlist> playlist = [];

    if (json != null) {
      for (var data in json) {
        data = jsonDecode(data);
        playlist.add(
          Playlist(
              name: data['name'],
              path: data['path'],
              countMusic: data['count_music']),
        );
      }
    }

    return playlist;
  }

  static List<String> fromListToListString(List<Playlist> playlist) {
    List<String> strings = [];

    for (Playlist data in playlist) {
      strings.add(data.toString());
    }

    return strings;
  }

  @override
  String toString() {
    return jsonEncode({
      'name': this.name,
      'path': this.path,
      'count_music': this.countMusic,
    });
  }

  @override
  List<Object?> get props => [path];
}
