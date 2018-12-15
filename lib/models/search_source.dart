
import 'package:lyrics_pal/models/search_response.dart';

abstract class SearchSource {
  Future<SearchResponse> fetchSongs(String query);
}