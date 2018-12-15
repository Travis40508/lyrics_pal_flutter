import 'package:lyrics_pal/models/search_source.dart';

import 'search_api.dart';
import '../models/search_results.dart';

class Repository implements SearchSource {

  final searchApi = SearchApi();

  @override
  Future<SearchResults> fetchSongs(String query) async {
    SearchResults searchResults = await searchApi.fetchSongs(query);
    return searchResults;
  }

}