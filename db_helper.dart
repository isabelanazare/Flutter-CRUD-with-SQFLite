import 'package:flutter_app/TVSeries.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'tvSeries.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute('CREATE TABLE tvSeries (id INTEGER PRIMARY KEY, title TEXT, description TEXT, rating TEXT)');
  }

  Future<TVSeries> add(TVSeries series) async {
    var dbClient = await db;
    series.id = await dbClient.insert('tvSeries', series.toMap());
    return series;
  }

  Future<List<TVSeries>> getSeries() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('tvSeries', columns: ['id', 'title','description','rating']);
    List<TVSeries> series = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        series.add(TVSeries.fromMap(maps[i]));
      }
    }
    return series;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'tvSeries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(TVSeries series) async {
    var dbClient = await db;
    return await dbClient.update(
      'tvSeries',
      series.toMap(),
      where: 'id = ?',
      whereArgs: [series.id],
    );
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}