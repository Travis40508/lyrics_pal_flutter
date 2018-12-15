import 'package:lyrics_pal/models/search_source.dart';
import 'package:lyrics_pal/repository/search_api.dart';
import 'package:rxdart/rxdart.dart';
import '../models/search_results.dart';

class SongBloc {

  SearchSource searchSource = SearchApi();

  void searchTextChanged(String query) async {
    SearchResults results = await searchSource.fetchSongs(query);

  }
}