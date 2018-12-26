import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lyrics_pal/screens/library.dart';
import 'dart:io';

import 'package:lyrics_pal/screens/playlists.dart';

Widget getTabLayout() {
  if (Platform.isAndroid) {
    return TabBar(
      tabs: <Widget>[
        Tab(icon: Icon(Icons.queue_music), text: "Playlists",),
        Tab(icon: Icon(Icons.library_music), text: "Library",),
        Tab(icon: Icon(Icons.calendar_today), text: "Shows",)
      ],
    );
  } else if (Platform.isIOS) {
    return CupertinoSegmentedControl(
      onValueChanged: (v) => returnSegmentedControllerPage(v),
      groupValue: 0,
      children: {
        0: Column(
          children: <Widget>[
            Icon(Icons.queue_music),
            Text('Playlists')
          ],
        ),
        1: Column(
          children: <Widget>[
            Icon(Icons.library_music),
            Text('Library')
          ],
        ),
        2: Column(
          children: <Widget>[
            Icon(Icons.calendar_today),
            Text('Shows')
          ],
        ),
      },
    );
  }
}

Widget returnSegmentedControllerPage(int value) {
  switch (value) {
    case 0:
      return Playlists();
      break;
    case 1:
      return Library();
      break;
    case 2:
      break;
  }
}