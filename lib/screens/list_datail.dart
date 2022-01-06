import 'package:flutter/material.dart';
import 'package:shopping_list/models/product.dart';
import 'package:shopping_list/models/shopping_list.dart';
import 'package:shopping_list/providers/datebase.dart';
import 'package:shopping_list/widgets/list_products.dart';

class ListDetailPage extends StatefulWidget {
  final ShoppingList list;

  const ListDetailPage({
    Key? key,
    required this.list
  }) : super(key: key);

  @override
  _ListDetailPageState createState() => _ListDetailPageState();
}

class _ListDetailPageState extends State<ListDetailPage> {
  List<Product> products = [];
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    refreshList();

  }

  Future refreshList() async {
    setState(() => isLoading = true);
    final List<Product> productResult = await SQLiteDbProvider.db.getProducts(widget.list.id);
    setState(() {this.products = [];});
    setState(() {this.products = productResult;});
    products.insert(0, Product(-1,"Wpisz nazwę nowego produktu","Wpisz ilość nowego produktu",-1, 0));
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.list.name, style: TextStyle(fontSize: 24),),
      actions: [deleteButton()],
    ),
     body: ListView.builder(itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return EditableListTile(
                key: ObjectKey(product),
                model: products[index],
                onChanged: (Product updatedModel) {
                  products[index] = updatedModel;
                  refreshList();
                },
                onDeleteClicked: () => _deleteItem(product),
                refresh: refreshList,
                list: widget.list,
                products: products,
              );
            }
  )
  );

  void _deleteItem(Product product) {
    products.remove(product);
    setState(() {});
  }

  Widget deleteButton() => IconButton(
    icon: Icon(Icons.delete),
    onPressed: () async {
      await SQLiteDbProvider.db.deleteList(widget.list.id);
      Navigator.of(context).pop();
    },
  );

}