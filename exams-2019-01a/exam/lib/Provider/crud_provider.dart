import 'package:exam/Models/phone.dart';
import 'package:exam/Rep/phone_rep.dart';
import 'package:exam/Rep/server_rep.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class CrudProvider extends ChangeNotifier {
  var logger = Logger();
  ServerRep phonesRep = new ServerRep();
  List<Phone> localList = new List();
  bool isOnline = true;
  bool fromServer = true;
  DBRep dbRep = new DBRep();

  Future<List<Phone>> getPhones() async {
    if (fromServer) {
      localList = await phonesRep.getAllPhonesFromServer();
      List<Phone> aux = await dbRep.getAll();
      fromServer = false;
    } else {
      localList = await dbRep.getAll();
    }
    List<Phone> displayedPhones = new List<Phone>();
    for (Phone phone in localList) {
      if (phone.quantity > phone.reserved) {
        displayedPhones.add(phone);
      }
    }
    displayedPhones.sort((a, b) => a.quantity.compareTo(b.quantity));
    logger.i("CRUD Provider: Phones have been retrieved");
    return displayedPhones;
  }

  Future<List<Phone>> getReserved() async {
    logger.i("CRUD Provider: getting reserved phones");
    return dbRep.getReservedPhones();
  }

  void modifyOnlineStatus(bool flag) {
    isOnline = flag;
    logger.i(
        "CRUD Provider: Onlie status has been modified to " + flag.toString());
    notifyListeners();
  }

  void cancelPhone(Phone phone) {
    phonesRep.cancelReservation(phone).whenComplete(() {
      logger.i("CRUD Provider: " + phone.id.toString() + " has been canceled");
      notifyListeners();
    });
  }

  void deletePhone(Phone phone) {
    phonesRep.deletePhoneFromServer(phone).whenComplete(() {
      logger.i("CRUD Provider: " + phone.id.toString() + " has been deleted");
      notifyListeners();
    });
  }

  void reservePhone(Phone phone) {
    phonesRep.reservePhoneServer(phone).whenComplete(() {
      logger.i("CRUD Provider: reserved phone w/ id " + phone.id.toString());
      notifyListeners();
    });
  }

  void buyPhone(Phone phone) {
    phonesRep.buyPhone(phone).whenComplete(() {
      logger.i("CRUD Provider: bought phone w/ id " + phone.id.toString());
      notifyListeners();
    });
  }

  void addPhone(Phone phone) {
    phonesRep.addPhoneToServer(phone).whenComplete(() {
      logger.i("CRUD Provider: added phone w/ id " + phone.id.toString());
      notifyListeners();
    });
  }

  void refresh() {
    fromServer = true;
    notifyListeners();
  }
}
