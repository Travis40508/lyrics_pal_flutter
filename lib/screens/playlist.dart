import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/playlist.dart';
import 'package:lyrics_pal/models/song.dart';
import '../blocs/song_bloc_provider.dart';

class PlaylistScreen extends StatelessWidget {

  final Playlist playlist;

  PlaylistScreen({this.playlist});

  @override
  Widget build(BuildContext context) {

    final bloc = SongBlocProvider.of(context);
    bloc.fetchAllPlaylistSongs(playlist);

    return Scaffold(
      appBar: buildAppBar(bloc),
    );
  }

  Widget buildAppBar(SongBloc bloc) {
    return StreamBuilder(
      stream: bloc.currentPlayListSongs,
      builder: (context, AsyncSnapshot<List<Song>> snapshot) {
        if (!snapshot.hasData) {
          return AppBar(
            backgroundColor: Colors.black87,
            title: Text(playlist.title, style: TextStyle(color: Colors.white),),
            centerTitle: true,
          );
        }
        List<Widget> tabs = List();
        for (Song song in snapshot.data) {
          tabs.add(Tab(text: song.songTitle,));
        }

        return AppBar(
          backgroundColor: Colors.black87,
          title: Text("Home", style: TextStyle(color: Colors.white),),
          centerTitle: true,
          bottom: TabBar(
            tabs: tabs,
          ),
        );
      },
    );
  }
}
