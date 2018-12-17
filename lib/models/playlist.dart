import 'dart:convert';

class Playlist {
  int id;
  final String title;
  final List<dynamic> songs;


  Playlist(this.title, this.songs);

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'title': title,
      'songs': jsonEncode(songs)
    };
  }

  Playlist.fromJson(Map<String, dynamic> parsedJson)
  :     title = parsedJson['title'],
        songs = jsonDecode(parsedJson['songs']);
}