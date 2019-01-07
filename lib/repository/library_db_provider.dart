import 'package:lyrics_pal/models/library_store.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dart:async';
import '../models/song.dart';

class LibraryDbProvider implements LibraryStore {
  Database _db;
  final String table = "Library";

  Future<Database> get db async {
    if (_db == null) {
      _db = await init();
    }

    return _db;
  }

  Future<Database> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'library.db');

    var db;
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

    return db;
  }

  @override
  Future<int> saveTrackToLibrary(Song song) async {
    var dbClient = await db;
    int res = await dbClient.insert(table, song.toMap());

    return res;
  }

  @override
  Future<List<Song>> fetchAllSongs() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $table");
    List<Song> songList = result.map((song) => Song.fromJson(song)).toList();

    return songList;
  }

  @override
  Future<Song> fetchSongById(int id) async {
    var dbClient = await db;
    var result = await dbClient.query(table, where: 'id = ?', whereArgs: [id]);

    if (result.length > 0) {
      return Song.fromJson(result.first);
    }
  }

  @override
  Future<Song> fetchSongByArtistAndTitle(String artist, String title) async {
    var dbClient = await db;
    var result = await dbClient.query(table,
        where: 'artist = ? AND song = ?', whereArgs: [artist, title]);

    if (result.length > 0) {
      return Song.fromJson(result.first);
    } else {
      return null;
    }
  }

  @override
  Future<int> deleteSongById(int id) async {
    var dbClient = await db;
    var result = await dbClient.delete(table, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  @override
  Future<int> updateSongById(Song song) async {
    var dbClient = await db;
    var result = await dbClient
        .update(table, song.toMap(), where: 'id = ?', whereArgs: [song.id]);
    return result;
  }
}

final libraryDb = LibraryDbProvider();
