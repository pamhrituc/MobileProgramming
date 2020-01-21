import 'dart:async';
import 'package:exam/Models/item.dart';
import 'package:exam/Repository/screen1_rep.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Screen1Provider extends ChangeNotifier {
  Screen1Rep rep = Screen1Rep();
  bool isOnline = true;
  bool modified = true;

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
}
