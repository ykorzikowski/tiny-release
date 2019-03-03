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

      /// Settings
      await db.execute("CREATE TABLE Settings ("
          "id INTEGER PRIMARY KEY,"
          "key TEXT,"
          "value INTEGER,"
          "contractId INTEGER"
          ")");

      /// ReceptionArea 2 Contract Releations
      await db.execute("CREATE TABLE Reception_area_to_contract ("
          "id INTEGER PRIMARY KEY,"
          "contractId INTEGER,"
          "receptionId INTEGER,"
          "FOREIGN KEY (contractId) REFERENCES Contract (id)"
          "ON DELETE CASCADE ON UPDATE NO ACTION,"
          "FOREIGN KEY (receptionId) REFERENCES Reception_area (id)"
          "ON DELETE CASCADE ON UPDATE NO ACTION"
          ")");

      /// Signature
      await db.execute("CREATE TABLE Signature ("
          "id INTEGER PRIMARY KEY,"
          "path TEXT,"
          "type INTEGER,"
          "contractId INTEGER"
          ")");

      /// Contracts
      await db.execute("CREATE TABLE Contract ("
          "id INTEGER PRIMARY KEY,"
          "displayName TEXT,"
          "location TEXT,"
          "date TEXT,"
          "locked_ INTEGER,"
          "imagesCount INTEGER,"
          "presetId INTEGER,"
          "photographerId INTEGER,"
          "modelId INTEGER,"
          "parentId INTEGER,"
          "witnessId INTEGER,"
          "selectedModelAddressId INTEGER,"
          "selectedPhotographerAddressId INTEGER,"
          "selectedParentAddressId INTEGER,"
          "selectedWitnessAddressId INTEGER"
          ")");

      /// Layout
      await db.execute("CREATE TABLE Layout ("
          "id INTEGER PRIMARY KEY,"
          "displayName TEXT"
          ")");

      /// Reception area
      await db.execute("CREATE TABLE Reception_area ("
          "id INTEGER PRIMARY KEY,"
          "displayName TEXT"
          ")");

      /// Preset
      await db.execute("CREATE TABLE Preset ("
          "id INTEGER PRIMARY KEY,"
          "isManualEdited INTEGER,"
          "displayName TEXT,"
          "title TEXT,"
          "subtitle TEXT,"
          "language TEXT,"
          "description TEXT"
          ")");

      /// Paragraph
      await db.execute("CREATE TABLE Paragraph ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "content TEXT,"
          "position INTEGER,"
          "presetId INTEGER,"
          "FOREIGN KEY (presetId) REFERENCES Preset (id)"
            "ON DELETE CASCADE ON UPDATE NO ACTION"
          ")");

      /// People
      await db.execute("CREATE TABLE People ("
          "id INTEGER PRIMARY KEY,"
          "displayName TEXT,"
          "avatar TEXT,"
          "identifier TEXT,"
          "givenName TEXT,"
          "middleName TEXT,"
          "prefix TEXT,"
          "suffix TEXT,"
          "familyName TEXT,"
          "birthday TEXT,"
          "company TEXT,"
          "jobTitle TEXT,"
          "idType TEXT,"
          "idNumber TEXT,"
          "position INTEGER"
          ")");

      /// Email & Phone
      await db.execute("CREATE TABLE PeopleItem ("
          "id INTEGER PRIMARY KEY,"
          "label TEXT,"
          "value TEXT,"
          "type INTEGER,"
          "peopleId INTEGER,"
          "FOREIGN KEY (peopleId) REFERENCES People (id)"
          "ON DELETE CASCADE ON UPDATE NO ACTION"
          ")");

      /// postal address
      await db.execute("CREATE TABLE PeopleAddress ("
          "id INTEGER PRIMARY KEY,"
          "label TEXT,"
          "street TEXT,"
          "city TEXT,"
          "postcode TEXT,"
          "region TEXT,"
          "country TEXT,"
          "peopleId INTEGER,"
          "FOREIGN KEY (peopleId) REFERENCES People (id)"
          "ON DELETE CASCADE ON UPDATE NO ACTION"
          ")");
    });
  }
}