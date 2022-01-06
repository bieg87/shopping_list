import 'package:flutter/material.dart';
import 'package:shopping_list/providers/datebase.dart';
import 'package:shopping_list/screens/lists.dart';

void cancelCreateListDialog(context){
  Navigator.of(context).pop();
}

Future<void> submitCreateListDialog(context, newListName) async {
  await SQLiteDbProvider.db.create(newListName);
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListsPage()));
}