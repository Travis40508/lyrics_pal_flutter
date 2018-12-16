import 'package:lyrics_pal/models/song.dart';

abstract class LibraryStore {
  Future<int> saveTrackToLibrary(Song song);
  Future<List<Song>> fetchAllSongs();
}