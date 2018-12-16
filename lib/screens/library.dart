import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/song.dart';
import 'package:lyrics_pal/screens/confirm.dart';
import 'package:lyrics_pal/widgets/song_tile.dart';
import '../blocs/song_bloc_provider.dart';

class Library extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = SongBlocProvider.of(context);
    bloc.fetchAllSongs();

    return Scaffold(
      backgroundColor: Colors.black87,
      floatingActionButton: buildFloatingActionButton(context),
      body: buildLibrary(bloc),
    );
  }

  Widget buildFloatingActionButton(context) {
    return FloatingActionButton(
      mini: true,
      child: IconButton(icon: Icon(Icons.add, color: Colors.black87,), onPressed: () => Navigator.pushNamed(context, '/search')),
    );
  }

  Widget buildLibrary(SongBloc bloc) {
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
