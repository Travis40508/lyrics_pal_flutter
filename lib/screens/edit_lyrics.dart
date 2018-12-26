import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/song.dart';
import '../blocs/song_bloc.dart';

class EditLyrics extends StatefulWidget {
  final Song song;

  EditLyrics({this.song});

  @override
  _EditLyricsState createState() => _EditLyricsState();
}

class _EditLyricsState extends State<EditLyrics> {
  final TextEditingController _lyricsController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _lyricsController.text = widget.song.lyrics;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildEditLyricsBody(),
      backgroundColor: Color(0xDD212121),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black87,
      centerTitle: true,
      title: Text(
          '${widget.song.getSongTitle()}',
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        InkWell(
          onTap: () => onSaveLyricsClicked(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => onRetrieveOriginalLyricsTapped(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Text(
                'Original',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onRetrieveOriginalLyricsTapped() async {
    _lyricsController.text = await bloc.fetchOriginalLyrics(widget.song.getArtist(), widget.song.getSongTitle());
  }

  void onSaveLyricsClicked() {
    bloc.onSaveEditLyricsTapped(widget.song, _lyricsController.text);
    Navigator.pop(context);
  }

  Widget buildEditLyricsBody() {
    return TextField(
      controller: _lyricsController,
      maxLines: 200,
      style: TextStyle(color: Colors.white, fontSize: 24.0),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.queue_music,
          color: Colors.white,
        ),

        hintText: "Ex. 'Hey, Teacher! Leave them kids alone!'",
        hintStyle: TextStyle(color: Colors.white54),
      ),
    );
  }
}
