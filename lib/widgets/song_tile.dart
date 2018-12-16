import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/search_response.dart';
import 'package:lyrics_pal/screens/confirm.dart';
import 'package:transparent_image/transparent_image.dart';

class SongTile extends StatelessWidget {
  final Track track;

  SongTile({this.track});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 80.0),
      child: ListTile(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Confirm(
                      track: track,
                    ))),
        leading: Container(
            width: 120.0,
            height: 120.0,
            child: ClipOval(
                child: Hero(
                    tag: '${track.name} - ${track.artist}',
                    child: Image.network(
                      track.images[2].imageUrl,
                    )),
              )
            ),
        title: Text(
          '${track.name}',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          '${track.artist}',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
