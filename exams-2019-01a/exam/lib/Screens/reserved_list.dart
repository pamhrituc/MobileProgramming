import 'package:connectivity/connectivity.dart';
import 'package:exam/Models/phone.dart';
import 'package:exam/Provider/crud_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReservedList extends StatefulWidget {
  ReservedList({Key key}) : super(key: key);

  @override
  _ReservedListState createState() => _ReservedListState();
}

class _ReservedListState extends State<ReservedList> {
  var subscription;
  @override
  void initState() {
    final provider = Provider.of<CrudProvider>(context, listen: false);
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen((onData) {
      if (onData == ConnectivityResult.none) {
        provider.modifyOnlineStatus(false);
      } else {
        provider.modifyOnlineStatus(true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  Widget phonesWidget() {
    final provider = Provider.of<CrudProvider>(context, listen: true);
    return FutureBuilder(
      future: provider.getReserved(),
      builder: (context, phonesSnap) {
        if (phonesSnap.connectionState == ConnectionState.done) {
          if (phonesSnap.data == null) {
            return Container();
          }
          return ListView.builder(
              itemCount: phonesSnap.data.length,
              itemBuilder: (context, index) {
                return PhoneWidget(phone: phonesSnap.data[index]);
              });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Reserved"),
        ),
        body: Container(child: phonesWidget()));
  }
}

class PhoneWidget extends StatelessWidget {
  final Phone phone;
  const PhoneWidget({this.phone, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      color: Colors.deepPurpleAccent[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                phone.name,
                style: TextStyle(fontSize: 30),
              ),
              Text(
                "Size: " + phone.size.toString(),
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "Manufacturer: " + phone.manufacturer,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "Quantity: " + phone.quantity.toString(),
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "Reserved: " + phone.reserved.toString(),
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
