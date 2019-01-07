import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lyrics_pal/widgets/lyrics_option_tile.dart';
import '../blocs/song_bloc.dart';

class LyricsOptions extends StatefulWidget {
  @override
  LyricsOptionsState createState() {
    return new LyricsOptionsState();
  }
}

class LyricsOptionsState extends State<LyricsOptions> {

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: buildAppBar(),
      body: buildOptions(context),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      leading: getBackButton(),
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).backgroundColor,
      centerTitle: true,
      title: Text(
          'Lyrics Options',
        style: Theme.of(context).textTheme.title
      ),
    );
  }

  Widget getBackButton() {
    if (Platform.isAndroid) {
      return InkWell(
          child: Icon(Icons.home, size: 35.0,),
          onTap: () => Navigator.popUntil(context, ModalRoute.withName(bloc.isFirstLaunchValue ? '/home' : '/')));
    }
  }

  Widget buildOptions(context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: LyricsOptionTile(
            text: 'Search Lyrics',
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
        ),
        Expanded(
          child: LyricsOptionTile(
            text: 'Custom Lyrics',
            onPressed: () => Navigator.pushNamed(context, '/custom_lyrics'),
          ),
        )
      ],
    );
  }
}
