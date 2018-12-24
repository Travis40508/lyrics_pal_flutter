import 'package:lyrics_pal/models/library_store.dart';
import 'package:lyrics_pal/models/lyrics_response.dart';
import 'package:lyrics_pal/models/lyrics_source.dart';
import 'package:lyrics_pal/models/playlist.dart';
import 'package:lyrics_pal/models/playlist_store.dart';
import 'package:lyrics_pal/models/search_source.dart';
import 'package:lyrics_pal/models/song.dart';
import 'package:lyrics_pal/repository/lyrics_api.dart';
import 'library_db_provider.dart';
import 'playlists_db_provider.dart';

import 'search_api.dart';
import '../models/search_response.dart';

class Repository implements SearchSource, LyricsSource, LibraryStore, PlaylistStore {

  final searchApi = SearchApi();
  final lyricsApi = LyricsApi();

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
}