import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SQLiteProvider {
  static final SQLiteProvider db = SQLiteProvider._();
  static Database _database;

  SQLiteProvider._();

  Future<Database> get database async {
    if (_database != null)
      return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Tiny_Release.db");
    return await openDatabase(path, version: 2, onOpen: (db) {
    }, onCreate: (Database db, int version) async {

      await db.execute("CREATE TABLE Reception_area ("
          "id INTEGER PRIMARY KEY,"
          "displayName TEXT"
          ")");

      await db.execute("CREATE TABLE Preset ("
          "id INTEGER PRIMARY KEY,"
          "displayName TEXT,"
          "title TEXT,"
          "subtitle TEXT,"
          "language TEXT,"
          "description TEXT"
          ")");

      await db.execute("CREATE TABLE Paragraph ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "content TEXT,"
          "position INTEGER,"
          "presetId INTEGER,"
          "FOREIGN KEY (presetId) REFERENCES Preset (id)"
            "ON DELETE NO ACTION ON UPDATE NO ACTION"
          ")");
    });
  }
}