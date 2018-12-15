import 'package:http/http.dart' show Client;
import 'package:lyrics_pal/models/lyrics_response.dart';
import 'package:lyrics_pal/models/lyrics_source.dart';
import 'dart:convert';

final _baseUrl = "https://api.lyrics.ovh/v1";

class LyricsApi implements LyricsSource {
  Client client = Client();

  @override
  Future<LyricsResponse> fetchLyrics(String artistName, String songTitle) async {
    final url = '$_baseUrl/$artistName/$songTitle';
    final response = await client.get(url);
    final lyrics = json.decode(response.body);

    return LyricsResponse.fromJson(lyrics);
  }


}