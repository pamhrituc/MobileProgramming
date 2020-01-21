import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:exam/Models/item.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class Screen1Rep {
  List<Item> list = new List();
  var logger = Logger();
  List<Item> localList = new List();
  String baseUrl = "http://10.0.2.2:2024/"; //TODO: CHANGE PORT
  Map<String, String> headers = {"Content-type": "application/json"};

  Future<bool> isConnectedToInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  Future<List<Item>> getAll() async {
    bool isInternetAvailable = await isConnectedToInternet();
    if (isInternetAvailable) {
      Response response = await get(baseUrl + 'products');
      print("yolo");
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Item> list = List();
        for (var elem in body) {
          final item = Item.fromJson(elem);
          list.add(item);
        }
        logger.i("Server: Retrieved all");
        return list;
      } else {
        logger.e("Server: Can't retrieve all");
        return [];
      }
    } else {
      logger.i("Server: retrieving from DB");
      return [];
    }
  }

  Future<dynamic> addItem(Item item) async {
    logger.i("Rep: Adding Item");
    list.add(item);

    ///daca e eroare o sa fie de type string
    ///daca e ok o sa fie de type Item
    ///depinde daca serverul trimite sau nu inapoi obiectu
    ///cu idu setat
    return item;
  }

  Future<String> deleteItem(Item item) async {
    logger.i("Rep: Deleting item");
    list.remove(item); //TODO: Change to id & return error message
    return "binch";
  }

  Future<String> updateItem(Item oldItem, Item newItem) async {
    logger.i("Rep: Updating Item");
    list.remove(oldItem);
    list.add(newItem); //TODO: error here too
    return "yoink";
  }
}
