import 'package:flutter/material.dart';
import 'package:lyrics_pal/screens/playlists.dart';
import 'library.dart';
import 'package:flutter/cupertino.dart';

class Home extends StatefulWidget {

  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: buildAppBar(context),
        body: buildTabContent(),
      ),
    );
  }

  Widget buildAppBar(context) {
    return AppBar(
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).backgroundColor,
      title: Text("Home", style: Theme.of(context).textTheme.title),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.settings, color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pushNamed(context, '/settings'),
        )
      ],
      bottom: TabBar(
        tabs: <Widget>[
          Tab(icon: Icon(Icons.queue_music), text: "Playlists",),
          Tab(icon: Icon(Icons.library_music), text: "Library",),
          Tab(icon: Icon(Icons.calendar_today), text: "Shows",)
        ],
      ),
    );
  }

  Widget buildTabContent() {
    return TabBarView(
      children: <Widget>[
        Playlists(),
        Library(),
      ],
    );
  }
}

