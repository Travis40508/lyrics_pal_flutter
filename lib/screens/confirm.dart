import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/abstract_song.dart';
import 'package:lyrics_pal/models/search_response.dart';
import '../blocs/song_bloc.dart';

class Confirm extends StatefulWidget {
  final AbstractSong song;

  Confirm({this.song});

  @override
  ConfirmState createState() {
    return new ConfirmState();
  }
}

class ConfirmState extends State<Confirm> {

  @override
  void initState() {
    super.initState();
    bloc.fetchLyrics(widget.song);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: Colors.black87,
      body: buildLyricsBody(),
    );
  }

  Widget buildAppBar(context) {
    return AppBar(
      backgroundColor: Colors.black87,
      title: Text(
        '${widget.song.getSongTitle()}',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      actions: <Widget>[
        buildActionButton(context),
      ],
    );
  }

  Widget buildActionButton(context) {
    return StreamBuilder(
      initialData: true,
      stream: bloc.canSaveStream,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        return RaisedButton.icon(
            color: Colors.transparent,
            onPressed: () => snapshot.data ? onSaveClicked(context) : onDeleteClicked(context),
            icon: Icon(
              snapshot.data ? Icons.save : Icons.delete,
              color: Colors.white,
            ),
            label: Text(
              snapshot.data ? 'Save' : 'Delete',
              style: TextStyle(color: Colors.white),
            ));
      },
    );

  }

  void onSaveClicked(context) async {
    bool success = await bloc.saveSongToLibrary(Track(artist: widget.song.getArtist(), name: widget.song.getSongTitle()), widget.song.getSongImage(), bloc.currentLyrics);

    if(success) {
      Navigator.pop(context);
    } else {
      print("Failed!");
    }
  }

  void onDeleteClicked(context) async {
    print("To be deleted");
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
      child: Hero(
        tag: '${widget.song.getSongTitle()} - ${widget.song.getArtist()}',
        child: Image.network(widget.song.getSongImage()),
      ),
    );
  }

  Widget getLyricsBody() {
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
