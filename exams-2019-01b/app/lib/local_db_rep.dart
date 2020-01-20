import 'package:app/db_creator.dart';
import 'package:app/message.dart';
import 'package:logger/logger.dart';

class LocalDBRep {
  var logger = Logger();

  Future<List<Message>> getAll() async {
    final sql = '''SELECT * FROM ${DBCreator.messageTable}''';
    final data = await db.rawQuery(sql);
    List<Message> messageList = List();
    for (var elem in data) {
      final message = Message.fromJson(elem);
      print(message.toJson());
      messageList.add(message);
      print(messageList);
    }
    logger.i("LocalDBRep: getAll");
    return messageList;
  }

  Future<List<Message>> getPrivateOfUser(String user) async {
    final sql =
        '''SELECT * FROM ${DBCreator.messageTable} WHERE ${DBCreator.type} = "private" AND (${DBCreator.sender} = $user OR ${DBCreator.receiver} = $user''';
    final data = await db.rawQuery(sql);
    List<Message> messageList = List();
    for (var elem in data) {
      final message = Message.fromJson(elem);
      print(message.toJson());
      messageList.add(message);
      print(messageList);
    }
    logger.i("LocalDBRep: getPrivateOfUser " + user);
    return messageList;
  }

  Future<int> getLastId() async {
    final sql = '''SELECT last_insert_rowid()''';
    final data = await db.rawQuery(sql);
    logger.i("LocalDBRep: getLastId");
    return data[0].values.elementAt(0);
  }

  Future<Message> add(Message message) async {
    final sql = '''INSERT INTO ${DBCreator.messageTable} 
    (
      ${DBCreator.sender},
    ${DBCreator.receiver},
    ${DBCreator.text},
    ${DBCreator.date},
    ${DBCreator.type}
    )
    VALUES
    (
      "${message.sender}",
    "${message.receiver}",
    "${message.text}",
    ${message.date},
    "${message.type}"
    )
    ''';
    final result = await db.rawInsert(sql);
    print(result);
    int last_inserted_id = await getLastId();
    message.setId(last_inserted_id);
    logger.i("LocalDBRep: add message: " + message.text);
    return message;
  }

  Future<void> delete(Message message) async {
    final sql =
        '''DELETE FROM ${DBCreator.messageTable} WHERE ${DBCreator.id} = ${message.id}''';
    await db.rawDelete(sql);
    logger.i("LocalDBRep: delete: " + message.text);
  }

  Future<void> update(Message oldMessage, Message newMessage) async {
    final sql = '''UPDATE ${DBCreator.messageTable}
    SET ${DBCreator.sender} = "${newMessage.sender}",
    ${DBCreator.receiver} = "${newMessage.receiver}",
    ${DBCreator.text} = "${newMessage.text}",
    ${DBCreator.date} = ${newMessage.date},
    ${DBCreator.type} = "${newMessage.type}",
    WHERE ${DBCreator.id} = ${oldMessage.id}''';

    await db.rawUpdate(sql);
    logger.i("LocalDBRep: update");
  }

  Future<Message> findByID(int id) async {
    final sql =
        '''SELECT * FROM ${DBCreator.messageTable} WHERE ${DBCreator.id} = $id''';
    final result = await db.rawQuery(sql);
    Message message = Message.fromJson(result[0].values.elementAt(0));
    logger.i("LocalDBRep: findByID");
    return message;
  }

  Future<int> size() async {
    final sql = '''SELECT COUNT(*) from ${DBCreator.messageTable}''';
    final result = await db.rawQuery(sql);
    logger.i("LocalDBRep: size");
    return result[0].values.elementAt(0);
  }
}
