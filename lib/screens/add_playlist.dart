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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor
    );
  }

  Widget buildAppBar(context) {
    return AppBar(
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).backgroundColor,
      centerTitle: true,
      title: Text('Create Playlist', style: Theme.of(context).textTheme.title,),
      actions: <Widget>[
        RaisedButton.icon(
          icon: Icon(Icons.save, color: Theme.of(context).iconTheme.color,),
          color: Theme.of(context).primaryColor,
          label: Text('Save', style: Theme.of(context).textTheme.title,),
          onPressed: () => onSavePressed(context),
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
            style: Theme.of(context).textTheme.title,
            cursorColor: Theme.of(context).accentColor,
            onChanged: (text) => bloc.onPlaylistTitleChanged(text),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.title, color: Theme.of(context).iconTheme.color,),
              hintText: "Ex. 'My Playlist'",
              hintStyle: Theme.of(context).textTheme.title,
              labelText: 'Title',
              labelStyle: Theme.of(context).textTheme.title

            ),
          ),
        ),
        Text('Added Songs', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline),
        showAddedSongs(),
        Padding(
          padding: const EdgeInsets.only(top: 80.0, bottom: 50.0),
          child: Divider(color: Theme.of(context).accentColor, height: 1.0,),
        ),
        Text('Library', textAlign: TextAlign.center, style: Theme.of(context).textTheme.title,),
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
