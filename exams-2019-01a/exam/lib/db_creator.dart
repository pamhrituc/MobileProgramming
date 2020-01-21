import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

Database db;

class DBCreator {
  static const reservedTable = 'reserved';
  static const reservedId = 'reservedId';
  static const phoneTable = 'phone';
  static const id = 'id';
  static const String name = 'name';
  static const String size = 'size';
  static const String manufacturer = 'manufacturer';
  static const String quantity = 'quantity';
  static const String reserved = 'reserved';

  Future<void> createTable(Database db) async {
    final createSql = '''CREATE TABLE $phoneTable
    (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $name VARCHAR(64),
      $size INTEGER,
      $manufacturer VARCHAR(64),
      $quantity INTEGER,
      $reserved INTEGER
    )''';
    await db.execute(createSql);
  }

  Future<void> createReservedTable(Database db) async {
    final createSql = '''CREATE TABLE $reservedTable
    (
      $reservedId INTEGER PRIMARY KEY AUTOINCREMENT,
      $id INTEGER,
      $name VARCHAR(64),
      $size INTEGER,
      $manufacturer VARCHAR(64)
    )''';
    await db.execute(createSql);
  }

  Future<String> getDBPath(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    if (await Directory(dirname(path)).exists()) {
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initDB() async {
    final path = await getDBPath('phone_db');
    db = await openDatabase(path, version: 1, onCreate: onCreate);
    print(db);
  }

  Future<void> onCreate(Database db, int version) async {
    await createTable(db);
    await createReservedTable(db);
  }
}
