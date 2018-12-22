import 'package:flutter/material.dart';
import 'package:lyrics_pal/screens/add_playlist.dart';
import 'package:lyrics_pal/screens/search.dart';
import 'package:lyrics_pal/screens/confirm.dart';
import 'screens/home.dart';
import 'blocs/song_bloc_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
      theme: ThemeData(accentColor: Colors.white),
      debugShowCheckedModeBanner: false,
      title: "Lyrics Pal",
      home: Home(),
      initialRoute: '/',
      routes: {
        '/search': (context) => Search(),
        '/confirm': (context) => Confirm(),
        '/add_playlist': (context) => AddPlaylist(),
      },
    ));
  }
}
