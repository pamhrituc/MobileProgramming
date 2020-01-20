import 'package:app/db_creator.dart';

class Message {
  int id;
  String sender;
  String receiver;
  String text; //limit of 150 characters
  int date; //unix time
  String type;
  Message(this.id, this.sender, this.receiver, this.text, this.date, this.type);
  void setId(int id) => this.id = id;
  void setSender(String sender) => this.sender = sender;
  void setReceiver(String receiver) => this.receiver = receiver;
  void setText(String text) => this.text = text;
  void setDate(int date) => this.date = date;
  void setType(String type) => this.type = type;

  Message.fromJson(Map<String, dynamic> json)
      : id = json[DBCreator.id] ?? -1,
        sender = json[DBCreator.sender],
        receiver = json[DBCreator.receiver],
        text = json[DBCreator.text],
        date = int.parse(json[DBCreator.date].toString()),
        type = json[DBCreator.type];
  Map<String, dynamic> toJson() => {
        'id': id,
        'sender': sender,
        'receiver': receiver,
        'text': text,
        'date': date,
        'type': type
      };
}
