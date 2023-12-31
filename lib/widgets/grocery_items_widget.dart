import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item_model.dart';
import 'package:shopping_list/widgets/add_grocery_item_widget.dart';

class GroceryItems extends StatefulWidget {
  const GroceryItems({super.key});

  @override
  State<GroceryItems> createState() => _GroceryItemsState();
}

class _GroceryItemsState extends State<GroceryItems> {
  final List<GroceryItem> _groceryItems = [];

  _addItem() async {
    GroceryItem newItem = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const AddGroceryItem()));

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => ListTile(
          leading: Container(
            height: 24,
            width: 24,
            color: _groceryItems[index].category.color,
          ),
          title: Text(_groceryItems[index].name),
          trailing: Text(_groceryItems[index].quantity.toString()),
        ),
      ),
    );
  }
}
