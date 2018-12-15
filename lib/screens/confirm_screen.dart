import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/search_response.dart';
import '../blocs/song_bloc_provider.dart';

class ConfirmScreen extends StatelessWidget {

  final Track track;

  ConfirmScreen({this.track});

  @override
  Widget build(BuildContext context) {
    final bloc = SongBlocProvider.of(context);
    bloc.fetchLyrics(track.artist, track.name);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('${track.artist} - ${track.name}', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      backgroundColor: Colors.black54,
      body: buildLyricsBody(bloc),
    );
  }

  Widget buildLyricsBody(SongBloc bloc) {
    return Center(
      child: Column(
        children: <Widget>[
          Hero(
            tag: '${track.name} - ${track.artist}',
            child: Image.network(track.images[2].imageUrl),
          ),
          Expanded(
            child: StreamBuilder(
              stream: bloc.lyricsStream,
              builder: (context, snapshot) {
                if(snapshot.hasError) {
                  return Text("Error fetching lyrics. Please try again", style: TextStyle(color: Colors.white),);
                } else if(!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator(),);
                } else {
                  return ListView(
                    children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('${snapshot.data}', style: TextStyle(color: Colors.white, fontSize: 24.0), textAlign: TextAlign.center,),
                    ),
                    ],
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
