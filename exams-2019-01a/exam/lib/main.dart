import 'package:connectivity/connectivity.dart';
import 'package:exam/Models/phone.dart';
import 'package:exam/Provider/crud_provider.dart';
import 'package:exam/Screens/display_dialog.dart';
import 'package:exam/Screens/reserved_list.dart';
import 'package:exam/db_creator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  await DBCreator().initDB();
  runApp(
    ChangeNotifierProvider(
      builder: (context) => CrudProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exam',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CrudProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text('App'),
        actions: <Widget>[
          RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReservedList()),
              );
            },
            child: Icon(Icons.arrow_right),
            color: Theme.of(context).primaryColor,
          ),
          RaisedButton(
            onPressed: () {
              provider.refresh();
            },
            child: Icon(Icons.refresh),
            color: Theme.of(context).primaryColor,
          ),
          RaisedButton(
            onPressed: () async {
              if (provider.isOnline) {
                final data = await displayDialog(
                    context: context, title: 'Add', buttonText: 'Add');
                if (data != null) {
                  Phone phone = Phone.fromJson(data);
                  provider.addPhone(phone);
                }
              } else {
                SnackBar(
                  content: Text('No internet'),
                );
              }
            },
            child: Icon(Icons.add),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      body: PhoneList(),
    );
  }
}

class PhoneList extends StatefulWidget {
  PhoneList({Key key}) : super(key: key);

  @override
  _PhoneListState createState() => _PhoneListState();
}

class _PhoneListState extends State<PhoneList> {
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
      future: provider.getPhones(),
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
    return Container(child: phonesWidget());
  }
}

class PhoneWidget extends StatelessWidget {
  final Phone phone;
  const PhoneWidget({this.phone, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CrudProvider>(context);
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          color: Colors.deepPurpleAccent[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(phone.name),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Text("Size: "),
                                  Text(phone.size.toString())
                                ]),
                                Row(children: <Widget>[
                                  Text("Manufacturer: "),
                                  Text(phone.manufacturer)
                                ]),
                                Row(children: <Widget>[
                                  Text("Quantity: "),
                                  Text(phone.quantity.toString())
                                ]),
                                Row(children: <Widget>[
                                  Text("Reserved: "),
                                  Text(phone.reserved.toString())
                                ])
                              ],
                            ),
                          );
                        });
                  },
                  child: Column(
                    children: <Widget>[
                      Text(
                        phone.name,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        if (provider.isOnline) {
                          provider.reservePhone(phone);
                        } else {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('No internet'),
                          ));
                        }
                      },
                      child: Icon(Icons.arrow_downward),
                    ),
                    RaisedButton(
                      onPressed: () {
                        provider.cancelPhone(phone);
                      },
                      child: Icon(Icons.cancel),
                    ),
                    RaisedButton(
                      onPressed: () {
                        provider.buyPhone(phone);
                      },
                      child: Icon(Icons.shopping_cart),
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (provider.isOnline) {
                          provider.deletePhone(phone);
                        } else {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('No internet'),
                          ));
                        }
                      },
                      child: Icon(Icons.delete),
                      color: provider.isOnline
                          ? Colors.deepPurpleAccent
                          : Colors.grey,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
