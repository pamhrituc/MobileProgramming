import 'package:app/message.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>> displayDialog(
    {BuildContext context,
    String title,
    String buttonText,
    Message message}) async {
  //Message thisOne = Message(-1, "", "", "", -1, "");
  TextEditingController _senderController = new TextEditingController(text: "");
  TextEditingController _receiverController =
      new TextEditingController(text: "");
  TextEditingController _textController = new TextEditingController(text: "");
  TextEditingController _typeController = new TextEditingController(text: "");
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
                    decoration: new InputDecoration(labelText: 'Sender'),
                    controller: _senderController,
                  ),
                ),
                TextField(
                  decoration: new InputDecoration(
                    labelText: 'Receiver',
                  ),
                  controller: _receiverController,
                ),
                TextField(
                  decoration: new InputDecoration(
                    labelText: 'Text',
                  ),
                  controller: _textController,
                ),
                TextField(
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                      labelText: 'Type',
                    ),
                    controller: _typeController),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(buttonText),
              onPressed: () {
                Map<String, dynamic> inputData = {
                  "sender": _senderController.text,
                  "receiver": _receiverController.text,
                  "text": _textController.text,
                  "date": DateTime.now().day + DateTime.now().hour,
                  "type": _typeController.text
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
