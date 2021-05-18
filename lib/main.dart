import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/bloc/bloc.dart';
import 'package:music_player/config/pallette.dart';
import 'package:music_player/event_state/event_state.dart';
import 'package:music_player/pages/pages.dart';
import 'package:music_player/widgets/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Pallette.statusBarColor,
    ));

    return MultiBlocProvider(
      providers: [
        BlocProvider<PlaylistBloc>(create: (context) => PlaylistBloc()),
        BlocProvider<SongBloc>(create: (context) => SongBloc()),
        BlocProvider<PlayingBloc>(create: (context) => PlayingBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Pallette.primaryColor,
          accentColor: Pallette.accentColor,
        ),
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  final GlobalKey _navigatorKey = GlobalKey<NavigatorState>();

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
    final PlayingBloc playingBloc = BlocProvider.of<PlayingBloc>(context);

    return Scaffold(
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
          Navigator(
              key: _navigatorKey,
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  settings: settings,
                  builder: (context) {
                    return HomePage();
                  },
                );
              }),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BlocBuilder<PlayingBloc, SongState>(
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
          ),
        ],
      ),
    );
  }
}
