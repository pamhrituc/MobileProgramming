class Item {
  final int id;
  final String name;
  final String description;
  final int quantity;
  final int price;
  final String status;

  Item({
    this.id,
    this.name,
    this.description,
    this.quantity,
    this.price,
    this.status,
  });

  Item.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        description = json["description"],
        quantity = json["quantity"],
        price = json["price"],
        status = json["status"];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'quantity': quantity,
        'price': price,
        'status': status
      };
}
