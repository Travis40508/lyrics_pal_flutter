import 'package:flutter/material.dart';
import 'package:lyrics_pal/screens/add_song.dart';
import 'screens/home.dart';
import 'blocs/song_bloc_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SongBlocProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Lyrics Pal",
        home: Home(),
        initialRoute: '/',
        routes: {
          '/search': (context) => AddSong()
        },
      ),
    );
  }
}
