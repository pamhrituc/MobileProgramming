import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:exam/Models/item.dart';
import 'package:exam/Repository/db_rep.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class Screen1Rep {
  List<Item> list = new List();
  var logger = Logger();
  List<Item> localList = new List();
  String baseUrl = "http://10.0.2.2:2001/"; //TODO: CHANGE PORT
  Map<String, String> headers = {"Content-type": "application/json"};
  DBRep dbRep = DBRep();

  Future<bool> isConnectedToInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  Future<List<Item>> getAll() async {
    /*
    logger.i("Server: Getting all items");
    bool isInternetAvailable = await isConnectedToInternet();
    if (isInternetAvailable) {
      Response response =
          await get(baseUrl + ''); //TODO: Add appropriate server route
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Item> list = List();
        //dbRep.deleteAllItems();
        for (var elem in body) {
          final item = Item.fromJson(elem);
          //dbRep.addItem(item);
          list.add(item);
        }
        return list;
      } else {
        logger.e("Server: Error in getting items");
      }
    } else {
      //return dbRep.getAllItems();
      return List();
    }*/
  }

  Future<dynamic> addItem(Item item) async {
    /*
    logger.i("Server: adding item to server");
    Response response =
        await post(baseUrl + '', //TODO: Add appropriate server route
            headers: headers,
            body: json.encode(item.toJson()));
    if (response.statusCode == 200) {
      dynamic body = json.decode(response.body);
      Item itemNew = new Item.fromJson(body);
      //dbRep.addItem(itemNew);
      logger.i("Server: added item to server");
      return itemNew;
    } else {
      String error = json.decode(response.body)["text"];
      logger.e("Server: error on adding $error");
      return error;
    }*/
  }

  Future<String> deleteItem(Item item) async {
    /*
    logger.i("Server: Deleting item");
    String urlToAccess =
        baseUrl + '/' + item.id.toString(); //TODO: Add appropriate server route
    Response response = await delete(urlToAccess);
    if (response.statusCode == 200) {
      //await dbRep.delete(item);
      logger.i("Server: deleted item w/ id ${item.id.toString()}");
      return "Success";
    } else {
      var error = json.decode(response.body)["text"];
      logger.e("Server: couldn't delete. Error: $error");
      return error;
    }*/
  }

  Future<String> updateItem(Item oldItem, Item newItem) async {
    logger.i("Rep: Updating Item");
    list.remove(oldItem);
    list.add(newItem); //TODO: error here too
    return "yoink";
  }
}
