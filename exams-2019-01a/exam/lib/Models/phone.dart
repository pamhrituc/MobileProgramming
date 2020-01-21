import 'package:exam/db_creator.dart';

class Phone {
  int id;
  String name;
  int size;
  String manufacturer;
  int quantity;
  int reserved;

  Phone(this.id, this.name, this.size, this.manufacturer, this.quantity,
      this.reserved);

  void setId(int id) => this.id = id;
  void setName(String name) => this.name = name;
  void setSize(int size) => this.size = size;
  void setManufacturer(String man) => this.manufacturer = man;
  void setQuantity(int quantity) => this.quantity = quantity;
  void setReserved(int reserved) => this.reserved = reserved;

  Phone.fromJson(Map<String, dynamic> json)
      : id = json[DBCreator.id] ?? -1,
        name = json[DBCreator.name],
        size = int.parse(json[DBCreator.size].toString()),
        manufacturer = json[DBCreator.manufacturer],
        quantity = int.parse(json[DBCreator.quantity].toString()),
        reserved = int.parse(json[DBCreator.reserved].toString());

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'size': size,
        'manufacturer': manufacturer,
        'quantity': quantity,
        'reserved': reserved
      };
}
