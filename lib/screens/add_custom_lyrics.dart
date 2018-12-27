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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  Widget buildAppBar() {
    return AppBar(
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).backgroundColor,
      centerTitle: true,
      title: Text(
        'Add Custom Lyrics',
        style: Theme.of(context).textTheme.title,
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: InkWell(
            onTap: () => onSavePressed(),
            child: Center(
              child: Text(
                'Save',
                style: Theme.of(context).textTheme.button),
              ),
            ),
        ),
      ],
    );
  }

  void onSavePressed() {
    bloc.saveCustomSongToLibrary(_titleController.text, _artistController.text,
        _imageController.text, _lyricsController.text);
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('${_titleController.text} has been saved!', style: TextStyle(color: Theme.of(context).accentColor, fontSize: 16.0, fontWeight: FontWeight.bold),),
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
          style: Theme.of(context).textTheme.title,
          cursorColor: Theme.of(context).accentColor,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.title,
              color: Theme.of(context).iconTheme.color,
            ),
            labelText: 'Title',
            labelStyle: Theme.of(context).textTheme.title,
            hintText: "Ex. 'Another Brick in the Wall'",
            hintStyle: Theme.of(context).textTheme.title,
          ),
        ),
        TextField(
          controller: _artistController,
          style: Theme.of(context).textTheme.title,
          cursorColor: Theme.of(context).accentColor,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.person,
              color: Theme.of(context).iconTheme.color,
            ),
            labelText: 'Artist',
            labelStyle: Theme.of(context).textTheme.title,
            hintText: "Ex. 'Pink Floyd'",
            hintStyle: TextStyle(color: Theme.of(context).accentColor),
          ),
        ),
        TextField(
          controller: _imageController,
          style: Theme.of(context).textTheme.title,
          cursorColor: Theme.of(context).accentColor,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.image,
              color: Theme.of(context).iconTheme.color,
            ),
            labelText: 'Image Url',
            labelStyle: Theme.of(context).textTheme.title,
            hintText: "Leave blank for default image",
            hintStyle: Theme.of(context).textTheme.title,
          ),
        ),
        Expanded(
          child: TextField(
            controller: _lyricsController,
            maxLines: 200,
            style: Theme.of(context).textTheme.title,
            cursorColor: Theme.of(context).accentColor,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.queue_music,
                color: Theme.of(context).iconTheme.color,
              ),
              labelText: 'Lyrics',
              labelStyle: Theme.of(context).textTheme.title,
              hintText: "Ex. 'Hey, Teacher! Leave them kids alone!'",
              hintStyle: Theme.of(context).textTheme.title,
            ),
          ),
        ),
      ],
    );
  }
}
