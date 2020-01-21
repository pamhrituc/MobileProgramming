import 'package:exam/Models/item.dart';
import 'package:exam/Providers/screen1_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemWidget extends StatefulWidget {
  final Item item;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ItemWidget({
    Key key,
    @required this.item,
    @required this.scaffoldKey,
  }) : super(key: key);

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  // Widget addItemToLocal(BuildContext context) {
  //   return IconButton(
  //     icon: Icon(Icons.add),
  //     onPressed: () async {
  //       final provider = Provider.of<Screen1Provider>(context, listen: false);
  //       String response = await provider.addToLocal(widget.item);
  //       var snackbar = new SnackBar(content: new Text(response));
  //       widget.scaffoldKey.currentState.showSnackBar(snackbar);
  //     },
  //   );
  // }

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
      color: Colors.deepPurple,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Name: " + widget.item.name),
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
