import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/playlist.dart';
import 'package:lyrics_pal/models/song.dart';
import 'package:lyrics_pal/screens/playlist.dart';
import 'package:lyrics_pal/screens/reorder_screen.dart';
import 'package:lyrics_pal/widgets/song_tile.dart';
import '../blocs/song_bloc.dart';

class EditAddAndRemoveFromPlaylist extends StatefulWidget {

  final Playlist playlist;

  EditAddAndRemoveFromPlaylist({this.playlist});

  @override
  _EditAddAndRemoveFromPlaylistState createState() => _EditAddAndRemoveFromPlaylistState();

}

class _EditAddAndRemoveFromPlaylistState extends State<EditAddAndRemoveFromPlaylist>  {

  final TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.playlist.title;
    bloc.fetchNonPlayListSongs(widget.playlist);
    _listenForEvents();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor
    );
  }

  Widget buildAppBar() {
    return AppBar(
      leading: getBackButton(),
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).backgroundColor,
      centerTitle: true,
      title: Text(
          'Add/Remove Songs',
        style: Theme.of(context).textTheme.title,
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: InkWell(
            onTap: () => nextPressed(),
            child: Center(
              child: Text(
                'Next',
                style: Theme.of(context).textTheme.button,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getBackButton() {
    if (Platform.isAndroid) {
      return InkWell(
          child: Icon(Icons.home, size: 35.0,),
          onTap: () => Navigator.popUntil(context, ModalRoute.withName(bloc.isFirstLaunchValue ? '/home' : '/')));
    }
  }

  void nextPressed() {
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => ReorderScreen(playlist: bloc.playListSongs, playlistTitle: _controller.text, playListId: widget.playlist.id, onSavePressed: () => _onSavePressed(),)));
  }

  void _onSavePressed()  {
    bloc.savePressedOnReorderScreen(bloc.playListSongs, _controller.text, widget.playlist.id);
  }

  Widget buildBody() {
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
                prefixIcon: Icon(Icons.title, color: Theme.of(context).accentColor,),
                hintText: "Ex. 'My Playlist'",
                hintStyle: Theme.of(context).textTheme.title,
                labelText: 'Title',
                labelStyle: Theme.of(context).textTheme.title

            ),
          ),
        ),
        Text('Playlist Songs', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline),
        showPlayListSongs(),
        Padding(
          padding: const EdgeInsets.only(top: 80.0, bottom: 50.0),
          child: Divider(color: Theme.of(context).accentColor, height: 1.0,),
        ),
        Text('Library', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline),
        showNonPlayListSongs()
      ],
    );

  }

  Widget showPlayListSongs() {
    return StreamBuilder(
      stream: bloc.currentPlayListSongs,
      builder: (context, AsyncSnapshot<List<Song>> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return SongTile(song: snapshot.data[index], onPressed: () => bloc.playListSongPressedInPlaylistEditing(snapshot.data[index]),);
          },
        );
      },
    );
  }


  Widget showNonPlayListSongs() {
    return StreamBuilder(
      stream: bloc.nonPlayListSongs,
      builder: (context, AsyncSnapshot<List<Song>> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }


        return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return SongTile(song: snapshot.data[index], onPressed: () => bloc.librarySongPressedInPlaylistEditing(snapshot.data[index]),);
          },
        );

      },
    );
  }

  void _listenForEvents() {
    bloc.onPlayListUpdatedStream.listen((playlist) => {
        Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PlaylistScreen(playlist: playlist,)),
        ModalRoute.withName(bloc.isFirstLaunchValue ? '/home' : '/')) : print('Error updating playlist')
    });
  }

}