import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/abstract_song.dart';
import 'package:lyrics_pal/screens/confirm.dart';

class SongTile extends StatelessWidget {
  final AbstractSong song;

  SongTile({this.song});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 80.0),
      child: ListTile(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Confirm(
                      song: song,
                    ))),
        leading: Container(
            width: 120.0,
            height: 120.0,
            child: ClipOval(
                child: Hero(
                    tag: '${song.getSongTitle()} - ${song.getArtist()}',
                    child: Image.network(
                      song.getSongImage(),
                    )),
              )
            ),
        title: Text(
          '${song.getSongTitle()}',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          '${song.getArtist()}',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
