import 'package:lyrics_pal/models/playlist.dart';

abstract class PlaylistStore {
  Future<int> savePlaylist(Playlist playlist);
  Future<List<Playlist>> fetchAllPlaylists();
}