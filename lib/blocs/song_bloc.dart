import 'package:lyrics_pal/models/search_source.dart';
import 'package:lyrics_pal/repository/search_api.dart';
import 'package:rxdart/rxdart.dart';
import '../models/search_results.dart';

class SongBloc {
  SearchSource searchSource = SearchApi();
  final _searchSubject = PublishSubject<List<Track>>();

  Observable<List<Track>> get searchStream => _searchSubject.stream;

  void searchTextChanged(String query) async {
    Observable.fromFuture(searchSource.fetchSongs(query))
        .debounce(Duration(milliseconds: 600))
        .map((searchResults) => searchResults.results.trackMatches.trackList)
        .listen((tracks) => _searchSubject.sink.add(tracks), onError: (error) => print(error));
  }

  void dispose() {
    _searchSubject.close();
  }
}