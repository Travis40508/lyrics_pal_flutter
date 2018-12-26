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
        appBar: buildAppBar(context),
        body: buildTabContent(),
      ),
    );
  }

  Widget buildAppBar(context) {
    return AppBar(
      backgroundColor: Colors.black87,
      title: Text("Home", style: TextStyle(color: Colors.white),),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.settings, color: Colors.white,
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

