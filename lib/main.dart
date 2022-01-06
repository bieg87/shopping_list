import 'package:flutter/material.dart';
import './screens/home.dart';

void main() {
  runApp(const ShoppingListApp());
}

class ShoppingListApp extends StatelessWidget {
  const ShoppingListApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista zakupów',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ShoppingListHomePage(title: 'Lista zakupów'),
    );
  }
}


