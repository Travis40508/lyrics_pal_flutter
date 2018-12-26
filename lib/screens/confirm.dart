import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/abstract_song.dart';
import 'package:lyrics_pal/models/search_response.dart';
import 'package:lyrics_pal/screens/edit_lyrics.dart';
import '../blocs/song_bloc.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

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
    bloc.fetchYoutubeVideoId(
        widget.song.getArtist(), widget.song.getSongTitle());
  }

  @override
  void dispose() {
    bloc.resetYoutubeId();
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    bloc.fetchLyrics(widget.song);

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
        buildActionButton(),
        buildEditWidget(),
      ],
    );
  }

  Widget buildActionButton() {
    return StreamBuilder(
      initialData: false,
      stream: bloc.canSaveStream,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        return Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: InkWell(
              onTap: () => snapshot.data
                  ? onSaveClicked(context)
                  : onDeleteClicked(context),
              child: Center(
                child: Text(
                  snapshot.data ? 'Save' : 'Delete',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),),
        );
      },
    );
  }

  Widget buildEditWidget() {
    return StreamBuilder(
      initialData: false,
      stream: bloc.canSaveStream,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data) {
          return Container();
        }

        return Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: InkWell(
              onTap: () => onEditTapped(),
              child: Center(
                child: Text(
                'Edit',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              ),
        ),
        );
      }
    );
  }

  void onEditTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditLyrics(song: widget.song)));
  }

  void onSaveClicked(context) async {
    var alert = AlertDialog(
      title: Text('Save?'),
      content:
          Text('Are you sure you wish to save this song from your library?'),
      actions: <Widget>[
        FlatButton(
          onPressed: onSaveConfirmed,
          child: Text(
            'Ok',
            style: TextStyle(color: Colors.black87),
          ),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.black87),
          ),
        )
      ],
    );
    showDialog(context: context, child: alert, barrierDismissible: true);
  }

  void onDeleteClicked(context) async {
    var alert = AlertDialog(
      title: Text('Delete?'),
      content:
          Text('Are you sure you wish to delete this song from your library?'),
      actions: <Widget>[
        FlatButton(
          onPressed: onDeleteConfirmed,
          child: Text(
            'Ok',
            style: TextStyle(color: Colors.black87),
          ),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.black87),
          ),
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
      child: Column(
        children: <Widget>[
          Hero(
            tag: '${widget.song.getSongTitle()} - ${widget.song.getArtist()}',
            child: Image(
              width: 250.0,
              height: 250.0,
              image: CachedNetworkImageProvider(widget.song.getSongImage()),
            ),
          ),
          Center(
            child: StreamBuilder(
              stream: bloc.youtubeVideoId,
              builder: (context, AsyncSnapshot<String> snapshot) {
                return InkWell(
                  onTap: snapshot.hasData
                      ? () => launchYoutubeScreen(snapshot.data)
                      : null,
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.ondemand_video,
                        color:
                            snapshot.hasData ? Colors.redAccent : Colors.grey,
                      ),
                      Text(
                        snapshot.hasData
                            ? 'Practice Song (beta)'
                            : 'Video not Available',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: snapshot.hasData
                                ? Colors.redAccent
                                : Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
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
            return StreamBuilder(
              stream: bloc.fontSize,
              builder: (context, fontSnapshot) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(
                    '${snapshot.data}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            fontSnapshot.hasData ? fontSnapshot.data : 24.0,
                        fontFamily: 'roboto'),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            );
          }
        });
  }

  void onDeleteConfirmed() {
    Navigator.pop(context);
    bloc.deleteSongFromDatabaseFromConfirmScreen(
        widget.song.getArtist(), widget.song.getSongTitle());
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('${widget.song.getSongTitle()} has been deleted!')));
  }

  void onSaveConfirmed() async {
    bool success = await bloc.saveSongToLibrary(
        Track(
            artist: widget.song.getArtist(), name: widget.song.getSongTitle()),
        widget.song.getSongImage(),
        bloc.currentLyrics);

    if (success) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('${widget.song.getSongTitle()} has been saved!')));
      Navigator.pop(context);
    } else {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Error - Please try again.')));
    }
  }

  launchYoutubeScreen(String youtubeId) {
    FlutterYoutube.playYoutubeVideoById(
        apiKey: "AIzaSyCbS_9gcgFNop0nSaV9bBddviOXUUQShAc",
        videoId: youtubeId,
        autoPlay: true, //default falase
        fullScreen: false //default false
        );
  }
}
