class LyricsResponse {
  final lyrics;

  LyricsResponse.fromJson(Map<String, dynamic> parsedJson)
  : lyrics = parsedJson['lyrics'];
}