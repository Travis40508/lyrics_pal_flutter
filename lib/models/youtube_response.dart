
class YoutubeResponse {
  final List<Items> items;

  YoutubeResponse({this.items});

  factory YoutubeResponse.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['items'] as List;
    List<Items> items = list.map((item) => Items.fromJson(item)).toList();
    return YoutubeResponse(items: items);
  }
}

class Items {

  final Id id;
  final Snippet snippet;

  Items.fromJson(Map<String, dynamic> parsedJson)
  : id = Id.fromJson(parsedJson['id']),
    snippet = Snippet.fromJson(parsedJson['snippet']);
}

class Id {

  final String videoId;

  Id.fromJson(Map<String, dynamic> parsedJson)
  : videoId = parsedJson['videoId'];
}

class Snippet {

  final String title;

  Snippet.fromJson(Map<String, dynamic> parsedJson)
  : title = parsedJson['title'];
}