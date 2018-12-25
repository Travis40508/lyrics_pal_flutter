import 'package:flutter/material.dart';
import 'package:lyrics_pal/screens/add_custom_lyrics.dart';
import 'package:lyrics_pal/screens/add_playlist.dart';
import 'package:lyrics_pal/screens/lyrics_options.dart';
import 'package:lyrics_pal/screens/search.dart';
import 'package:lyrics_pal/screens/confirm.dart';
import 'package:lyrics_pal/screens/settings.dart';
import 'screens/home.dart';
import 'blocs/song_bloc_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
      theme: ThemeData(accentColor: Colors.white, fontFamily: 'OpenSans'),
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
    ));
  }
}
