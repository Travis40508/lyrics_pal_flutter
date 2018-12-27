import 'package:flutter/material.dart';
import 'package:lyrics_pal/blocs/song_bloc_provider.dart';
import 'package:lyrics_pal/models/song.dart';
import 'package:lyrics_pal/widgets/song_tile.dart';

class AddPlaylist extends StatefulWidget {
  @override
  AddPlaylistState createState() {
    return new AddPlaylistState();
  }
}

class AddPlaylistState extends State<AddPlaylist> {

 @override
  void initState() {
    super.initState();
    bloc.resetLists();
    bloc.fetchAllSongs();
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
      body: buildScreenBody(),
      backgroundColor: Theme.of(context).primaryColor
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
          label: Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          onPressed: () => bloc.changeTheme(),
//          onPressed: () => onSavePressed(context),
        )
      ],
    );
  }

  Widget buildScreenBody() {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: TextField(
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            onChanged: (text) => bloc.onPlaylistTitleChanged(text),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.title, color: Colors.white,),
              hintText: "Ex. 'My Playlist'",
              hintStyle: TextStyle(color: Colors.white54),
              labelText: 'Title',
              labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)

            ),
          ),
        ),
        Text('Added Songs', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16.0),),
        showAddedSongs(),
        Padding(
          padding: const EdgeInsets.only(top: 80.0, bottom: 50.0),
          child: Divider(color: Colors.white, height: 1.0,),
        ),
        Text('Library', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16.0),),
        showLibrary()
      ],
    );
  }

  Widget showAddedSongs() {
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

  Widget showLibrary() {
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

  onSavePressed(context) {
    bloc.savePlaylistToDatabase(bloc.addedPlaylistSongs);
    Navigator.pop(context);
  }
}
