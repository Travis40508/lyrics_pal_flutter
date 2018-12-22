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
      backgroundColor: Colors.black87,
      floatingActionButton: buildFloatingActionButton(context),
      body: buildLibrary(),
    );
  }

  Widget buildFloatingActionButton(context) {
    return FloatingActionButton(
      mini: true,
      child: IconButton(icon: Icon(Icons.add, color: Colors.black87,), onPressed: () => Navigator.pushNamed(context, '/search')),
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
              return SongTile(song: snapshot.data[index], onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Confirm(
                        song: snapshot.data[index],
                      ))),);
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

}
