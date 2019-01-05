import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/playlist.dart';
import 'package:lyrics_pal/models/song.dart';
import 'package:lyrics_pal/screens/edit_add_and_remove.dart';
import 'package:lyrics_pal/screens/lyrics.dart';
import '../blocs/song_bloc.dart';

class PlaylistScreen extends StatefulWidget {
  final Playlist playlist;

  PlaylistScreen({this.playlist});

  @override
  PlaylistScreenState createState() {
    return new PlaylistScreenState();
  }
}

class PlaylistScreenState extends State<PlaylistScreen> {
  @override
  void initState() {
    super.initState();
    bloc.fetchAllPlaylistSongs(widget.playlist);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: bloc.currentPlayListSongs,
      builder: (context, AsyncSnapshot<List<Song>> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        List<Widget> tabs = List();
        for (Song song in snapshot.data) {
          if (song != null) {
            tabs.add(Tab(
              text: song.songTitle.length < 20 ? song.songTitle : song.songTitle.substring(0, 20),
            ));
          }
        }

        return DefaultTabController(
          length: snapshot.data.length,
          child: Scaffold(
            appBar: buildAppBar(tabs),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: buildTabs(snapshot.data),
          ),
        );
      },
    );
  }

  Widget buildAppBar(List<Widget> tabs) {
    return AppBar(
      leading: getBackButton(),
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).backgroundColor,
      title: Text(
        widget.playlist.title,
        style: Theme.of(context).textTheme.title
      ),
      centerTitle: true,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: InkWell(
            child: Center(
              child: Text(
                'Edit',
                style: Theme.of(context).textTheme.button
              ),
            ),
            onTap: () => onEditTapped(),
          ),
        )
      ],
      bottom: TabBar(isScrollable: true, tabs: tabs),
    );
  }

  Widget getBackButton() {
    if (Platform.isAndroid) {
      return InkWell(
          child: Icon(Icons.home, size: 35.0,),
          onTap: () => Navigator.popUntil(context, ModalRoute.withName(bloc.isFirstLaunchValue ? '/home' : '/')));
    }
  }

  Widget buildTabs(List<Song> songs) {
    List<Widget> tabScreens = List();
    for (Song song in songs) {
      tabScreens.add(LyricsScreen(
        song: song,
      ));
    }
    return TabBarView(
      children: tabScreens,
    );
  }

  void onEditTapped() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => EditAddAndRemoveFromPlaylist(playlist: widget.playlist,)
    )
  );
  }
}
