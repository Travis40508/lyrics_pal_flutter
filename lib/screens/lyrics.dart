import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/song.dart';

class LyricsScreen extends StatelessWidget {

  final Song song;

  LyricsScreen({this.song});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildLyricsBody(),
      backgroundColor: Colors.black87,
    );
  }

  Widget buildLyricsBody() {
    return ListView(
      children: <Widget>[
        getHeader(),
        getLyricsBody(),
      ],
    );
  }

  Widget getHeader() {
    return Container(
      height: 250,
      width: 250,
      child: Image.network(song.getSongImage()),
    );
  }

  Widget getLyricsBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Text(
        song.getSongLyrics(),
        style: TextStyle(
            color: Colors.white, fontSize: 24.0, fontFamily: 'roboto'),
        textAlign: TextAlign.center,
      ),
    );
  }

}
