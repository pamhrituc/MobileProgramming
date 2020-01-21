import 'dart:io';

import 'package:flutter/material.dart';

Future<Map<String, dynamic>> addItemDialog({
  BuildContext context,
}) async {
  final _textKey = GlobalKey<FormState>();
  TextEditingController _idController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _sizeController = TextEditingController();

  return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add item"),
          content: Form(
            key: _textKey,
            child: SingleChildScrollView(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                      decoration: new InputDecoration(labelText: 'Name'),
                      controller: _nameController,
                      textInputAction: Platform.isAndroid
                          ? TextInputAction.next
                          : TextInputAction.continueAction),
                  TextFormField(
                    decoration: new InputDecoration(labelText: 'Desc'),
                    controller: _descController,
                    textInputAction: Platform.isAndroid
                        ? TextInputAction.next
                        : TextInputAction.continueAction,
                  ),
                  TextFormField(
                    decoration: new InputDecoration(labelText: 'Size'),
                    controller: _sizeController,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Add"),
              onPressed: () {
                Map<String, dynamic> inputData = {
                  "id": -1,
                  "name": _nameController.text,
                  "desc": _descController.text,
                  "size": int.parse(_sizeController.text),
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
