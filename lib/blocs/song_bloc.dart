import 'package:lyrics_pal/models/abstract_song.dart';
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

  void fetchLyrics(AbstractSong song) {
    if (song.getSongLyrics() != null) {
      _lyricsSubject.sink.add(song.getSongLyrics());
    } else {
      _lyricsSubject.sink.add(null);
    Observable.fromFuture(repository.fetchLyrics(song.getArtist(), song.getSongTitle()))
        .listen((lyricsResponse) => _lyricsSubject.sink.add(lyricsResponse.lyrics), onError: (error) => print(error));
    }
  }

  void fetchAllSongs() {
    Observable.fromFuture(repository.fetchAllSongs())
        .listen((songs) => _allSongsSubject.sink.add(songs), onError: (error) => print(error));
  }

  Future<bool> saveSongToLibrary(Track track, String imageUrl, String lyrics) async {
    Song song = Song(track.artist, track.name, imageUrl, lyrics);

    int response = await repository.saveTrackToLibrary(song);

    if(response != 0) {
      return true;
    } else {
      return false;
    }
  }

  void dispose() {
    _searchSubject.close();
    _lyricsSubject.close();
    _allSongsSubject.close();
  }
}