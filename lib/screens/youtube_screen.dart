import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

class YoutubeScreen extends StatefulWidget {

  final String youtubeId;
  final String title;

  YoutubeScreen({this.title, this.youtubeId});

  @override
  _YoutubeScreenState createState() => _YoutubeScreenState();
}

class _YoutubeScreenState extends State<YoutubeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildYoutubeVideo(),
      backgroundColor: Color(0xDD212121),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black87,
      centerTitle: true,
      title: Text(
        '${widget.title}',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget buildYoutubeVideo() {
    return FlutterYoutube.playYoutubeVideoById(
        apiKey: "AIzaSyCbS_9gcgFNop0nSaV9bBddviOXUUQShAc",
        videoId: widget.youtubeId,
        autoPlay: true, //default falase
        fullScreen: false //default false
    );
  }
}
