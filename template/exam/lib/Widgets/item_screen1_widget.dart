import 'package:exam/Models/item.dart';
import 'package:exam/Providers/screen1_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemScreen1Widget extends StatefulWidget {
  final Item item;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ItemScreen1Widget({
    Key key,
    @required this.item,
    @required this.scaffoldKey,
  }) : super(key: key);

  @override
  _ItemScreen1WidgetState createState() => _ItemScreen1WidgetState();
}

class _ItemScreen1WidgetState extends State<ItemScreen1Widget> {
  Widget addItemToLocal(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () async {
        final provider = Provider.of<Screen1Provider>(context, listen: false);
        String response = await provider.addItem(widget.item);
        var snackbar = new SnackBar(content: new Text(response));
        widget.scaffoldKey.currentState.showSnackBar(snackbar);
      },
    );
  }

  Widget deleteItem(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () async {
        final provider = Provider.of<Screen1Provider>(context, listen: false);
        String response = await provider.deleteItem(widget.item);
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Name: " + widget.item.name,
                    style: TextStyle(fontSize: 20)),
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
