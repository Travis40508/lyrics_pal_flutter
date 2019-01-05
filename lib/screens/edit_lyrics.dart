import 'dart:io';

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
          '${widget.song.getSongTitle()}',
        style: Theme.of(context).textTheme.title,
      ),
      actions: <Widget>[
        InkWell(
          onTap: () => onSaveLyricsClicked(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Text(
                'Save',
                style: Theme.of(context).textTheme.title
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
                style: Theme.of(context).textTheme.title
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
      style: Theme.of(context).textTheme.body1,
      cursorColor: Theme.of(context).accentColor,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.queue_music,
          color: Theme.of(context).iconTheme.color,
        ),

        hintText: "Ex. 'Hey, Teacher! Leave them kids alone!'",
        hintStyle: Theme.of(context).textTheme.title,
      ),
    );
  }
}
