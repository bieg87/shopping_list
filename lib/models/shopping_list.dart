class ShoppingList {
  final int id;
  final String name;
  final String date;

  static final columns = ["id", "name", "date"];
  ShoppingList(this.id, this.name, this.date);

  factory ShoppingList.fromMap(Map<dynamic, dynamic> data) {
    return ShoppingList(
      data['id'],
      data['name'],
      data['date'],
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "date": date
  };
}