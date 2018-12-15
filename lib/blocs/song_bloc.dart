import 'package:lyrics_pal/repository/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/search_response.dart';

class SongBloc {
  final repository = Repository();
  final _searchSubject = PublishSubject<List<Track>>();
  final _lyricsSubject = PublishSubject<String>();

  Observable<List<Track>> get searchStream => _searchSubject.stream;
  Observable<String> get lyricsStream => _lyricsSubject.stream;

  void searchTextChanged(String query) async {
    Observable.fromFuture(repository.fetchSongs(query))
        .debounce(Duration(milliseconds: 600))
        .map((searchResults) => searchResults.results.trackMatches.trackList)
        .listen((tracks) => _searchSubject.sink.add(tracks), onError: (error) => print(error));
  }

  void fetchLyrics(String artistName, String songTitle) {
    Observable.fromFuture(repository.fetchLyrics(artistName, songTitle))
        .listen((lyricsResponse) => _lyricsSubject.sink.add(lyricsResponse.lyrics), onError: (error) => print(error));
  }

  void dispose() {
    _searchSubject.close();
    _lyricsSubject.close();
  }
}