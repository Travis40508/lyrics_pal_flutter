import 'package:flutter/material.dart';
import 'package:lyrics_pal/widgets/lyrics_option_tile.dart';

class LyricsOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xDD212121),
      appBar: buildAppBar(),
      body: buildOptions(context),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black87,
      centerTitle: true,
      title: Text(
          'Lyrics Options',
        style: TextStyle(
          color: Colors.white
        ),
      ),
    );
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
            onPressed: null,
          ),
        )
      ],
    );
  }
}
