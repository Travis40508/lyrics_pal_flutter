import 'package:lyrics_pal/models/song.dart';
import 'package:lyrics_pal/repository/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/search_response.dart';

class SongBloc {
  final repository = Repository();
  final _searchSubject = PublishSubject<List<Track>>();
  final _lyricsSubject = BehaviorSubject<String>();
  final _allSongsSubject = PublishSubject<List<Song>>();

  Observable<List<Track>> get searchStream => _searchSubject.stream;
  Observable<String> get lyricsStream => _lyricsSubject.stream;
  Observable<List<Song>> get libraryStream => _allSongsSubject.stream;
  String get currentLyrics => _lyricsSubject.value;

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

  void fetchAllSongs() {
    Observable.fromFuture(repository.fetchAllSongs())
        .listen((songs) => _allSongsSubject.sink.add(songs), onError: (error) => print(error));
  }

  void saveSongToLibrary(Track track, String lyrics) async {
    Song song = Song(track.artist, track.name, track.images[2].imageUrl, lyrics);

    int response = await repository.saveTrackToLibrary(song);
    print(response);
  }

  void dispose() {
    _searchSubject.close();
    _lyricsSubject.close();
    _allSongsSubject.close();
  }
}