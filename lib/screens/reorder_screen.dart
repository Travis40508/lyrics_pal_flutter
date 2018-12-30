import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/song.dart';
import 'package:lyrics_pal/widgets/song_tile.dart';
import '../blocs/song_bloc.dart';

class ReorderScreen extends StatefulWidget {

  final List<Song> playlist;
  final String playlistTitle;
  final int playListId;

  ReorderScreen({@required this.playlist, this.playlistTitle, this.playListId});

  @override
  _ReorderScreenState createState() => _ReorderScreenState();
}

class _ReorderScreenState extends State<ReorderScreen> {

  @override
  void initState() {
    super.initState();
    bloc.setPlayListValue(widget.playlist);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  Widget buildBody() {
      return StreamBuilder(
        stream: bloc.currentPlayListSongs,
        builder: (context, AsyncSnapshot<List<Song>> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          return Scrollbar(
            child: ReorderableListView(
              scrollDirection: Axis.vertical,
              children: snapshot.data.map((song) => SongTile(song: song, onPressed: () => bloc.librarySongPressedInPlaylistEditing(song), key: Key('${snapshot.data.indexOf(song)} ${song.getSongTitle()} ${song.getArtist()}'))).toList(),
              onReorder: (oldIndex, newIndex) => _onReorder(oldIndex, newIndex, snapshot.data),
            ),
          );
        },
      );
    }

    void _onReorder(oldIndex, newIndex, List<Song> songs) {
      List<Song> playListSongs = songs;
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Song item = playListSongs.removeAt(oldIndex);
      playListSongs.insert(newIndex, item);
      bloc.setPlayListValue(playListSongs);
  }

  Widget buildAppBar() {
    return AppBar(
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).backgroundColor,
      title: Text(
          'Reorder Songs',
        style: Theme.of(context).textTheme.title,
      ),
      centerTitle: true,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: InkWell(
            onTap: () => savePressed(),
            child: Center(
              child: Text(
                'Save',
                style: Theme.of(context).textTheme.title,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void savePressed() {
    bloc.savePressedOnReorderScreen(widget.playlist, widget.playlistTitle, widget.playListId);
    Navigator.popUntil(context, ModalRoute.withName('/playlist'));
  }
}
