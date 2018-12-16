import 'package:flutter/material.dart';
import 'package:lyrics_pal/blocs/song_bloc_provider.dart';
import 'package:lyrics_pal/models/song.dart';
import 'package:lyrics_pal/widgets/song_tile.dart';

class AddPlaylist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final bloc = SongBlocProvider.of(context);
    bloc.fetchAllSongs();

    return Scaffold(
      appBar: buildAppBar(context),
      body: buildScreenBody(bloc),
      backgroundColor: Colors.black87,
    );
  }

  Widget buildAppBar(context) {
    return AppBar(
      backgroundColor: Colors.black87,
      centerTitle: true,
      title: Text('Create Playlist', style: TextStyle(color: Colors.white),),
      actions: <Widget>[
        RaisedButton.icon(
          icon: Icon(Icons.save, color: Colors.white,),
          color: Colors.transparent,
          label: Text('Save', style: TextStyle(color: Colors.white),),
          onPressed: () => print('To be saved'),
        )
      ],
    );
  }

  Widget buildScreenBody(bloc) {
    return ListView(
      children: <Widget>[
        Text('Added Songs', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16.0),),
        showAddedSongs(bloc),
        Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Divider(color: Colors.white, height: 1.0,),
        ),
        Text('Library', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16.0),),
        showLibrary(bloc)
      ],
    );
  }

  Widget showAddedSongs(SongBloc bloc) {
    return StreamBuilder(
      stream: bloc.playListStream,
      builder: (context, AsyncSnapshot<List<Song>> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return SongTile(
              song: snapshot.data[index],
              onPressed: () => bloc.playListSongPressedInPlaylistCreation(snapshot.data[index]),
            );
          },
        );
      },
    );
  }

  Widget showLibrary(SongBloc bloc) {
    return StreamBuilder(
      stream: bloc.libraryStream,
      builder: (context, AsyncSnapshot<List<Song>> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return SongTile(song: snapshot.data[index], onPressed: () => bloc.librarySongPressedInPlaylistCreation(snapshot.data[index]),);
          },
        );
      },
    );
  }
}
