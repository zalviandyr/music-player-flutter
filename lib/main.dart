import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/bloc/bloc.dart';
import 'package:music_player/event_state/event_state.dart';
import 'package:music_player/pages/pages.dart';
import 'package:music_player/widgets/widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final PlayingBloc playingBloc = PlayingBloc();

  void _onPlayPause() {
    playingBloc.add(SongPlayPause());
  }

  void _onPrev() {
    playingBloc.add(SongPrev());
  }

  void _onNext() {
    playingBloc.add(SongNext());
  }

  void _onShuffle() {
    playingBloc.add(SongShuffle());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF140D36),
    ));

    return MultiBlocProvider(
      providers: [
        BlocProvider<PlaylistBloc>(create: (context) => PlaylistBloc()),
        BlocProvider<SongBloc>(create: (context) => SongBloc()),
        BlocProvider<PlayingBloc>(create: (context) => playingBloc),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Color(0xFF140D36),
          accentColor: Color(0xFF1D1449),
        ),
        routes: {
          '/': (context) => HomePage(),
          PlaylistPage.routeName: (context) => PlaylistPage(),
        },
        initialRoute: '/',
        builder: (context, child) {
          final Size screenSize = MediaQuery.of(context).size;

          return Stack(
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
              child!,
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
                      onPlayPause: _onPlayPause,
                      onPrev: _onPrev,
                      onNext: _onNext,
                      onShuffle: _onShuffle,
                      isPlaying: state is SongPlaying,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
