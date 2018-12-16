import '../models/song.dart';
import 'dart:convert';

class Playlist {
  final List<Song> songs;

  Playlist(this.songs);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'songs': jsonEncode(songs)
    };
  }

  factory Playlist.fromJson(Map<String, dynamic> parsedJson) {
  var list = jsonDecode(parsedJson['songs']) as List;
  List<Song> playList = list.map((song) => Song.fromJson(song));

  return Playlist(playList);
}
}