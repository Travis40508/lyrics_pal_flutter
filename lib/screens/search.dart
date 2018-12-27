import 'package:flutter/material.dart';
import 'package:lyrics_pal/models/search_response.dart';
import 'package:lyrics_pal/screens/confirm.dart';
import 'package:lyrics_pal/widgets/song_tile.dart';
import '../blocs/song_bloc.dart';

class Search extends StatefulWidget {
  @override
  SearchState createState() {
    return new SearchState();
  }
}

class SearchState extends State<Search> {
  final TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBar(),
      body: buildScreenBody(context),
      backgroundColor: Color(0xDD212121),
    );
  }

  Widget buildScreenBody(context) {
    return Column(
      children: <Widget>[
        buildSearchBar(),
        showSearchResults(context),
      ],
    );
  }

  buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black87,
      title: Text(
        "Search",
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
    );
  }

  Widget buildSearchBar() {
    return TextField(
      controller: _controller,
      onChanged: bloc.searchTextChanged,
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.search,
          color: Colors.white,
        ),
        labelText: "Song Search",
        labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        hintText: "Ex. 'Another Brick in the Wall'",
        hintStyle: TextStyle(color: Colors.white54),
      ),
    );
  }

  Widget showSearchResults(context) {
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
                      song: snapshot.data[position],
                      onPressed: () =>
                          onSongClicked(context, snapshot.data[position]),
                    );
                  },
                ),
              ],
            ),
          );
        } else if (_controller.text.length > 0) {
          return Expanded(child: Center(child: CircularProgressIndicator(),));
        } else {
          return Container();
        }
      },
    );
  }

  void onSongClicked(context, track) {
    _controller.clear();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Confirm(
                  song: track,
                )));
  }
}
