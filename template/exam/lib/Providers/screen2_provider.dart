import 'dart:async';
import 'package:exam/Repository/screen2_rep.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Screen2Provider extends ChangeNotifier {
  var logger = Logger();
  Screen2Rep rep = Screen2Rep();
  bool isOnline = true;
  bool modified = true;
  bool fromServer = true;

  Future<List<String>> getItems() async {
    logger.i("Provider: Retreiving...");
    return rep.getAllNames();
  }

  void changeModified() {
    modified = true;
  }

  void changeInternetStatus(bool userIsOnline) {
    isOnline = userIsOnline;
    notifyListeners();
  }

  Future<String> deleteName(String name) async {
    logger.i("Provider: Deleting...");
    String response = await rep.deleteItem(name);
    notifyListeners();
    return response;
  }

  Future<dynamic> addName(String name) async {
    logger.i("Provider: Adding...");
    dynamic added = await rep.addItem(name);
    notifyListeners();
    return added;
  }

  void refresh() {
    fromServer = true;
    notifyListeners();
  }
}
