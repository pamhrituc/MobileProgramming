import 'package:connectivity/connectivity.dart';
import 'package:logger/logger.dart';

class Screen2Rep {
  List<String> list = new List();
  var logger = Logger();
  List<String> localList = new List();
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

  Future<List<String>> getAllNames() async {
    logger.i("Rep: Retrieving all names");
    return list;
  }

  Future<dynamic> addItem(String name) async {
    logger.i("Rep: Adding Item");
    list.add(name);

    ///daca e eroare o sa fie de type string
    ///daca e ok o sa fie de type Item
    ///depinde daca serverul trimite sau nu inapoi obiectu
    ///cu idu setat
    return name;
  }

  Future<String> deleteItem(String name) async {
    logger.i("Rep: Deleting item");
    list.remove(name); //TODO: Change to id & return error message
    return "yelp";
  }
}
