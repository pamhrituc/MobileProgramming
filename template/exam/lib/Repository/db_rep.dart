import 'package:exam/Models/item.dart';
import 'package:exam/db_creator.dart';
import 'package:logger/logger.dart';

//TODO: edit field after item appropriately

class DBRep {
  var logger = Logger();

  Future<Item> addItem(Item item) async {
    final sql = '''INSERT INTO ${DBCreator.itemTable} 
    (
      ${DBCreator.id},
      ${DBCreator.name},
    ${DBCreator.desc},
    ${DBCreator.size}
    )
    VALUES
    (
      ${item.id},
      "${item.name}",
      "${item.desc}",
      ${item.size}
    )
    ''';
    try {
      await db.rawInsert(sql);
      logger.i("DB: added ${item.id.toString()}");
    } catch (e) {}
    return item;
  }

  Future<List<Item>> getAllItems() async {
    final sql = '''SELECT * FROM ${DBCreator.itemTable}''';
    final data = await db.rawQuery(sql);
    List<Item> list = List();
    for (var elem in data) {
      Item item = Item.fromJson(elem);
      list.add(item);
    }
    logger.i("DB: get All items");
    return list;
  }

  Future<void> updateItem(Item oldItem, Item newItem) async {
    final sql = '''UPDATE ${DBCreator.itemTable}
    SET ${DBCreator.name} = "${newItem.name}",
    ${DBCreator.desc} = "${newItem.desc}",
    ${DBCreator.size} = ${newItem.size}
    WHERE ${DBCreator.id} = ${oldItem.id}''';

    await db.rawUpdate(sql);
    logger.i("DB: update");
  }

  Future<void> deleteItem(Item item) async {
    final sql =
        '''DELETE FROM ${DBCreator.itemTable} WHERE ${DBCreator.id} = ${item.id}''';
    await db.rawDelete(sql);
    logger.i("DB: deleted ${item.id.toString()}");
  }

  Future<void> deleteAllItems() async {
    final sql = '''DELETE FROM ${DBCreator.itemTable}''';
    await db.rawDelete(sql);
    logger.i("DB: deleted all items");
  }

  /*______________________________________________*/

  Future<String> add(String name) async {
    final sql = '''INSERT INTO ${DBCreator.subTable} 
    (${DBCreator.name})
    VALUES
    ("$name")
    ''';
    try {
      await db.rawInsert(sql);
      logger.i("DB: added $name");
    } catch (e) {}
    return name;
  }

  Future<List<String>> getAll() async {
    final sql = '''SELECT * FROM ${DBCreator.subTable}''';
    final data = await db.rawQuery(sql);
    List<String> list = List();
    for (var elem in data) {
      list.add(elem["name"]);
    }
    logger.i("DB: get all");
    return list;
  }

  Future<void> delete(String name) async {
    final sql =
        '''DELETE FROM ${DBCreator.subTable} WHERE ${DBCreator.name} = $name''';
    await db.rawDelete(sql);
    logger.i("DB: deleted $name");
  }

  Future<void> deleteAll() async {
    final sql = '''DELETE FROM ${DBCreator.subTable}''';
    await db.rawDelete(sql);
    logger.i("DB: deleted all types");
  }
}
