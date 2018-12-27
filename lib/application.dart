import 'package:flutter/material.dart';
import 'package:lyrics_pal/screens/add_custom_lyrics.dart';
import 'package:lyrics_pal/screens/add_playlist.dart';
import 'package:lyrics_pal/screens/lyrics_options.dart';
import 'package:lyrics_pal/screens/search.dart';
import 'package:lyrics_pal/screens/confirm.dart';
import 'package:lyrics_pal/screens/settings.dart';
import 'screens/home.dart';
import 'blocs/song_bloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    bloc.fetchTheme();

    return StreamBuilder(
      stream: bloc.theme,
      builder: (context, snapshot) {
        return MaterialApp(
          theme: ThemeData(
            primaryColor: snapshot.hasData && snapshot.data == 'Light' ? Colors.white : Colors.grey[900],
            accentColor: snapshot.hasData && snapshot.data == 'Light' ? Colors.black : Colors.white,
            fontFamily: 'OpenSans',
            iconTheme: IconThemeData(color: snapshot.hasData && snapshot.data == 'Light' ? Colors.black : Colors.white,),
            textTheme: getTextTheme(context),
          ),
          debugShowCheckedModeBanner: false,
          title: "Lyrics Pal",
          home: Home(),
          initialRoute: '/',
          routes: {
            '/search': (context) => Search(),
            '/confirm': (context) => Confirm(),
            '/add_playlist': (context) => AddPlaylist(),
            '/lyrics_options': (context) => LyricsOptions(),
            '/custom_lyrics': (context) => AddCustomLyrics(),
            '/settings': (context) => SettingsScreen(),
          },
        );
      }
    );

  }

  TextTheme getTextTheme(context) {
    return TextTheme(
      headline: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
      title: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
      subtitle: TextStyle(color: Theme.of(context).accentColor),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    );
  }
}
