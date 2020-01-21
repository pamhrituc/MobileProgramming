import 'dart:async';
import 'package:exam/Models/item.dart';
import 'package:exam/Repository/screen2_rep.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Screen2Provider extends ChangeNotifier {
  Screen2Rep rep = Screen2Rep();
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
