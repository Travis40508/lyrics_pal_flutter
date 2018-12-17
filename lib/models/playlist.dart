import 'dart:convert';

class Playlist {
  int id;
  final List<dynamic> songs;


  Playlist(this.songs);

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'songs': jsonEncode(songs)
    };
  }

  Playlist.fromJson(Map<String, dynamic> parsedJson)
  : songs = jsonDecode(parsedJson['songs']);
}