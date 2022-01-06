import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shopping_list/models/shopping_list.dart';
import 'package:shopping_list/models/product.dart';

class SQLiteDbProvider {
  static final SQLiteDbProvider db = SQLiteDbProvider._init();

  static Database? _database;

  SQLiteDbProvider._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ShoppingList6.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute(
        """CREATE TABLE List(id INTEGER PRIMARY KEY AUTOINCREMENT, 
        name TEXT, date TIMESTAMP DEFAULT CURRENT_TIMESTAMP);"""
                );
    await db.execute(
      """CREATE TABLE Products(id INTEGER PRIMARY KEY AUTOINCREMENT,
      product TEXT, quantity TEXT, list_id INTEGER, is_done INTEGER,
      FOREIGN KEY(list_id) REFERENCES List(id));"""
    );
  }

  Future<List<ShoppingList>> getAllShoppingLists() async {
    final db = await database;
    List<Map> results = await db.query(
        "List", columns: ShoppingList.columns, orderBy: "date DESC");

    List<ShoppingList> shoppingLists = <ShoppingList>[];
    results.forEach((result) {
      ShoppingList shoppingList = ShoppingList.fromMap(result);
      shoppingLists.add(shoppingList);
    });

    return shoppingLists;
  }

   Future<num> create(name) async {
    final db = await SQLiteDbProvider.db.database;
    final id = await db.insert('List', {"name": name});

    return id;
  }

  Future<List<Product>> getProducts(int id) async {
    final db = await SQLiteDbProvider.db.database;

    List<Map> results = await db.query(
      'Products',
      columns: Product.columns,
      where: '${Product.columns[3]} = ?',
      whereArgs: [id],
    );

    List<Product> products = <Product>[];
    results.forEach((result) {
      Product product = Product.fromMap(result);
      products.add(product);
    });

    return products;
  }

  Future<num> addProduct(Product product) async {
    final db = await SQLiteDbProvider.db.database;
    final id = await db.insert('Products', {
      "product": product.product,
      "quantity": product.quantity,
      "list_id": product.list_id,
      "is_done": product.is_done,
    });

    return id;
  }

  Future<num> updateProduct(Product product) async {
    final db = await SQLiteDbProvider.db.database;
    final id = await db.update('Products', {
      "product": product.product,
      "quantity": product.quantity,
      "list_id": product.list_id,
      "is_done": product.is_done,
    },
     where: '${Product.columns[0]} =  ?',
     whereArgs: [product.id]
  );

    return id;
  }

  Future<int> deleteProduct(int id) async {
    final db = await SQLiteDbProvider.db.database;
    return await db.delete(
      'Products',
      where: '${Product.columns[0]} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteList(int id) async {
    final db = await SQLiteDbProvider.db.database;
    await db.delete(
      'Products',
      where: '${Product.columns[3]} = ?',
      whereArgs: [id],
    );
    return db.delete(
      'List',
      where: '${ShoppingList.columns[0]} = ?',
      whereArgs: [id],
    );
  }
}