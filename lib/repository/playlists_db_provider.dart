import 'package:lyrics_pal/models/playlist_store.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dart:async';
import '../models/playlist.dart';

class PlaylistsDbProvider implements PlaylistStore {
  Database _db;
  final String table = "Playlists";

  Future<Database> get db async {
    if (_db == null) {
      _db = await init();
    }

    return _db;
  }

    Future<Database> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'playlists.db');

    var db;
    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) {
          newDb.execute("""
          CREATE TABLE $table
          (
            id INTEGER PRIMARY KEY,
            title TEXT,
            songs BLOB
          )
        """);
        });

    return db;
  }

  @override
  Future<int> savePlaylist(Playlist playlist) async {
    var dbClient = await db;
    int res = await dbClient.insert(table, playlist.toMap());

    return res;
  }

  @override
  Future<List<Playlist>> fetchAllPlaylists() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $table");
    List<Playlist> playlists = result.map((playlist) => Playlist.fromJson(playlist)).toList();

    return playlists;
  }

  //TODO get these to actually work

  @override
  Future<int> updatePlaylist(Playlist playlist) async {
    var dbClient = await db;

    var result = await dbClient.update(table, playlist.toMap(), where: 'id = ?', whereArgs: [playlist.id]);
    return result;
  }

  @override
  Future<int> deletePlaylist(int playListId) async {
    var dbClient = await db;

    var result = await dbClient.delete(table, where: 'id = ?', whereArgs: [playListId]);
    return result;
  }

  @override
  Future<Playlist> fetchPlaylistById(int id) async {
    var dbClient = await db;

    var result = await dbClient.query(table, where: 'id = ?', whereArgs: [id]);

    if (result.length > 0) {
      return Playlist.fromJson(result.first);
    }
  }


}

final playlistDb = PlaylistsDbProvider();