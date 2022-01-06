import 'package:flutter/material.dart';
import 'package:shopping_list/utilities/create_list_dialog.dart';
import 'lists.dart';

class ShoppingListHomePage extends StatelessWidget {
  ShoppingListHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  var newListName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: <Widget>[
          Center(child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Image.asset('assets/images/shopping.png')
          ),
          ),
          Center(child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: const Text(
              'Witaj w aplikacji Lista Zakupów!',
            ),
          ),
          ),
          Center(child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: const Text(
              'Wybierz swoją listę zakupów lub stwórz nową!',
            ),
          ),
          ),
          Center(child: Container(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                primary: Colors.white,
                backgroundColor: Colors.green,
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _navigateToListsPage(context);
              },
              child: const Text('Wybierz zapisaną listę'),
            ),
          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openCreateListDialog(context);
        },
        tooltip: 'Dodaj listę',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToListsPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListsPage()));
  }

  Future openCreateListDialog(context) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Nowa lista'),
      content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Podaj nazwę nowej listy'),
          onChanged:(text){
              newListName = text;
          },
      ),
      actions: [
        TextButton(
          child: const Text('Anuluj'),
          onPressed: () {
            cancelCreateListDialog(context);
          },
        ),
        TextButton(
          child: const Text('Zapisz'),
          onPressed: () async {
            await submitCreateListDialog(context, newListName);
          },
        )
      ]
    )
  );
}


