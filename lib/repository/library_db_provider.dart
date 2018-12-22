import 'package:lyrics_pal/models/library_store.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dart:async';
import '../models/song.dart';

class LibraryDbProvider implements LibraryStore {
  Database db;
  final String table = "Library";

  void init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'library.db');

    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) {
          newDb.execute("""
          CREATE TABLE $table
          (
            id INTEGER PRIMARY KEY,
            artist TEXT,
            song TEXT,
            image TEXT,
            lyrics TEXT
          )
        """);
        });
  }

  @override
  Future<int> saveTrackToLibrary(Song song) async {
    int res = await db.insert(table, song.toMap());

    return res;
  }

  @override
  Future<List<Song>> fetchAllSongs() async {
    var result = await db.rawQuery("SELECT * FROM $table");
    List<Song> songList = result.map((song) => Song.fromJson(song)).toList();

    return songList;
  }

  @override
  Future<Song> fetchSongById(int id) async {
    var result = await db.query(table, where: 'id = ?', whereArgs: [id]);

    if (result.length > 0) {
      return Song.fromJson(result.first);
    }
  }

  @override
  Future<Song> fetchSongByArtistAndTitle(String artist, String title) async {
  var result = await db.query(table, where: 'artist = ? AND song = ?', whereArgs: [artist, title]);

    if (result.length > 0) {
      return Song.fromJson(result.first);
    } else {
      return null;
    }
  }

  @override
  Future<int> deleteSongById(int id) async {
    var result = await db.delete(table, where: 'id = ?', whereArgs: [id]);
    return result;
  }

}

final libraryDb = LibraryDbProvider();
