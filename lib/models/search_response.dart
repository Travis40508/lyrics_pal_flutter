import 'package:lyrics_pal/models/abstract_song.dart';

class SearchResponse {
  Results results;

  SearchResponse.fromJson(Map<String, dynamic> parsedJson)
  : results = Results.fromJson(parsedJson['results']);
}

class Results {
  TrackMatches trackMatches;

  Results.fromJson(Map<String, dynamic> parsedJson)
      : trackMatches = TrackMatches.fromJson(parsedJson['trackmatches']);
}

class TrackMatches {
  final List<Track> trackList;

  TrackMatches({this.trackList});

  TrackMatches.fromJson(Map<String, dynamic> parsedJson)
    :trackList = (parsedJson['track'] as List).map((track) => Track.fromJson(track)).toList();
}

class Track implements AbstractSong {
  final String name;
  final String artist;
  final List<ArtistImage> images;


  Track({this.name, this.artist, this.images});

  Track.fromJson(Map<String, dynamic> parsedJson)
    :images = (parsedJson['image'] as List).map((images) => ArtistImage.fromJson(images)).toList(),
    name = parsedJson['name'],
    artist = parsedJson['artist'];

  @override
  String getArtist() {
    return artist;
  }

  @override
  String getSongImage() {
    return images[2].imageUrl;
  }

  @override
  String getSongTitle() {
    return name;
  }

  @override
  String getSongLyrics() {
    return null;
  }

  @override
  int getSongId() {
    return null;
  }

}

class ArtistImage {
  final imageUrl;

  ArtistImage({this.imageUrl});

  ArtistImage.fromJson(Map<String, dynamic> parsedJson)
  : imageUrl = parsedJson['#text'];
}