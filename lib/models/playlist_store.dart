import 'package:lyrics_pal/models/playlist.dart';

abstract class PlaylistStore {
  Future<int> savePlaylist(Playlist playlist);
  Future<List<Playlist>> fetchAllPlaylists();
  Future<int> updatePlaylist(Playlist playlist);
  Future<int> deletePlaylist(int playListId);
  Future<Playlist> fetchPlaylistById(int id);
}