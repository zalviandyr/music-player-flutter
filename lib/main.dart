import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/bloc/bloc.dart';
import 'package:music_player/pages/pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF140D36),
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
          primaryColor: Color(0xFF140D36),
          accentColor: Color(0xFF1D1449),
        ),
        routes: {
          '/': (context) => HomePage(),
          PlaylistPage.routeName: (context) => PlaylistPage(),
        },
        initialRoute: '/',
      ),
    );
  }
}
