import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/search_response.dart';
import '../blocs/song_bloc_provider.dart';

class Confirm extends StatelessWidget {
  final Track track;

  Confirm({this.track});

  @override
  Widget build(BuildContext context) {
    final bloc = SongBlocProvider.of(context);
    bloc.fetchLyrics(track.artist, track.name);

    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: Colors.black54,
      body: buildLyricsBody(bloc),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black87,
      title: Text(
        '${track.name}',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      actions: <Widget>[
        buildActionButton(),
      ],
    );
  }

  Widget buildActionButton() {
    return RaisedButton.icon(
        color: Colors.transparent,
        onPressed: () => print("FUCK"),
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
        tag: '${track.name} - ${track.artist}',
        child: Image.network(track.images[2].imageUrl),
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
