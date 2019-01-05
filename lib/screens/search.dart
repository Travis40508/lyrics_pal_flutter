import 'dart:io';

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
      leading: getBackButton(),
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).backgroundColor,
      title: Text(
        "Search",
        style: Theme.of(context).textTheme.title,
      ),
      centerTitle: true,
    );
  }

  Widget getBackButton() {
    if (Platform.isAndroid) {
      return InkWell(
          child: Icon(Icons.home, size: 35.0,),
          onTap: () => Navigator.popUntil(context, ModalRoute.withName(bloc.isFirstLaunchValue ? '/home' : '/')));
    }
  }

  Widget buildSearchBar() {
    return TextField(
      controller: _controller,
      onChanged: bloc.searchTextChanged,
      style: Theme.of(context).textTheme.title,
      cursorColor: Theme.of(context).accentColor,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).iconTheme.color,
        ),
        labelText: "Song Search",
        labelStyle: Theme.of(context).textTheme.title,
        hintText: "Ex. 'Another Brick in the Wall'",
        hintStyle: Theme.of(context).textTheme.title,
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
