import 'package:app/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatelessWidget {
  final Message message;

  const AddScreen({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Row(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: "Sender"),
              onChanged: (value) {
                message.setSender(value);
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: "Receiver"),
              onChanged: (value) {
                message.setReceiver(value);
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: "Text"),
              onChanged: (value) {
                message.setText(value);
              },
            ),
            DropdownButton(
              items: <String>['public', 'private'].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (value) {
                message.setType(value);
              },
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pop(context, message);
              },
            ),
          ],
        ),
      ),
    );
  }
}
