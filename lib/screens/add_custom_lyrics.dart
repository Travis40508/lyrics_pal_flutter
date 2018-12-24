import 'dart:async';

import 'package:flutter/material.dart';
import '../blocs/song_bloc.dart';

class AddCustomLyrics extends StatefulWidget {
  @override
  _AddCustomLyricsState createState() => _AddCustomLyricsState();
}

class _AddCustomLyricsState extends State<AddCustomLyrics> {
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _artistController = new TextEditingController();
  final TextEditingController _imageController = new TextEditingController();
  final TextEditingController _lyricsController = new TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(),
      body: buildFormBody(),
      backgroundColor: Color(0xDD212121),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black87,
      centerTitle: true,
      title: Text(
        'Add Custom Lyrics',
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        InkWell(
          onTap: () => onSavePressed(),
          child: Center(
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  void onSavePressed() {
    bloc.saveCustomSongToLibrary(_titleController.text, _artistController.text,
        _imageController.text, _lyricsController.text);
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('${_titleController.text} has been saved!'),
      duration: Duration(seconds: 1),
    ));

    Timer(Duration(seconds: 1), popScreen);
  }

  void popScreen() {
    Navigator.pop(context);
  }

  Widget buildFormBody() {
    return Column(
      children: <Widget>[
        TextField(
          controller: _titleController,
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.title,
              color: Colors.white,
            ),
            labelText: 'Title',
            labelStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            hintText: "Ex. 'Another Brick in the Wall'",
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
        TextField(
          controller: _artistController,
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            labelText: 'Artist',
            labelStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            hintText: "Ex. 'Pink Floyd'",
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
        TextField(
          controller: _imageController,
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.image,
              color: Colors.white,
            ),
            labelText: 'Image Url',
            labelStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            hintText: "Leave blank for default image",
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
        Expanded(
          child: TextField(
            controller: _lyricsController,
            maxLines: 200,
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.queue_music,
                color: Colors.white,
              ),
              labelText: 'Lyrics',
              labelStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              hintText: "Ex. 'Hey, Teacher! Leave them kids alone!'",
              hintStyle: TextStyle(color: Colors.white54),
            ),
          ),
        ),
      ],
    );
  }
}
