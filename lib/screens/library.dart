import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/song.dart';
import 'package:lyrics_pal/screens/confirm.dart';
import 'package:lyrics_pal/widgets/song_tile.dart';
import '../blocs/song_bloc.dart';

class Library extends StatefulWidget {
  @override
  LibraryState createState() {
    return new LibraryState();
  }

}

class LibraryState extends State<Library> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //This should be called every time this widget rebuilds, as the data could have changed. So initState isn't sufficient
    bloc.fetchAllSongs();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black87,
      floatingActionButton: buildFloatingActionButton(context),
      body: buildLibrary(),
    );
  }

  Widget buildFloatingActionButton(context) {
    return FloatingActionButton(
      mini: true,
      child: IconButton(icon: Icon(Icons.add, color: Colors.black87,), onPressed: () => Navigator.pushNamed(context, '/lyrics_options')),
    );
  }

  Widget buildLibrary() {
    return StreamBuilder(
      stream: bloc.libraryStream,
      builder: (context, AsyncSnapshot<List<Song>>snapshot) {
        if(snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return SongTile(
                song: snapshot.data[index],
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Confirm(
                        song: snapshot.data[index],
                      ))),
                onLongPressed: () => showConfirmationDialog(snapshot.data[index]),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  void showConfirmationDialog(Song song) {
    var alert = AlertDialog(
      title: Text('Delete?'),
      content: Text('Are you sure you wish to delete this song from your library?'),
      actions: <Widget>[
        FlatButton(
          onPressed: () => onDeleteConfirmed(song),
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

  void onDeleteConfirmed(Song song) {
    Navigator.pop(context);
    bloc.deleteSongFromDatabaseFromLibraryScreen(song.getArtist(), song.getSongTitle());
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('${song.getSongTitle()} has been deleted!')));
  }
}
