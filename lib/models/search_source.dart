
import 'package:lyrics_pal/models/search_results.dart';

abstract class SearchSource {
  Future<SearchResults> fetchSongs(String query);
}