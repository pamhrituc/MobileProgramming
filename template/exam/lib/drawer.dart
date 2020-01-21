import 'package:exam/routes.dart';
import 'package:flutter/material.dart';

class OurDrawer extends StatelessWidget {
  const OurDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.wb_sunny),
                Text('Navigate the app'),
              ],
            )),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),
          ListTile(
            title: Text("Screen 1"),
            onTap: () => Navigator.pushReplacementNamed(context, SCREEN_1),
          ),
          ListTile(
            title: Text("Screen 2"),
            onTap: () => Navigator.pushReplacementNamed(context, SCREEN_2),
          ),
        ],
      ),
    );
  }
}
