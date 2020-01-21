import 'package:connectivity/connectivity.dart';
import 'package:exam/Dialog/add_item_dialog.dart';
import 'package:exam/Models/item.dart';
import 'package:exam/Providers/screen2_provider.dart';
import 'package:exam/Widgets/item_widget.dart';
import 'package:exam/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Screen2 extends StatefulWidget {
  Screen2({Key key}) : super(key: key);

  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var connectivity;

  @override
  void initState() {
    final provider = Provider.of<Screen2Provider>(context, listen: false);
    super.initState();
    connectivity = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        provider.changeInternetStatus(false);
      } else {
        provider.changeInternetStatus(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Screen2Provider>(context, listen: true);
    return Scaffold(
      drawer: OurDrawer(),
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Screen2"),
        actions: <Widget>[
          RaisedButton(
            onPressed: () async {
              final data = await addItemDialog(
                  context: context); //TODO: maybe check if provider is online
              dynamic result = await provider.addItem(Item.fromJson(data));
              if (result is String) {
                _scaffoldKey.currentState
                    .showSnackBar(SnackBar(content: new Text(result)));
              }
            },
            child: Icon(Icons.add),
          )
        ],
      ),
      body: provider.isOnline
          ? itemList(context)
          : Center(
              child: Text("No no"),
            ),
    );
  }

  Widget itemList(BuildContext context) {
    final provider = Provider.of<Screen2Provider>(context, listen: true);
    return FutureBuilder(
      future: provider.getItems(),
      builder: (context, itemsSnap) {
        if (itemsSnap.connectionState == ConnectionState.done) {
          if (itemsSnap.data == null) return Container();
          return ListView.builder(
            itemCount: itemsSnap.data.length,
            itemBuilder: (context, index) {
              return ItemWidget(
                item: itemsSnap.data[index],
                scaffoldKey: _scaffoldKey,
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    connectivity.cancel();
    super.dispose();
  }
}
