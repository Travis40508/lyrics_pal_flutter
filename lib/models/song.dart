import 'package:lyrics_pal/models/abstract_song.dart';

class Song implements AbstractSong {
  int id;
  final String artist;
  final String songTitle;
  final String imageUrl;
  String lyrics;


  Song(this.artist, this.songTitle, this.imageUrl, this.lyrics);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'artist': artist,
      'song': songTitle,
      'image': imageUrl,
      'lyrics': lyrics
    };
  }

  Song.fromJson(Map<String, dynamic> parsedJson)
      : artist = parsedJson['artist'],
        songTitle = parsedJson['song'],
        imageUrl = parsedJson['image'],
        lyrics = parsedJson['lyrics'],
        id = parsedJson['id'];

  @override
  String getArtist() {
    return artist;
  }

  @override
  String getSongImage() {
    return imageUrl;
  }

  @override
  String getSongTitle() {
    return songTitle;
  }

  @override
  String getSongLyrics() {
    return lyrics;
  }

  @override
  int getSongId() {
    return id;
  }

  void setNewLyrics(String newLyrics) {
    lyrics = newLyrics;
  }
}
