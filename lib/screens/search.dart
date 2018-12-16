import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/search_response.dart';
import 'package:lyrics_pal/widgets/song_tile.dart';
import '../blocs/song_bloc_provider.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = SongBlocProvider.of(context);

    return Scaffold(
      appBar: buildSearchBar(bloc),
      body: buildScreenBody(bloc, context),
      backgroundColor: Colors.black54,
    );
  }

  Widget buildScreenBody(SongBloc bloc, context) {
    return Column(
      children: <Widget>[
        TextField(
          onChanged: bloc.searchTextChanged,
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            labelText: "Song Search",
            labelStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            hintText: "Ex. 'Another Brick in the Wall'",
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
        showSearchResults(bloc, context),
      ],
    );
  }

  buildSearchBar(SongBloc bloc) {
    return AppBar(
      backgroundColor: Colors.black87,
      title: Text(
        "Search",
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
    );
  }

  Widget showSearchResults(SongBloc bloc, context) {
    return StreamBuilder(
      stream: bloc.searchStream,
      builder: (context, AsyncSnapshot<List<Track>> snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: Stack(
              children: <Widget>[
                Opacity(
                  opacity: snapshot.hasData || snapshot.hasError ? 0.0 : 100.0,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, int position) {
                    return SongTile(
                      track: snapshot.data[position],
                    );
                  },
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
