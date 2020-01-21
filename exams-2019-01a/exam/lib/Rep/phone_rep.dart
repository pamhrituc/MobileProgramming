import 'package:exam/Models/phone.dart';
import 'package:exam/db_creator.dart';
import 'package:logger/logger.dart';

class DBRep {
  var logger = Logger();

  Future<List<Phone>> getAll() async {
    final sql = '''SELECT * FROM ${DBCreator.phoneTable}''';
    final data = await db.rawQuery(sql);
    List<Phone> phoneList = List();
    for (var elem in data) {
      final phone = Phone.fromJson(elem);
      //print(phone.toJson());
      phoneList.add(phone);
      print(phoneList);
    }
    logger.i("DB: getAll");
    return phoneList;
  }

  Future<int> getLastId() async {
    final sql = '''SELECT last_insert_rowid()''';
    final data = await db.rawQuery(sql);
    logger.i("DB: getLastId");
    return data[0].values.elementAt(0);
  }

  Future<Phone> add(Phone phone) async {
    final sql = '''INSERT INTO ${DBCreator.phoneTable} 
    (
      ${DBCreator.name},
    ${DBCreator.size},
    ${DBCreator.manufacturer},
    ${DBCreator.quantity},
    ${DBCreator.reserved}
    )
    VALUES
    (
      "${phone.name}",
    ${phone.size},
    "${phone.manufacturer}",
    ${phone.quantity},
    ${phone.reserved}
    )
    ''';
    final result = await db.rawInsert(sql);
    print(result);
    int last_inserted_id = await getLastId();
    phone.setId(last_inserted_id);
    logger.i("DB: added " + phone.id.toString());
    return phone;
  }

  Future<void> delete(Phone phone) async {
    final sql =
        '''DELETE FROM ${DBCreator.phoneTable} WHERE ${DBCreator.id} = ${phone.id}''';
    await db.rawDelete(sql);
    logger.i("DB: deleted " + phone.id.toString());
  }

  Future<void> update(Phone oldPhone, Phone newPhone) async {
    final sql = '''UPDATE ${DBCreator.phoneTable}
    SET ${DBCreator.name} = "${newPhone.name}",
    ${DBCreator.size} = ${newPhone.size},
    ${DBCreator.manufacturer} = "${newPhone.manufacturer}",
    ${DBCreator.quantity} = ${newPhone.quantity},
    ${DBCreator.reserved} = ${newPhone.reserved}
    WHERE ${DBCreator.id} = ${oldPhone.id}''';

    await db.rawUpdate(sql);
    logger.i("DB: update");
  }

  Future<Phone> findByID(int id) async {
    final sql =
        '''SELECT * FROM ${DBCreator.phoneTable} WHERE ${DBCreator.id} = $id''';
    final result = await db.rawQuery(sql);
    Phone phone = Phone.fromJson(result[0].values.elementAt(0));
    logger.i("DB: findByID " + id.toString());
    return phone;
  }

  Future<int> size() async {
    final sql = '''SELECT COUNT(*) from ${DBCreator.phoneTable}''';
    final result = await db.rawQuery(sql);
    logger.i("DB: size");
    return result[0].values.elementAt(0);
  }

  Future<Phone> reserve(Phone phone) async {
    final sql = '''INSERT INTO ${DBCreator.reservedTable} 
    (
      ${DBCreator.id},
      ${DBCreator.name},
    ${DBCreator.size},
    ${DBCreator.manufacturer}
    )
    VALUES
    (
      ${phone.id},
      "${phone.name}",
    ${phone.size},
    "${phone.manufacturer}"
    )
    ''';
    final result = await db.rawInsert(sql);
    print(result);
    logger.i("DB: reserved " + phone.id.toString());
    return phone;
  }

  Future<List<Phone>> getReservedPhones() async {
    final sql = '''SELECT * FROM ${DBCreator.reservedTable}''';
    final data = await db.rawQuery(sql);
    List<Phone> phoneList = List();
    for (var elem in data) {
      final phone = Phone.fromJson(elem);
      //print(phone.toJson());
      phoneList.add(phone);
      print(phoneList);
    }
    logger.i("DB: getReserved");
    return phoneList;
  }
}
