import 'package:http/http.dart' show Client;
import 'package:lyrics_pal/models/search_source.dart';
import '../models/search_response.dart';
import 'dart:convert';

final String _baseUrl = "http://ws.audioscrobbler.com/2.0";
final String _apiKey = "a8960a28bf9866251a301af8c95b234c";
final String _searchMethod = "track.search";
final String _format = "json";

class SearchApi implements SearchSource {
  Client client = Client();

  @override
  Future<SearchResponse> fetchSongs(String searchQuery) async {
    String url = '$_baseUrl/?method=$_searchMethod&api_key=$_apiKey&track=$searchQuery&format=$_format';
    final response = await client.get(url);
    final searchResults = json.decode(response.body);

    return SearchResponse.fromJson(searchResults);
  }

}