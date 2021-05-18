import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/arguments/arguments.dart';
import 'package:music_player/bloc/bloc.dart';
import 'package:music_player/event_state/event_state.dart';
import 'package:music_player/helper/util.dart';
import 'package:music_player/models/models.dart';
import 'package:music_player/pages/pages.dart';
import 'package:music_player/widgets/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatelessWidget {
  void _playlistAction(BuildContext context, Playlist playlist) {
    Navigator.of(context).pushNamed(
      PlaylistPage.routeName,
      arguments: PlaylistArguments(playlist: playlist),
    );
  }

  void _openFileAction(BuildContext context, PlaylistBloc playlistBloc) async {
    String? path = await FilesystemPicker.open(
      context: context,
      rootDirectory: Directory('/storage/emulated/0/'),
      fsType: FilesystemType.folder,
      pickText: 'Choose folder contains .mp3',
      folderIconColor: Theme.of(context).accentColor,
      requestPermission: () async =>
          await Permission.storage.request().isGranted,
    );

    List<String> pathMp3 = [];
    if (path != null) {
      pathMp3 = await Util.filterMp3(path);

      if (pathMp3.isEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Folder not contains .mp3'),
            content: Text('Choose another folder'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Ok'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).accentColor),
                ),
              ),
            ],
          ),
        );
      } else {
        playlistBloc.add(PlaylistSave(dirPath: path, pathMp3: pathMp3));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final PlaylistBloc playlistBloc = BlocProvider.of<PlaylistBloc>(context);

    // retrieve playlist
    playlistBloc.add(PlaylistRetrieve());

    return Scaffold(
      appBar: CustomAppBar(label: 'Music Player'),
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: BlocBuilder<PlaylistBloc, PlaylistState>(
          builder: (context, state) {
            if (state is PlaylistRetrieveSuccess) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  Playlist playlist = state.listPlaylist[index];
                  return PlaylistItem(
                    playlist: playlist,
                    onTap: () => _playlistAction(context, playlist),
                  );
                },
                itemCount: state.listPlaylist.length,
              );
            }

            return SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: FloatingActionButton(
          onPressed: () => _openFileAction(context, playlistBloc),
          child: Icon(
            Icons.add,
            size: 30.0,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
