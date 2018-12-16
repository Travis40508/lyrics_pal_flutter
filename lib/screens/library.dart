import 'package:flutter/material.dart';

class Library extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  Widget buildFloatingActionButton(context) {
    return FloatingActionButton(
      mini: true,
      child: IconButton(icon: Icon(Icons.add, color: Colors.black87,), onPressed: () => Navigator.pushNamed(context, '/search')),
    );
  }
}
