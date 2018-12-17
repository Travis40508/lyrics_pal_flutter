import 'package:lyrics_pal/models/playlist_store.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dart:async';
import '../models/playlist.dart';

class PlaylistsDbProvider implements PlaylistStore {
  Database db;
  final String table = "Playlists";

  void init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'playlists.db');

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
  }

  @override
  Future<int> savePlaylist(Playlist playlist) async {
    int res = await db.insert(table, playlist.toMap());

    return res;
  }

  @override
  Future<List<Playlist>> fetchAllPlaylists() async {
    var result = await db.rawQuery("SELECT * FROM $table");
    List<Playlist> playlists = result.map((playlist) => Playlist.fromJson(playlist)).toList();

    return playlists;
  }

}

final playlistDb = PlaylistsDbProvider();