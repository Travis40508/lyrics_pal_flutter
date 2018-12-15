import 'package:flutter/material.dart';
import '../blocs/song_bloc_provider.dart';

class AddSong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = SongBlocProvider.of(context);

    return Scaffold(
      appBar: buildSearchBar(bloc),
      body: buildScreenBody(bloc),
      backgroundColor: Colors.black54,
    );
  }

  Widget buildScreenBody(SongBloc bloc) {
    return Column(
      children: <Widget>[
        TextField(
          onChanged: bloc.searchTextChanged,
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.white,),
            labelText: "Song Search",
            labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            hintText: "Ex. 'Another Brick in the Wall'",
            hintStyle: TextStyle(color: Colors.white54),
          ),
        )
      ],
    );
  }

  buildSearchBar(SongBloc bloc) {
    return AppBar(
      backgroundColor: Colors.black87,
      title: Text("Search", style: TextStyle(color: Colors.white),),
      centerTitle: true,
    );
  }
}
