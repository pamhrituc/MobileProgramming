import 'package:app/message.dart';
import 'package:app/server_rep.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class CrudProvider extends ChangeNotifier {
  var logger = Logger();
  List<String> localUsers = new List();
  ServerRep messagesRep = new ServerRep();
  bool isOnline = true;

  Future<List<Message>> getMessages() async {
    List<Message> messagesList = await messagesRep.getAllMessagesFromServer();
    messagesList.sort((a, b) => a.date.compareTo(b.date));
    //messagesList.reversed.forEach((f) => print(f.toJson()));
    List<Message> displayedMessages = new List<Message>();
    for (Message message in messagesList.reversed) {
      displayedMessages.add(message);
      if (displayedMessages.length == 10) {
        break;
      }
    }
    logger.i("CRUD Provider: Messages have been retrieved");
    return displayedMessages;
  }

  Future<List<String>> getUsers() async {
    List<String> usersList = await messagesRep.getAllUsersFromServer();
    usersList.forEach((f) => print(f));
    usersList.sort((a, b) => a.compareTo(b));
    logger.i("CRUD Provider: Users have been retrieved");
    return usersList;
  }

  Future<List<Message>> getSent(String user) async {
    List<Message> messagesList = await messagesRep.getAllSentFromServer(user);
    messagesList.sort((a, b) => a.date.compareTo(b.date));
    List<Message> reversedList = messagesList.reversed.toList();
    logger
        .i("CRUD Provider: Sent messages of " + user + " have been retrieved");
    return reversedList;
  }

  Future<List<Message>> getReceived(String user) async {
    List<Message> messagesList =
        await messagesRep.getAllReceivedFromServer(user);
    messagesList.sort((a, b) => a.date.compareTo(b.date));
    List<Message> reversedList = messagesList.reversed.toList();
    logger.i("CRUD Provider: Retreived messages of " +
        user +
        " have been retrieved");
    return reversedList;
  }

  Future<List<Message>> getPrivate(String user) async {
    List<Message> messagesList =
        await messagesRep.getAllPrivateFromServer(user);
    messagesList.sort((a, b) => a.date.compareTo(b.date));
    List<Message> reversedList = messagesList.reversed.toList();
    logger.i(
        "CRUD Provider: Private messages of " + user + " have been retrieved");
    return reversedList;
  }

  void modifyOnlineStatus(bool flag) {
    isOnline = flag;
    logger.i(
        "CRUD Provider: Onlie status has been modified to " + flag.toString());
    notifyListeners();
  }

  void addMessage(Message message) {
    messagesRep.addMessage(message).whenComplete(() {
      logger.i("CRUD Provider: Message " + message.text + " has been added");
      notifyListeners();
    });
  }

  void deleteMessage(Message message) {
    messagesRep.deleteMessageFromServer(message).whenComplete(() {
      logger.i("CRUD Provider: Message " + message.text + " has been deleted");
      notifyListeners();
    });
  }

  void saveUser(String user) {
    for (String userThere in localUsers) {
      if (userThere == user) {
        logger.d("Can't add user");
      }
    }
    logger.i("Added user locally");
    localUsers.add(user);
  }
}
