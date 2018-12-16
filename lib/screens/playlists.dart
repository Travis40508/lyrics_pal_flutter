import 'package:flutter/material.dart';

class Playlists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  Widget buildFloatingActionButton(context) {
    return FloatingActionButton(
      child: Icon(Icons.add, color: Colors.black87,),
      mini: true,
      onPressed: () => Navigator.pushNamed(context, '/add_playlist'),
    );
  }
}
