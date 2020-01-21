class Item {
  final int id;
  final String name;
  final String desc;
  final int size;

  Item({
    this.id,
    this.name,
    this.desc,
    this.size,
  });

  Item.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        desc = json["desc"],
        size = json["size"];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'desc': desc,
        'size': size,
      };
}
