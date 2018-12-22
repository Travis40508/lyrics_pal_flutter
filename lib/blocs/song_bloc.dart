import 'package:lyrics_pal/models/abstract_song.dart';
import 'package:lyrics_pal/models/playlist.dart';
import 'package:lyrics_pal/models/song.dart';
import 'package:lyrics_pal/repository/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/search_response.dart';

class SongBloc {
  final repository = Repository();
  final _searchSubject = PublishSubject<List<Track>>();
  final _playListTitleSubject = BehaviorSubject<String>();
  final _lyricsSubject = BehaviorSubject<String>();
  final _allSongsSubject = BehaviorSubject<List<Song>>();
  final _addedSongsSubject = BehaviorSubject<List<Song>>();
  final _canSaveSubject = BehaviorSubject<bool>();
  final _allPlaylists = PublishSubject<List<Playlist>>();
  final _playListSongs = PublishSubject<List<Song>>();


  Observable<List<Track>> get searchStream => _searchSubject.stream;
  Observable<String> get lyricsStream => _lyricsSubject.stream;
  Observable<List<Song>> get libraryStream => _allSongsSubject.stream;
  Observable<bool> get canSaveStream => _canSaveSubject.stream;
  Observable<List<Song>> get playListStream => _addedSongsSubject.stream;
  Observable<String> get playListTitleStream => _playListTitleSubject.stream;
  Observable<List<Playlist>> get allPlayListsStream => _allPlaylists.stream;
  Observable<List<Song>> get currentPlayListSongs => _playListSongs.stream;

  String get currentLyrics => _lyricsSubject.value;
  String get playListTitle => _playListTitleSubject.value;
  List<Song> get currentSongs => _allSongsSubject.value;
  List<Song> get addedPlaylistSongs => _addedSongsSubject.value;
  List<Song> get allSongs => _allSongsSubject.value;
  bool get canSaveValue => _canSaveSubject.value;

  void searchTextChanged(String query) async {
    Observable.fromFuture(repository.fetchSongs(query))
        .debounce(Duration(milliseconds: 600))
        .map((searchResults) => searchResults.results.trackMatches.trackList)
        .listen((tracks) => _searchSubject.sink.add(tracks), onError: (error) => print(error));
  }

  void fetchLyrics(AbstractSong song) {
    if (song.getSongLyrics() != null) {
      _lyricsSubject.sink.add(song.getSongLyrics());
      _canSaveSubject.sink.add(false);
    } else {
      _lyricsSubject.sink.add(null);
      _canSaveSubject.sink.add(true);
    Observable.fromFuture(repository.fetchLyrics(song.getArtist(), song.getSongTitle()))
        .listen((lyricsResponse) => _lyricsSubject.sink.add(lyricsResponse.lyrics), onError: (error) => print(error));
    }
  }

  void fetchAllSongs() {
      Observable.fromFuture(repository.fetchAllSongs())
          .listen((songs) => _allSongsSubject.sink.add(songs),
          onError: (error) => print(error));
  }

  void fetchAllPlaylists() {
    Observable.fromFuture(repository.fetchAllPlaylists())
        .listen((playlists) => _allPlaylists.sink.add(playlists), onError: (error) => print('@@@ $error'));
  }

  Future<bool> saveSongToLibrary(Track track, String imageUrl, String lyrics) async {
    Song song = Song(track.artist, track.name, imageUrl, lyrics);

    int response = await repository.saveTrackToLibrary(song);

    if(response != 0) {
      _canSaveSubject.sink.add(!canSaveValue);

      return true;
    } else {
      return false;
    }
  }

  void dispose() async {
    await _searchSubject.drain();
    _searchSubject.close();

    await _lyricsSubject.drain();
    _lyricsSubject.close();

    await _allSongsSubject.drain();
    _allSongsSubject.close();

    await _canSaveSubject.drain();
    _canSaveSubject.close();

    await _addedSongsSubject.drain();
    _addedSongsSubject.close();

    await _playListTitleSubject.drain();
    _playListTitleSubject.close();

    await _allPlaylists.drain();
    _allPlaylists.close();

    await _playListSongs.drain();
    _playListSongs.close();

  }

  void librarySongPressedInPlaylistCreation(Song song) {
    List<Song> currentSongList = currentSongs;
    List<Song> playListSongs = addedPlaylistSongs == null ? List() : addedPlaylistSongs;
    currentSongList.remove(song);
    playListSongs.add(song);
    _allSongsSubject.sink.add(currentSongList);
    _addedSongsSubject.sink.add(playListSongs);
  }

  void playListSongPressedInPlaylistCreation(Song song) {
    List<Song> currentSongList = currentSongs;
    List<Song> playListSongs = addedPlaylistSongs;
    playListSongs.remove(song);
    currentSongList.add(song);
    _allSongsSubject.sink.add(currentSongList);
    _addedSongsSubject.sink.add(playListSongs);
  }

  void savePlaylistToDatabase(List<Song> songs) async {
    List<int> ids = List();
    for(Song song in songs) {
      ids.add(song.getSongId());
    }
    Playlist playlist = Playlist(playListTitle, ids);
    int response = await repository.savePlaylist(playlist);

    print(response);
  }

  void onPlaylistTitleChanged(String text) {
    _playListTitleSubject.sink.add(text);
  }


  void fetchAllPlaylistSongs(Playlist playlist) async {
    List<Song> playListSongs = List();
    for (int id in playlist.songs) {
      Song song = await repository.fetchSongById(id);
      playListSongs.add(song);
    }
    _playListSongs.sink.add(playListSongs);
  }

  void resetLists() {
    _allSongsSubject.sink.add(null);
    _addedSongsSubject.sink.add(null);
  }

  void checkIfAdded(String artist, String title) async {
    Song song = await repository.fetchSongByArtistAndTitle(artist, title);
    if (song != null) {
      _canSaveSubject.sink.add(false);
    } else {
      _canSaveSubject.sink.add(true);
    }
  }

  deleteSongFromDatabase(String artist, String songTitle) async {
    Song song = await repository.fetchSongByArtistAndTitle(artist, songTitle);

    if (song != null) {
      repository.deleteSongById(song.getSongId());
      _canSaveSubject.sink.add(!canSaveValue);
    }
  }
}

final SongBloc bloc = SongBloc();