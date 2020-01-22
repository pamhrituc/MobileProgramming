import 'dart:async';
import 'package:exam/Models/item.dart';
import 'package:exam/Repository/screen1_rep.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Screen1Provider extends ChangeNotifier {
  var logger = Logger();
  Screen1Rep rep = Screen1Rep();
  bool isOnline = true;
  bool modified = true;
  bool fromServer = true;

  Future<List<Item>> getItems() async {
    return rep.getAll();
  }

  void changeModified() {
    modified = true;
  }

  void changeInternetStatus(bool userIsOnline) {
    isOnline = userIsOnline;
    notifyListeners();
  }

  Future<String> deleteItem(Item item) async {
    String response = await rep.deleteItem(item);
    notifyListeners();
    return response;
  }

  Future<dynamic> addItem(Item item) async {
    dynamic added = await rep.addItem(item);
    notifyListeners();
    return added;
  }

  void refresh() {
    fromServer = true;
    notifyListeners();
  }
}
