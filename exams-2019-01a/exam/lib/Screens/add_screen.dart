import 'package:exam/Models/phone.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatelessWidget {
  final Phone phone;

  const AddScreen({Key key, this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Row(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: "Name"),
              onChanged: (value) {
                phone.setName(value);
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: "Size"),
              onChanged: (value) {
                phone.setSize(int.parse(value));
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: "Manufacturer"),
              onChanged: (value) {
                phone.setManufacturer(value);
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: "Quantity"),
              onChanged: (value) {
                phone.setQuantity(int.parse(value));
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: "Reserved"),
              onChanged: (value) {
                phone.setReserved(int.parse(value));
              },
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pop(context, phone);
              },
            ),
          ],
        ),
      ),
    );
  }
}
