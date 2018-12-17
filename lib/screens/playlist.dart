import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/playlist.dart';
import 'package:lyrics_pal/models/song.dart';
import 'package:lyrics_pal/screens/lyrics.dart';
import '../blocs/song_bloc_provider.dart';

class PlaylistScreen extends StatelessWidget {
  final Playlist playlist;

  PlaylistScreen({this.playlist});

  @override
  Widget build(BuildContext context) {
    final bloc = SongBlocProvider.of(context);
    bloc.fetchAllPlaylistSongs(playlist);

    return StreamBuilder(
      stream: bloc.currentPlayListSongs,
      builder: (context, AsyncSnapshot<List<Song>> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        List<Widget> tabs = List();
        for (Song song in snapshot.data) {
          tabs.add(Tab(text: song.songTitle,));
        }

        return DefaultTabController(
          length: snapshot.data.length,
          child: Scaffold(
            appBar: buildAppBar(bloc, tabs),
            backgroundColor: Colors.black87,
            body: buildTabs(bloc, snapshot.data),
          ),
        );
      },
    );
  }

  Widget buildAppBar(SongBloc bloc, List<Widget> tabs) {
    return AppBar(
      backgroundColor: Colors.black87,
      title: Text(
        playlist.title,
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      bottom: TabBar(tabs: tabs),
    );
  }

  Widget buildTabs(SongBloc bloc, List<Song> songs) {
    List<Widget> tabScreens = List();
    for (Song song in songs) {
      tabScreens.add(LyricsScreen(song: song,));
    }
    return TabBarView(
      children: tabScreens,
    );
  }
}
