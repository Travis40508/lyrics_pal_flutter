import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/search_results.dart';
import 'package:transparent_image/transparent_image.dart';

class SongTile extends StatelessWidget {

  final Track track;

  SongTile({this.track});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, bottom: 80.0, top: 80.0),
      child: ListTile(
        leading: Container(width: 120.0, height: 120.0, child: Stack(children: <Widget>[Center(child: CircularProgressIndicator()), ClipOval(child: Image.network(track.images[2].imageUrl,),)])),
        title: Text('${track.name}', style: TextStyle(color: Colors.white),),
        subtitle: Text('${track.artist}', style: TextStyle(color: Colors.white),),
      ),
    );
  }
}
