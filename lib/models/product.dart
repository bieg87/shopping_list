class Product {
   int id;
   String product;
   String quantity;
   num list_id;
   int is_done;
  static final columns = ["id", "product", "quantity", "list_id", "is_done"];

  Product(this.id, this.product, this.quantity, this.list_id, this.is_done);

  factory Product.fromMap(Map<dynamic, dynamic> data) {
    return Product(
      data['id'],
      data['product'],
      data['quantity'],
      data['list_id'],
      data['is_done'],
    );
  }

  Map<String, dynamic> toMap() =>
      {
        "id": id,
        "product": product,
        "quantity": quantity,
        "list_id": list_id,
        "is_done": is_done,
      };
}