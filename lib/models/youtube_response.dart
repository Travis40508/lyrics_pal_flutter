
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

  Items.fromJson(Map<String, dynamic> parsedJson)
  : id = Id.fromJson(parsedJson['id']);
}

class Id {

  final String videoId;

  Id.fromJson(Map<String, dynamic> parsedJson)
  : videoId = parsedJson['videoId'];
}