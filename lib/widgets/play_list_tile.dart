import 'package:flutter/material.dart';

class PlayListTile extends StatelessWidget {

  final String title;
  final VoidCallback onPressed;
  final int index;

  PlayListTile({this.title, this.onPressed, this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 8.0,
        child: Container(
          color: Colors.black87,
          child: ListTile(
            onTap: onPressed,
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text('${index + 1}', style: TextStyle(color: Colors.black87, fontSize: 18.0),),
            ),
            title: Text(title, style: TextStyle(color: Colors.white, fontSize: 16.0),),
          ),
        ),
      ),
    );
  }
}
