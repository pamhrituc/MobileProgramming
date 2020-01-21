import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:connectivity/connectivity.dart';
import 'package:exam/Models/phone.dart';
import 'package:exam/Rep/phone_rep.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class ServerRep {
  var logger = Logger();
  String baseUrl = "http://10.0.2.2:2001/";
  final List<Phone> toPushWhenOnline = new List<Phone>();
  List<Phone> localList = new List();
  Map<String, String> headers = {"Content-type": "application/json"};
  DBRep dbRep = new DBRep();

  Future<bool> isConnectedToInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  Future<List<Phone>> getAllPhonesFromServer() async {
    bool isInternetAvailable = await isConnectedToInternet();
    if (isInternetAvailable) {
      Response response = await get(baseUrl + 'phones');
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Phone> phoneList = List();
        for (var elem in body) {
          final phone = Phone.fromJson(elem);
          phoneList.add(phone);
        }
        logger.i("Server: Retrieved all");
        return phoneList;
      } else {
        logger.e("Server: Can't retrieve all");
      }
    } else {
      logger.i("Server: retrieving from DB");
      return dbRep.getAll();
    }
  }

  Future<void> addToServer() async {
    for (Phone phone in toPushWhenOnline) {
      await addPhoneToServer(phone);
    }
    toPushWhenOnline.clear();
    logger.i("Server: added to server");
  }

  Future<void> reservePhoneServer(Phone phone) async {
    Response response = await post(baseUrl + 'reserve',
        headers: headers, body: json.encode(phone.toJson()));
    if (response.statusCode == 200) {
      dynamic body = json.decode(response.body);
      Phone phoneNew = new Phone.fromJson(body);
      dbRep.update(phone, phoneNew);
      dbRep.reserve(phone);
      logger.i("Server: reserved item server");
    }
  }

  Future<void> addPhoneToServer(Phone phone) async {
    Response response = await post(baseUrl + 'phone',
        headers: headers, body: json.encode(phone.toJson()));
    if (response.statusCode == 200) {
      dynamic body = json.decode(response.body);
      Phone phoneNew = new Phone.fromJson(body);
      dbRep.update(phone, phoneNew);
      logger.i("Server: added item to server");
    }
  }

  Future<void> cancelReservation(Phone phone) async {
    Response response = await post(baseUrl + 'cancel',
        headers: headers, body: json.encode(phone.toJson()));
    if (response.statusCode == 200) {
      dynamic body = json.decode(response.body);
      Phone phoneNew = new Phone.fromJson(body);
      dbRep.update(phone, phoneNew);
      logger.i("Server: canceled item");
    }
  }

  Future<void> buyPhone(Phone phone) async {
    Response response = await post(baseUrl + 'buy',
        headers: headers, body: json.encode(phone.toJson()));
    if (response.statusCode == 200) {
      dynamic body = json.decode(response.body);
      Phone phoneNew = new Phone.fromJson(body);
      dbRep.update(phone, phoneNew);
      logger.i("Server: bought item");
    }
  }

  Future<void> deletePhoneFromServer(Phone phone) async {
    String urlToAccess = baseUrl + 'phone/' + phone.id.toString();
    Response response = await delete(urlToAccess);
    if (response.statusCode == 200) {
      await dbRep.delete(phone);
      logger.i("Server: deleted " + phone.id.toString());
    }
  }

  Future<void> addPhone(Phone phone) async {
    bool isInternetAvailable = await isConnectedToInternet();
    Phone newPhone = await dbRep.add(phone);
    toPushWhenOnline.add(newPhone);
    logger.i(phone.toJson());
    if (isInternetAvailable) {
      await addToServer();
    }
  }
}
