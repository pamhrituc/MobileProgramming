import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

Database db;

class DBCreator {
  static const itemTable = 'itemTable';
  static const subTable = 'subTable';
  static const id = 'id';
  static const String name = 'name';
  static const String desc = 'desc';
  static const String size = 'size';

  Future<void> createItemTable(Database db) async {
    //TODO: Edit table for item
    final createSql = '''CREATE TABLE $itemTable 
    (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $name VARCHAR(64),
      $desc VARCHAR(128),
      $size INTEGER
    )''';
    await db.execute(createSql);
  }

  Future<void> createTable(Database db) async {
    //TODO: edit table for part of item
    final createSql = '''CREATE TABLE $subTable
    (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $name VARCHAR(64)
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
    await createItemTable(db);
    await createTable(db);
  }
}
