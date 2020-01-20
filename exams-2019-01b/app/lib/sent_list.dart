import 'package:app/crud_provider.dart';
import 'package:app/message.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SentList extends StatefulWidget {
  final String user;
  SentList({Key key, @required this.user}) : super(key: key);
  @override
  _SentListState createState() => _SentListState(user);
}

class _SentListState extends State<SentList> {
  var subscription;

  String user;

  _SentListState(String user) : this.user = user;
  @override
  void initState() {
    print(user);
    final provider = Provider.of<CrudProvider>(context, listen: false);
    super.initState();
    print(this.user);
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

  Widget messagesWidget() {
    final provider = Provider.of<CrudProvider>(context, listen: true);
    return FutureBuilder(
      future: provider.getSent(user),
      builder: (context, messagesSnap) {
        if (messagesSnap.connectionState == ConnectionState.done) {
          if (messagesSnap.data == null) {
            return Container();
          }
          return ListView.builder(
              itemCount: messagesSnap.data.length,
              itemBuilder: (context, index) {
                return MessageWidget(message: messagesSnap.data[index]);
              });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: messagesWidget());
  }
}

class MessageWidget extends StatelessWidget {
  final Message message;
  const MessageWidget({this.message, Key key}) : super(key: key);

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
                            title: Text(message.text),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                            ),
                          );
                        });
                  },
                  child: Column(
                    children: <Widget>[
                      Text(
                        message.text,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
