import 'package:flutter/material.dart';
import 'package:lyrics_pal/blocs/song_bloc_provider.dart';
import 'package:lyrics_pal/models/song.dart';
import 'package:lyrics_pal/screens/playlist.dart';
import 'package:lyrics_pal/screens/reorder_screen.dart';
import 'package:lyrics_pal/widgets/song_tile.dart';

class AddPlaylist extends StatefulWidget {
  @override
  AddPlaylistState createState() {
    return new AddPlaylistState();
  }

}

class AddPlaylistState extends State<AddPlaylist>  with AddPlaylistCallbackMixin {

  final TextEditingController _controller = new TextEditingController();

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
          label: Text('Next', style: Theme.of(context).textTheme.title,),
          onPressed: () => _nextPressed(),
        )
      ],
    );
  }

 void _nextPressed() {
   Navigator.push(context,
       MaterialPageRoute(builder: (context) => ReorderScreen(playlist: bloc.addedPlaylistSongs, playlistTitle: _controller.text,  onSavePressed: () => _onSavePressed(),)));
 }

 void _onSavePressed() {
   bloc.savePlaylistToDatabase(bloc.addedPlaylistSongs, this);
 }

  Widget buildScreenBody() {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: TextField(
            controller: _controller,
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

  @override
  onPlaylistSaved() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PlaylistScreen(playlist: bloc.allPlayListsValue[bloc.allPlayListsValue.length - 1],)),
        ModalRoute.withName(bloc.isFirstLaunchValue ? '/home' : '/'));
  }
}

abstract class AddPlaylistCallbackMixin {
  onPlaylistSaved();
}