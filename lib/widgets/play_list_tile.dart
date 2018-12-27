import 'package:flutter/material.dart';

class PlayListTile extends StatelessWidget {

  final String title;
  final VoidCallback onPressed;
  final VoidCallback onLongPressed;
  final int index;

  PlayListTile({this.title, this.onPressed, this.index, this.onLongPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 8.0,
        child: ListTile(
          onTap: onPressed,
          onLongPress: onLongPressed,
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).accentColor,
            child: Text('${index + 1}', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, fontSize: 18.0),),
          ),
          title: Text(title, style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold, fontSize: 16.0),),
        ),
      ),
    );
  }
}
