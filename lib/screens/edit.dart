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
      backgroundColor: Color(0xDD212121),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      actions: <Widget>[
        InkWell(
          onTap: null,
          child: Center(
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBody() {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: TextField(
            controller: _controller,
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
        Text('Playlist Songs', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16.0),),
        showPlayListSongs(),
        Padding(
          padding: const EdgeInsets.only(top: 80.0, bottom: 50.0),
          child: Divider(color: Colors.white, height: 1.0,),
        ),
        Text('Library', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16.0),),
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
            return SongTile(
              song: snapshot.data[index],
              onPressed: () => bloc.playListSongPressedInPlaylistEditing(snapshot.data[index]),
            );
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
}
