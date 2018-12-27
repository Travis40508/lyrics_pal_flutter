import 'package:lyrics_pal/models/library_store.dart';
import 'package:lyrics_pal/models/lyrics_response.dart';
import 'package:lyrics_pal/models/lyrics_source.dart';
import 'package:lyrics_pal/models/playlist.dart';
import 'package:lyrics_pal/models/playlist_store.dart';
import 'package:lyrics_pal/models/preferences_store.dart';
import 'package:lyrics_pal/models/search_source.dart';
import 'package:lyrics_pal/models/song.dart';
import 'package:lyrics_pal/models/youtube_response.dart';
import 'package:lyrics_pal/models/youtube_source.dart';
import 'package:lyrics_pal/repository/lyrics_api.dart';
import 'package:lyrics_pal/repository/youtube_api.dart';
import 'library_db_provider.dart';
import 'playlists_db_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'search_api.dart';
import '../models/search_response.dart';

class Repository implements SearchSource, LyricsSource, LibraryStore, PlaylistStore, PreferencesStore, YoutubeSource {

  final searchApi = SearchApi();
  final lyricsApi = LyricsApi();
  final youtubeApi = YoutubeApi();

  Repository() {
    libraryDb.init();
  }

  @override
  Future<SearchResponse> fetchSongs(String query) async {
    SearchResponse searchResults = await searchApi.fetchSongs(query);
    return searchResults;
  }

  @override
  Future<LyricsResponse> fetchLyrics(String artistName, String songTitle) async {
    LyricsResponse lyricsResponse = await lyricsApi.fetchLyrics(artistName, songTitle);
    return lyricsResponse;
  }

  @override
  Future<int> saveTrackToLibrary(Song song) async {
    return libraryDb.saveTrackToLibrary(song);
  }

  @override
  Future<List<Song>> fetchAllSongs() async {
    List<Song> allSongs = await libraryDb.fetchAllSongs();
    allSongs.sort((a, b) => a.getSongTitle().toUpperCase().compareTo(b.getSongTitle().toUpperCase()));
    return allSongs;
  }

  @override
  Future<List<Playlist>> fetchAllPlaylists() async {
    List<Playlist> playlists = await playlistDb.fetchAllPlaylists();
    return playlists;
  }

  @override
  Future<int> savePlaylist(Playlist playlist) async {
    return playlistDb.savePlaylist(playlist);
  }

  @override
  Future<Song> fetchSongById(int id) async {
    Song song = await libraryDb.fetchSongById(id);
    return song;
  }

  @override
  Future<Song> fetchSongByArtistAndTitle(String artist, String title) async {
    Song song = await libraryDb.fetchSongByArtistAndTitle(artist, title);
    return song;
  }

  @override
  Future<int> deleteSongById(int id) async {
    int success = await libraryDb.deleteSongById(id);
    return success;
  }

  @override
  Future<int> deletePlaylist(int playListId) async {
    int result = await playlistDb.deletePlaylist(playListId);
    return result;
  }

  @override
  Future<int> updatePlaylist(Playlist playlist) async {
    int result = await playlistDb.updatePlaylist(playlist);

    return result;
  }

  @override
  Future<double> getPreferredFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double size = prefs.getDouble('fontSize');
    return size;
  }

  @override
  setPreferredFontSize(double value) async {
    double currentFontSize = await getPreferredFontSize();
    if(value != currentFontSize) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble('fontSize', value);
    }
  }

  @override
  Future<YoutubeResponse> getYoutubeResponse(String artist, String title) async {
    YoutubeResponse youtubeResponse = await youtubeApi.getYoutubeResponse(artist, title);
    return youtubeResponse;
  }

  @override
  Future<int> updateSongById(Song song) async {
    int result = await libraryDb.updateSongById(song);
    print('Update result - $result');
    return result;
  }

  @override
  Future<bool> getPreferredTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLightTheme = prefs.getBool('theme');
    return isLightTheme;
  }

  @override
  setPreferredTheme(bool value) async {
    bool currentTheme = await getPreferredTheme();
    if (value != currentTheme) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('theme', value);
    }
  }
}