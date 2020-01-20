import 'package:app/crud_provider.dart';
import 'package:app/private_list.dart';
import 'package:app/received_list.dart';
import 'package:app/sent_list.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  UserList({Key key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
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

  Widget usersWidget() {
    final provider = Provider.of<CrudProvider>(context, listen: true);
    return FutureBuilder(
      future: provider.getUsers(),
      builder: (context, usersSnap) {
        if (usersSnap.connectionState == ConnectionState.done) {
          if (usersSnap.data == null) {
            return Container();
          }
          return ListView.builder(
              itemCount: usersSnap.data.length,
              itemBuilder: (context, index) {
                return UserWidget(user: usersSnap.data[index]);
              });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: usersWidget());
  }
}

class UserWidget extends StatelessWidget {
  final String user;
  const UserWidget({this.user, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CrudProvider>(context);
    return Container(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Container(
          color: Colors.deepPurpleAccent[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: Column(
                    children: <Widget>[
                      Text(
                        user,
                        style: TextStyle(fontSize: 30),
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
                        provider.saveUser(user);
                      },
                      child: Icon(Icons.add),
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrivateList(
                                    user: user,
                                  )),
                        );
                      },
                      child: Icon(Icons.message),
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (provider.isOnline) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SentList(
                                      user: user,
                                    )),
                          );
                        } else {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('No internet'),
                          ));
                        }
                      },
                      child: Icon(Icons.send),
                      color: provider.isOnline
                          ? Colors.deepPurpleAccent
                          : Colors.grey,
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (provider.isOnline) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReceivedList(
                                      user: user,
                                    )),
                          );
                        } else {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('No internet'),
                          ));
                        }
                      },
                      child: Icon(
                        Icons.receipt,
                        color: provider.isOnline
                            ? Colors.deepPurpleAccent
                            : Colors.grey,
                      ),
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
