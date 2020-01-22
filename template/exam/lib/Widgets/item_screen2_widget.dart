import 'package:exam/Providers/screen2_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemScreen2Widget extends StatefulWidget {
  final String name;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ItemScreen2Widget({
    Key key,
    @required this.name,
    @required this.scaffoldKey,
  }) : super(key: key);

  @override
  _ItemScreen2WidgetState createState() => _ItemScreen2WidgetState();
}

class _ItemScreen2WidgetState extends State<ItemScreen2Widget> {
  Widget addItemToLocal(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () async {
        final provider = Provider.of<Screen2Provider>(context, listen: false);
        String response = await provider.addName(widget.name);
        var snackbar = new SnackBar(content: new Text(response));
        widget.scaffoldKey.currentState.showSnackBar(snackbar);
      },
    );
  }

  Widget deleteItem(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () async {
        final provider = Provider.of<Screen2Provider>(context, listen: false);
        String response = await provider.deleteName(widget.name);
        var snackbar = new SnackBar(content: new Text(response));
        widget.scaffoldKey.currentState.showSnackBar(snackbar);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      color: Colors.deepPurpleAccent[150],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Name: " + widget.name, style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          deleteItem(context),
        ],
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
  }
}
