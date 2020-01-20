import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart';
import 'package:app/local_db_rep.dart';
import 'package:app/message.dart';

class ServerRep {
  String baseUrl = "http://10.0.2.2:2101/";
  final List<Message> toPushWhenOnline = new List<Message>();
  Map<String, String> headers = {"Content-type": "application/json"};
  LocalDBRep dbRep = new LocalDBRep();

  Future<bool> isConnectedToInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  Future<List<Message>> getAllMessagesFromServer() async {
    bool isInternetAvailable = await isConnectedToInternet();
    if (isInternetAvailable) {
      await addToServer();
      Response response = await get(baseUrl + 'public');
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Message> messageList = List();
        for (var elem in body) {
          final message = Message.fromJson(elem);
          messageList.add(message);
        }
        return messageList;
      } else {
        throw "Can't get all";
      }
    } else {
      return dbRep.getAll();
    }
  }

  Future<List<String>> getAllUsersFromServer() async {
    bool isInternetAvailable = await isConnectedToInternet();
    if (isInternetAvailable) {
      await addToServer();
      Response response = await get(baseUrl + 'users');
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<String> userList = List();
        for (var elem in body) {
          userList.add(elem);
        }
        return userList;
      } else {
        throw "Can't get all";
      }
    } else {
      throw "Can't get all";
    }
  }

  Future<List<Message>> getAllSentFromServer(String user) async {
    bool isInternetAvailable = await isConnectedToInternet();
    if (isInternetAvailable) {
      await addToServer();
      Response response = await get(baseUrl + 'sender/' + user);
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Message> messageList = List();
        for (var elem in body) {
          final message = Message.fromJson(elem);
          messageList.add(message);
        }
        return messageList;
      } else {
        throw "Can't get all";
      }
    } else {
      throw "Can't get all";
    }
  }

  Future<List<Message>> getAllReceivedFromServer(String user) async {
    bool isInternetAvailable = await isConnectedToInternet();
    if (isInternetAvailable) {
      await addToServer();
      Response response = await get(baseUrl + 'receiver/' + user);
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Message> messageList = List();
        for (var elem in body) {
          final message = Message.fromJson(elem);
          messageList.add(message);
        }
        return messageList;
      } else {
        throw "Can't get all";
      }
    } else {
      throw "Can't get all";
    }
  }

  Future<List<Message>> getAllPrivateFromServer(String user) async {
    bool isInternetAvailable = await isConnectedToInternet();
    if (isInternetAvailable) {
      await addToServer();
      Response response = await get(baseUrl + 'private/' + user);
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Message> messageList = List();
        for (var elem in body) {
          final message = Message.fromJson(elem);
          messageList.add(message);
        }
        return messageList;
      } else {
        throw "Can't get all";
      }
    } else {
      throw dbRep.getPrivateOfUser(user);
    }
  }

  Future<void> addToServer() async {
    for (Message message in toPushWhenOnline) {
      await addMessageToServer(message);
    }
    toPushWhenOnline.clear();
    return null;
  }

  Future<void> addMessageToServer(Message message) async {
    Response response = await post(baseUrl + 'message',
        headers: headers, body: json.encode(message.toJson()));
    if (response.statusCode == 200) {
      dynamic body = json.decode(response.body);
      Message messageNew = new Message.fromJson(body);
      dbRep.update(message, messageNew);
    }
  }

  Future<void> deleteMessageFromServer(Message message) async {
    String urlToAccess = baseUrl + 'message' + "/" + message.id.toString();
    Response response = await delete(urlToAccess);
    if (response.statusCode == 200) {
      await dbRep.delete(message);
    }
  }

  Future<void> addMessage(Message message) async {
    bool isInternetAvailable = await isConnectedToInternet();
    Message newMessage = await dbRep.add(message);
    toPushWhenOnline.add(newMessage);
    print(newMessage.toJson());
    if (isInternetAvailable) {
      await addToServer();
    }
  }
}
