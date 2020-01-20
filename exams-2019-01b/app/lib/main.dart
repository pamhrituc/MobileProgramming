import 'package:app/db_creator.dart';
import 'package:app/display_dialog.dart';
import 'package:app/message.dart';
import 'package:app/user_list.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'crud_provider.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
        title: Text('ChatApp'),
        actions: <Widget>[
          RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserList()),
              );
            },
            child: Icon(Icons.person),
            color: Theme.of(context).primaryColor,
          ),
          RaisedButton(
            onPressed: () async {
              final data = await displayDialog(
                  context: context, title: 'Add', buttonText: 'Add');
              if (data != null) {
                Message message = Message.fromJson(data);
                provider.addMessage(message);
              }
            },
            child: Icon(Icons.add),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      body: MessageList(),
    );
  }
}

class MessageList extends StatefulWidget {
  MessageList({Key key}) : super(key: key);

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
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

  Widget messagesWidget() {
    final provider = Provider.of<CrudProvider>(context, listen: true);
    return FutureBuilder(
      future: provider.getMessages(),
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
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Text("Sender: "),
                                  Text(message.sender)
                                ]),
                                Row(children: <Widget>[
                                  Text("Receiver: "),
                                  Text(message.receiver)
                                ]),
                                Row(children: <Widget>[
                                  Text("Date: "),
                                  Text(message.date.toString())
                                ])
                              ],
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        if (provider.isOnline) {
                          provider.deleteMessage(message);
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
