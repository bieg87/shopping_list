import 'package:flutter/material.dart';
import 'package:shopping_list/models/product.dart';
import 'package:shopping_list/models/shopping_list.dart';
import 'package:shopping_list/providers/datebase.dart';

class EditableListTile extends StatefulWidget {
  final Product model;
  final Function(Product listModel) onChanged;
  final ShoppingList list;
  final Future Function() refresh;
  final VoidCallback onDeleteClicked;

  List<Product> products;
  EditableListTile({
    required Key key, required this.model, required this.onChanged, required this.onDeleteClicked, required this.list, required this.refresh, required this.products,  })
      : assert(model != null),
        super(key: key);

  @override
  _EditableListTileState createState() => _EditableListTileState();
}

class _EditableListTileState extends State<EditableListTile> {
  late Product model;
  late bool _isEditingMode;
  late Color _checkColor;
  late TextEditingController _titleEditingController, _subTitleEditingController;

  @override
  void initState() {
    super.initState();
    this.model = widget.model;
    this._isEditingMode = false;
    if(model.is_done == 0) {
      _checkColor = Colors.red;
    } else {
      _checkColor = Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return  ListTile(
      title: titleWidget,
      subtitle: subTitleWidget,
      trailing: tralingButton,
    );
  }

  Widget get titleWidget {
    if (_isEditingMode) {

      _titleEditingController = TextEditingController(text: model.product);
      return TextField(
        onTap: (){
          _titleEditingController.text = '';
        },
        controller: _titleEditingController,
      );
    } else {
      if(model.id == -1){
        return Text("Wpisz nazwę nowego produktu");
      } else {
        return Text(model.product);
      }
    }
  }


  Widget get subTitleWidget {
    if (_isEditingMode) {
      _subTitleEditingController = TextEditingController(text: model.quantity);
      return TextField(
        onTap: (){
          _subTitleEditingController.text = '';
        },
        controller: _subTitleEditingController,
      );
    } else {
      if(model.id == -1){
        return Text("Wpisz ilość nowego produktu");
      } else {
        return Text(model.quantity);
      }
    }
  }

  Widget get tralingButton {
    if (_isEditingMode) {
      return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
                IconButton(
                icon: Icon(Icons.check),
              onPressed: saveChange,
              ),
              IconButton(
              icon: Icon(Icons.cancel),
              onPressed: _toggleMode,
              ),
          ]
          );
    } else {
      return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if(model.id != -1) IconButton(
              icon: Icon(Icons.check),
              onPressed: _isDoneChange,
              color: _checkColor,
            ),
            if(model.id != -1) IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteProduct,
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: _toggleMode,
            ),
            ]
      );
    }
  }

  void _deleteProduct() {
    SQLiteDbProvider.db.deleteProduct(model.id);
    widget.onDeleteClicked();
    setState((){ widget.products.removeWhere((item) => item.id == model.id);});
    widget.refresh();
  }
  void _toggleMode() {
    setState(() {
      _isEditingMode = !_isEditingMode;
    });
  }

  void _isDoneChange() {
    if(model.is_done == 0)
    {
      setState(() {
        model.is_done = 1;
        _checkColor = Colors.green;
      });
    } else {
      setState(() {
          model.is_done = 0;
          _checkColor = Colors.red;
      });
    }
    SQLiteDbProvider.db.updateProduct(model);
  }
  void saveChange() {
      setState(() {
        this.model.list_id = widget.list.id;
        this.model.quantity = _subTitleEditingController.text;
        this.model.product = _titleEditingController.text;
      });
      _toggleMode();

      if(model.id == -1) {
        SQLiteDbProvider.db.addProduct(model);
      }
      else {
        SQLiteDbProvider.db.updateProduct(model);
      }
      widget.onChanged(this.model);

     //widget.refresh();
  }
}