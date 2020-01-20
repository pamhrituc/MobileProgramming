import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

Database db;

class DBCreator {
  static const userTable = 'user';
  static const messageTable = 'message';
  static const id = 'id';
  static const String sender = 'sender';
  static const String receiver = 'receiver';
  static const String text = 'text';
  static const String date = 'date';
  static const String type = 'type';
  static const String user = 'user';

  Future<void> createTable(Database db) async {
    final createSql = '''CREATE TABLE $messageTable
    (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $sender VARCHAR(64),
      $receiver VARCHAR(64),
      $text VARCHAR(150),
      $date INTEGER,
      $type VARCHAR(64)
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
    final path = await getDBPath('message_db');
    db = await openDatabase(path, version: 1, onCreate: onCreate);
    print(db);
  }

  Future<void> onCreate(Database db, int version) async {
    await createTable(db);
  }
}
