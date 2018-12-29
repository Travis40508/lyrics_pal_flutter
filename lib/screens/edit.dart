import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/playlist.dart';
import 'package:lyrics_pal/models/song.dart';
import 'package:lyrics_pal/widgets/song_tile.dart';
import '../blocs/song_bloc.dart';

class EditPlaylist extends StatefulWidget {

  final Playlist playlist;

  EditPlaylist({this.playlist});

  @override
  _EditPlaylistState createState() => _EditPlaylistState();

}

class _EditPlaylistState extends State<EditPlaylist> {

  final TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.playlist.title;
    bloc.fetchNonPlayListSongs(widget.playlist);
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
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).backgroundColor,
      centerTitle: true,
      title: Text(
          'Edit Playlist',
        style: Theme.of(context).textTheme.title,
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: InkWell(
            onTap: savePressed,
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
    bloc.savePressedOnEditingScreen(widget.playlist, _controller.text);
    Navigator.pop(context);
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
}
