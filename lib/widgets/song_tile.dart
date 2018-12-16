import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/abstract_song.dart';
import 'package:lyrics_pal/screens/confirm.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SongTile extends StatelessWidget {
  final AbstractSong song;
  final VoidCallback onPressed;

  SongTile({this.song, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80.0),
      child: ListTile(
        onTap: onPressed,
        leading: Container(
            width: 120.0,
            height: 120.0,
            child: ClipOval(
                child: Hero(
                    tag: '${song.getSongTitle()} - ${song.getArtist()}',
                    child: CachedNetworkImage(
                      imageUrl: song.getSongImage(),
                    )),
              )
            ),
        title: Text(
          '${song.getSongTitle()}',
          style: TextStyle(color: Colors.white, fontSize: 24.0),
        ),
        subtitle: Text(
          '${song.getArtist()}',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

}
