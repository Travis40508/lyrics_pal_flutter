import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/abstract_song.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SongTile extends StatelessWidget {
  final AbstractSong song;
  final VoidCallback onPressed;
  final VoidCallback onLongPressed;

  SongTile({this.song, this.onPressed, this.onLongPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 8.0,
        color: Theme.of(context).primaryColor,
        child: ListTile(
          onTap: onPressed,
          onLongPress: onLongPressed,
          leading: Container(
              width: 120.0,
              height: 120.0,
              child: ClipOval(
                  child: Hero(
                tag: '${song.getSongTitle()} - ${song.getArtist()}',
                child: Image(
                  width: 174.0,
                    height: 174.0,
                    image: CachedNetworkImageProvider(song.getSongImage()),
                ),
              ))),
          title: Text(
            '${song.getSongTitle()}',
            style: Theme.of(context).textTheme.body1,
          ),
          subtitle: Text(
            '${song.getArtist()}',
            style: Theme.of(context).textTheme.button,
          ),
        ),
      ),
    );
  }
}
