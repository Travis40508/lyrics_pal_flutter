import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/playlist.dart';
import 'package:lyrics_pal/screens/playlist.dart';
import 'package:lyrics_pal/widgets/play_list_tile.dart';
import '../blocs/song_bloc.dart';

class Playlists extends StatefulWidget {

  @override
  PlaylistsState createState() {
    return new PlaylistsState();
  }
}

class PlaylistsState extends State<Playlists> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //Needs to be called every time the widget tree is built in case the data has changed.
    bloc.fetchAllPlaylists();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black87,
      body: showPlayLists(),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  Widget buildFloatingActionButton(context) {
    return FloatingActionButton(
      child: Icon(Icons.add, color: Colors.black87,),
      mini: true,
      onPressed: () => Navigator.pushNamed(context, '/add_playlist'),
    );
  }

  Widget showPlayLists() {
    return StreamBuilder(
      stream: bloc.allPlayListsStream,
      builder: (context, AsyncSnapshot<List<Playlist>> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return PlayListTile(
              title: snapshot.data[index].title,
              index: index,
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                  builder: (context) => PlaylistScreen(playlist: snapshot.data[index],
                  )
              )
              ),
              onLongPressed: () => showDeleteDialog(snapshot.data[index]),
            );
          },
        );
      },
    );
  }

  showDeleteDialog(Playlist playlist) {
    var alert = AlertDialog(
      title: Text('Delete?'),
      content: Text('Are you sure you wish to delete ${playlist.title}?'),
      actions: <Widget>[
        FlatButton(
          onPressed: () => onDeleteConfirmed(playlist),
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

  void onDeleteConfirmed(Playlist playlist) {
    Navigator.pop(context);
    bloc.deletePlaylist(playlist);
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('${playlist.title} has been deleted!')));
  }
}
