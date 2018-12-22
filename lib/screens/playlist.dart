import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/playlist.dart';
import 'package:lyrics_pal/models/song.dart';
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
            tabs.add(Tab(text: song.songTitle,));
          }
        }

        return DefaultTabController(
          length: snapshot.data.length,
          child: Scaffold(
            appBar: buildAppBar(tabs),
            backgroundColor: Colors.black87,
            body: buildTabs(snapshot.data),
          ),
        );
      },
    );
  }

  Widget buildAppBar(List<Widget> tabs) {
    return AppBar(
      backgroundColor: Colors.black87,
      title: Text(
        widget.playlist.title,
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      bottom: TabBar(tabs: tabs),
    );
  }

  Widget buildTabs(List<Song> songs) {
    List<Widget> tabScreens = List();
    for (Song song in songs) {
      tabScreens.add(LyricsScreen(song: song,));
    }
    return TabBarView(
      children: tabScreens,
    );
  }
}
