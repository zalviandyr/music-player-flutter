import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player/arguments/arguments.dart';
import 'package:music_player/bloc/bloc.dart';
import 'package:music_player/event_state/event_state.dart';
import 'package:music_player/models/models.dart';
import 'package:music_player/widgets/song_item.dart';
import 'package:music_player/widgets/widgets.dart';

class PlaylistPage extends StatelessWidget {
  static String routeName = '/playlist';

  void _songAction(
      Song song, String playlistPath, PlayingBloc playingBloc) async {
    playingBloc.add(SongPlay(playlistPath: playlistPath, song: song));
  }

  void _onPlayPause(PlayingBloc playingBloc) {
    playingBloc.add(SongPlayPause());
  }

  void _onPrev(PlayingBloc playingBloc) {
    playingBloc.add(SongPrev());
  }

  void _onNext(PlayingBloc playingBloc) {
    playingBloc.add(SongNext());
  }

  void _onShuffle(PlayingBloc playingBloc) {
    playingBloc.add(SongShuffle());
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final PlaylistArguments args =
        ModalRoute.of(context)!.settings.arguments as PlaylistArguments;
    final Playlist playlist = args.playlist;
    final SongBloc songBloc = BlocProvider.of<SongBloc>(context);
    final PlayingBloc playingBloc = BlocProvider.of<PlayingBloc>(context);

    // retrieve song
    songBloc.add(SongRetrieve(playlistPath: playlist.path));

    return Scaffold(
      appBar: CustomAppBar(label: 'Playlist'),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: screenSize.height * 0.2,
                width: double.infinity,
                color: Theme.of(context).primaryColor,
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).accentColor,
                ),
              )
            ],
          ),
          CustomScrollView(
            slivers: [
              _buildHeader(playlist),
              _buildListSong(playingBloc, playlist.path, _songAction),
            ],
          ),
          BlocBuilder<PlayingBloc, SongState>(
            builder: (context, state) {
              return Playing(
                title: state is SongPlaying
                    ? state.song.name
                    : state is SongPausing
                        ? state.song.name
                        : 'No song selected',
                onPlayPause: () => _onPlayPause(playingBloc),
                onPrev: () => _onPrev(playingBloc),
                onNext: () => _onNext(playingBloc),
                onShuffle: () => _onShuffle(playingBloc),
                isPlaying: state is SongPlaying,
              );
            },
          ),
        ],
      ),
    );
  }
}

SliverToBoxAdapter _buildHeader(Playlist playlist) => SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              playlist.name,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.7,
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.music,
                  size: 20.0,
                ),
                const SizedBox(width: 15.0),
                Text(
                  '${playlist.countMusic} Song Playlist',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );

SliverPadding _buildListSong(
  PlayingBloc playingBloc,
  String playlistPath,
  Function(Song song, String playlistPath, PlayingBloc playingBloc) onTap,
) =>
    SliverPadding(
      padding: const EdgeInsets.only(
          top: 20.0, left: 10.0, right: 10.0, bottom: 120),
      sliver: BlocBuilder<SongBloc, SongState>(
        builder: (context, state) {
          if (state is SongRetrieveSuccess) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  Song song = state.songs[index];

                  return SongItem(
                      title: song.name,
                      onTap: () => onTap(song, playlistPath, playingBloc));
                },
                childCount: state.songs.length,
              ),
            );
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return SizedBox.shrink();
              },
              childCount: 0,
            ),
          );
        },
      ),
    );
