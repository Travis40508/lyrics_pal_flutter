import 'package:cached_network_image/cached_network_image.dart';
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    bloc.checkIfAdded(widget.song.getArtist(), widget.song.getSongTitle());
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
      key: _scaffoldKey,
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
      initialData: false,
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
    var alert = AlertDialog(
      title: Text('Save?'),
      content: Text('Are you sure you wish to save this song from your library?'),
      actions: <Widget>[
        FlatButton(
          onPressed: onSaveConfirmed,
          child: Text('Ok', style: TextStyle(color: Colors.black87),),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: Colors.black87),),
        )
      ],
    );
    showDialog(context: context, child: alert, barrierDismissible: true);

  }

  void onDeleteClicked(context) async {
    var alert = AlertDialog(
      title: Text('Delete?'),
      content: Text('Are you sure you wish to delete this song from your library?'),
      actions: <Widget>[
        FlatButton(
          onPressed: onDeleteConfirmed,
          child: Text('Ok', style: TextStyle(color: Colors.black87),),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: Colors.black87),),
        )
      ],
    );
    showDialog(context: context, child: alert, barrierDismissible: true);
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Hero(
          tag: '${widget.song.getSongTitle()} - ${widget.song.getArtist()}',
          child: Image(
              width: 250.0,
              height: 250.0,
              image: CachedNetworkImageProvider(widget.song.getSongImage()),
          ),
        ),
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

  void onDeleteConfirmed() {
    Navigator.pop(context);
    bloc.deleteSongFromDatabaseFromConfirmScreen(widget.song.getArtist(), widget.song.getSongTitle());
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('${widget.song.getSongTitle()} has been deleted!')));
  }

  void onSaveConfirmed() async {
    Navigator.pop(context);
    bool success = await bloc.saveSongToLibrary(Track(artist: widget.song.getArtist(), name: widget.song.getSongTitle()), widget.song.getSongImage(), bloc.currentLyrics);

    if (success) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('${widget.song.getSongTitle()} has been saved!')));
    }
  }
}
