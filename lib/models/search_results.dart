import 'dart:convert';

class SearchResults {
  Results results;

  SearchResults.fromJson(Map<String, dynamic> parsedJson)
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

  factory TrackMatches.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['track'] as List;
    List<Track> trackList = list.map((i) => Track.fromJson(i)).toList();
    return TrackMatches (
      trackList: trackList
    );
  }
}

class Track {
  final String name;
  final String artist;
  final List<Image> images;


  Track({this.name, this.artist, this.images});

  factory Track.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['image'] as List;
    List<Image> imageList = list.map((i) => Image.fromJson(i)).toList();
    return Track(
        name: parsedJson['name'],
        artist: parsedJson['artist'],
        images: imageList
    );
  }
}

class Image {
  final imageUrl;

  Image({this.imageUrl});

  Image.fromJson(Map<String, dynamic> parsedJson)
  : imageUrl = parsedJson['#text'];
}