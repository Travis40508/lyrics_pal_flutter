import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/abstract_song.dart';
import 'package:lyrics_pal/models/search_response.dart';
import '../blocs/song_bloc_provider.dart';

class Confirm extends StatelessWidget {
  final AbstractSong song;

  Confirm({this.song});

  @override
  Widget build(BuildContext context) {
    final bloc = SongBlocProvider.of(context);
    bloc.fetchLyrics(song);

    return Scaffold(
      appBar: buildAppBar(bloc),
      backgroundColor: Colors.black54,
      body: buildLyricsBody(bloc),
    );
  }

  Widget buildAppBar(bloc) {
    return AppBar(
      backgroundColor: Colors.black87,
      title: Text(
        '${song.getSongTitle()}',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      actions: <Widget>[
        buildActionButton(bloc),
      ],
    );
  }

  Widget buildActionButton(SongBloc bloc) {
    return RaisedButton.icon(
        color: Colors.transparent,
        onPressed: () => bloc.saveSongToLibrary(Track(artist: song.getArtist(), name: song.getSongTitle()), song.getSongImage(), bloc.currentLyrics),
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: Text(
          'Save',
          style: TextStyle(color: Colors.white),
        ));
  }

  Widget buildLyricsBody(SongBloc bloc) {
    return ListView(
      children: <Widget>[
        getHeader(),
        getLyricsBody(bloc),
      ],
    );
  }

  Widget getHeader() {
    return Container(
      height: 250,
      width: 250,
      child: Hero(
        tag: '${song.getSongTitle()} - ${song.getArtist()}',
        child: Image.network(song.getSongImage()),
      ),
    );
  }

  Widget getLyricsBody(bloc) {
    return StreamBuilder(
        stream: bloc.lyricsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
              "Error fetching lyrics. Please try again",
              style: TextStyle(color: Colors.white),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                '${snapshot.data}',
                style: TextStyle(
                    color: Colors.white, fontSize: 24.0, fontFamily: 'roboto'),
                textAlign: TextAlign.center,
              ),
            );
          }
        });
  }
}
