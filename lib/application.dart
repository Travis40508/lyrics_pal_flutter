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
            primaryColor: snapshot.hasData && snapshot.data == true ? Colors.white : Colors.black,
            backgroundColor: snapshot.hasData && snapshot.data == true ? Colors.white : Colors.black,
            scaffoldBackgroundColor: snapshot.hasData && snapshot.data == true ? Colors.grey[100] : Colors.grey[900],
            accentColor: snapshot.hasData && snapshot.data == true ? Colors.black : Colors.white,
            iconTheme: IconThemeData(color: snapshot.hasData && snapshot.data == true ? Colors.black : Colors.white,),
            fontFamily: 'OpenSans',
            textTheme: getTextTheme(snapshot.hasData && snapshot.data == true),
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

  TextTheme getTextTheme(bool isLightTheme) {
    return TextTheme(
      headline: TextStyle(color: isLightTheme ? Colors.black : Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0),
      //Default Lyrics
      body1: TextStyle(color: isLightTheme ? Colors.black : Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),
      //Default Text
      title: TextStyle(color: isLightTheme ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
      button: TextStyle(color: isLightTheme ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
      //No bold
      subtitle: TextStyle(color: isLightTheme ? Colors.black : Colors.white),
    );
  }
}
