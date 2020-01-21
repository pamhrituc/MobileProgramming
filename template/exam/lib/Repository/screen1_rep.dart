import 'package:connectivity/connectivity.dart';
import 'package:exam/Models/item.dart';
import 'package:logger/logger.dart';

class Screen1Rep {
  List<Item> list = new List();
  var logger = Logger();
  List<Item> localList = new List();
  String baseUrl = "http://10.0.2.2:2001/"; //TODO: CHANGE PORT
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
    return list;
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
