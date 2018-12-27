import 'package:flutter/material.dart';

class LyricsOptionTile extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;

  LyricsOptionTile({@required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: Theme.of(context).accentColor, fontSize: 32.0),
            ),
          ),
        ),
      ),
    );
  }
}
