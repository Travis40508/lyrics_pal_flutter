import 'package:lyrics_pal/models/abstract_song.dart';
import 'package:lyrics_pal/models/lyrics_response.dart';
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
  final _playListSongs = BehaviorSubject<List<Song>>();
  final _nonPlayListSongs = BehaviorSubject<List<Song>>();
  final _fontSize = BehaviorSubject<double>();
  final _youtubeId = BehaviorSubject<String>();
  final _theme = PublishSubject<String>();
  final String defaultImage =
      'https://cdn.pixabay.com/photo/2015/12/09/22/09/music-1085655_640.png';

  Observable<List<Track>> get searchStream => _searchSubject.stream;

  Observable<String> get lyricsStream => _lyricsSubject.stream;

  Observable<List<Song>> get libraryStream => _allSongsSubject.stream;

  Observable<bool> get canSaveStream => _canSaveSubject.stream;

  Observable<List<Song>> get playListStream => _addedSongsSubject.stream;

  Observable<String> get playListTitleStream => _playListTitleSubject.stream;

  Observable<List<Playlist>> get allPlayListsStream => _allPlaylists.stream;

  Observable<List<Song>> get currentPlayListSongs => _playListSongs.stream;

  Observable<List<Song>> get nonPlayListSongs => _nonPlayListSongs.stream;

  Observable<double> get fontSize => _fontSize.stream;

  Observable<String> get youtubeVideoId => _youtubeId.stream;

  Observable<String> get theme => _theme.stream;

  String get currentLyrics => _lyricsSubject.value;

  String get playListTitle => _playListTitleSubject.value;

  List<Song> get currentSongs => _allSongsSubject.value;

  List<Song> get addedPlaylistSongs => _addedSongsSubject.value;

  List<Song> get allSongs => _allSongsSubject.value;

  List<Song> get playListSongs => _playListSongs.value;

  List<Song> get nonPlayListSongsValue => _nonPlayListSongs.value;

  bool get canSaveValue => _canSaveSubject.value;

  double get fontSizeValue => _fontSize.value;

  void searchTextChanged(String query) async {

    Observable.fromFuture(repository.fetchSongs(query))
        .debounce(const Duration(milliseconds: 600))
        .map((searchResults) => searchResults.results.trackMatches.trackList)
        .listen((tracks) => _searchSubject.sink.add(tracks),
            onError: (error) => print(error));
  }

  void fetchLyrics(AbstractSong song) async {
    if (song.getSongLyrics() != null) {
      song = await repository.fetchSongById(song.getSongId());
      _lyricsSubject.sink.add(song.getSongLyrics());
      _canSaveSubject.sink.add(false);
    } else {
      _lyricsSubject.sink.add(null);
      _canSaveSubject.sink.add(true);
      Observable.fromFuture(
              repository.fetchLyrics(song.getArtist(), song.getSongTitle()))
          .listen(
              (lyricsResponse) =>
                  _lyricsSubject.sink.add(lyricsResponse.lyrics),
              onError: (error) => print(error));
    }
  }

  void fetchAllSongs() {
    Observable.fromFuture(repository.fetchAllSongs()).listen(
        (songs) => _allSongsSubject.sink.add(songs),
        onError: (error) => print(error));
  }

  void fetchAllPlaylists() {
    Observable.fromFuture(repository.fetchAllPlaylists()).listen(
        (playlists) => _allPlaylists.sink.add(playlists),
        onError: (error) => print('@@@ $error'));
  }

  Future<bool> saveSongToLibrary(
      Track track, String imageUrl, String lyrics) async {
    int response;
    if (lyrics != null && lyrics.length != 0) {
      Song song = Song(track.artist, track.name, imageUrl, lyrics);

     response = await repository.saveTrackToLibrary(song);
    }
    print('Save response - $response');

    if (response != 0) {
      _canSaveSubject.sink.add(!canSaveValue);
      return true;
    } else {
      return false;
    }
  }

  saveCustomSongToLibrary(
      String title, String artist, String imageUrl, String lyrics) async {
    imageUrl =
        imageUrl != null && imageUrl.length != 0 ? imageUrl : defaultImage;
    Song song = Song(artist, title, imageUrl, lyrics);

    int result = await repository.saveTrackToLibrary(song);

    print('Save result - $result');
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

    await _nonPlayListSongs.drain();
    _nonPlayListSongs.close();

    await _fontSize.drain();
    _fontSize.close();

    await _youtubeId.drain();
    _youtubeId.close();

    await _theme.drain();
    _theme.close();
  }

  void savePlaylistToDatabase(List<Song> songs) async {
    List<int> ids = List();
    for (Song song in songs) {
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

  deleteSongFromDatabaseFromConfirmScreen(
      String artist, String songTitle) async {
    Song song = await repository.fetchSongByArtistAndTitle(artist, songTitle);

    if (song != null) {
      final result = await repository.deleteSongById(song.getSongId());
      print('Delete song from data base result - $result');
      _canSaveSubject.sink.add(!canSaveValue);
      fetchAllSongs();
      deleteSongFromPlaylists(song);
    }
  }

  deleteSongFromDatabaseFromLibraryScreen(
      String artist, String songTitle) async {
    Song song = await repository.fetchSongByArtistAndTitle(artist, songTitle);

    if (song != null) {
      final result = await repository.deleteSongById(song.getSongId());
      print('Delete song from data base result - $result');
      fetchAllSongs();
      deleteSongFromPlaylists(song);
    }
  }

  void deleteSongFromPlaylists(Song song) async {
    print('Deleting song from playlists');
    List<Playlist> allPlaylists = await repository.fetchAllPlaylists();

    if (allPlaylists != null && allPlaylists.length > 0) {
      for (Playlist playlist in allPlaylists) {
        if (playlist.songs.contains(song.getSongId())) {
          playlist.songs.remove(song.getSongId());
          var updateResult = await repository.updatePlaylist(playlist);
          print('Update Result - $updateResult');
          if (playlist.songs.length == 0) {
            var deleteResult = await repository.deletePlaylist(playlist.id);
            print('Delete Result - $deleteResult');
          }
        }
        allPlaylists = await repository.fetchAllPlaylists();
        _allPlaylists.sink.add(allPlaylists);
      }
    } else {
      print('null playlists');
    }
  }

  deletePlaylist(Playlist playlist) async {
    print('Deleting playing with id: ${playlist.id}');
    int result = await repository.deletePlaylist(playlist.id);
    print('Delete result - $result');
    fetchAllPlaylists();
  }

  void fetchNonPlayListSongs(Playlist playlist) async {
    List<Song> allSongs = await repository.fetchAllSongs();
    List<Song> playListSongs = List();

    for (int songId in playlist.songs) {
      Song song = await repository.fetchSongById(songId);
      allSongs.remove(song);
      allSongs.removeWhere(
          (currentSong) => currentSong.getSongId() == song.getSongId());
      playListSongs.add(song);
    }
    _playListSongs.sink.add(playListSongs);
    _nonPlayListSongs.sink.add(allSongs);
  }

  void librarySongPressedInPlaylistCreation(Song song) {
    List<Song> currentSongList = currentSongs;
    List<Song> playListSongs =
        addedPlaylistSongs == null ? List() : addedPlaylistSongs;
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

  playListSongPressedInPlaylistEditing(Song song) {
    List<Song> nonPlayListSongs = nonPlayListSongsValue;
    List<Song> playListSongs = this.playListSongs;
    playListSongs.remove(song);
    nonPlayListSongs.add(song);
    _nonPlayListSongs.sink.add(nonPlayListSongs);
    _playListSongs.sink.add(playListSongs);
  }

  librarySongPressedInPlaylistEditing(Song song) {
    List<Song> nonPlayListSongs = nonPlayListSongsValue;
    List<Song> playListSongs = this.playListSongs;
    nonPlayListSongs.remove(song);
    playListSongs.add(song);
    _nonPlayListSongs.sink.add(nonPlayListSongs);
    _playListSongs.sink.add(playListSongs);
  }

  savePressedOnEditingScreen(Playlist playlist, String title) async {
    playlist.title = title;
    List<int> playListIds = List();
    for (Song song in playListSongs) {
      playListIds.add(song.id);
    }
    playlist.songs = playListIds;
    int result = await repository.updatePlaylist(playlist);
    print('Update playlist result - $result');
  }

  onFontSizeChanged(double value) {
    _fontSize.sink.add(value);
  }

  saveSettingsPressed() async {
    repository.setPreferredFontSize(fontSizeValue);
  }

  void resetFont() async {
    _fontSize.sink.add(await repository.getPreferredFontSize());
  }

  fetchYoutubeVideoId(String artist, String title) async {
    Observable.fromFuture(repository.getYoutubeResponse(artist, title))
        .map((response) => response.items[0].id.videoId)
        .listen((id) => _youtubeId.sink.add(id),
            onError: (error) => print(error));
  }

  void fetchFontSize() async {
    double fontSize = await repository.getPreferredFontSize();
    _fontSize.sink.add(fontSize);
  }

  void resetYoutubeId() {
    _youtubeId.sink.add(null);
  }

  onSaveEditLyricsTapped(Song song, String newLyrics) async {
    song.setNewLyrics(newLyrics);
    await repository.updateSongById(song);
  }

  Future<String> fetchOriginalLyrics(String artist, String songTitle) async {
    LyricsResponse originalLyrics = await repository.fetchLyrics(artist, songTitle);
    return originalLyrics.lyrics;
  }

  void fetchTheme() {

  }

  changeTheme() {
    _theme.sink.add('Light');
  }
}

final SongBloc bloc = SongBloc();
