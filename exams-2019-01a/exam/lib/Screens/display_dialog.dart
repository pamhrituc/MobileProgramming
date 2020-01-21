import 'package:exam/Models/phone.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>> displayDialog(
    {BuildContext context,
    String title,
    String buttonText,
    Phone phone}) async {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _sizeController = new TextEditingController();
  TextEditingController _manufacturerController = new TextEditingController();
  TextEditingController _quantityController = new TextEditingController();
  TextEditingController _reservedController = new TextEditingController();

  return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: TextField(
                    autofocus: true,
                    decoration: new InputDecoration(labelText: 'Name'),
                    controller: _nameController,
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                    labelText: 'Size',
                  ),
                  controller: _sizeController,
                ),
                TextField(
                  decoration: new InputDecoration(
                    labelText: 'Manufacturer',
                  ),
                  controller: _manufacturerController,
                ),
                TextField(
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                      labelText: 'Quantity',
                    ),
                    controller: _quantityController),
                TextField(
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                      labelText: 'Reserved',
                    ),
                    controller: _reservedController),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(buttonText),
              onPressed: () {
                Map<String, dynamic> inputData = {
                  "name": _nameController.text,
                  "size": int.parse(_sizeController.text),
                  "manufacturer": _manufacturerController.text,
                  "quantity": int.parse(_quantityController.text),
                  "reserved": int.parse(_reservedController.text)
                };
                Navigator.of(context).pop(inputData);
              },
            ),
            new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}
