import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories_data.dart';
import 'package:shopping_list/models/category_model.dart';
import 'package:shopping_list/models/grocery_item_model.dart';
import 'package:shopping_list/widgets/add_grocery_item_widget.dart';

class GroceryItems extends StatefulWidget {
  const GroceryItems({super.key});

  @override
  State<GroceryItems> createState() => _GroceryItemsState();
}

class _GroceryItemsState extends State<GroceryItems> {
  List<GroceryItem> _groceryItems = [];

  @override
  initState() {
    _loadItems();
    super.initState();
  }

  _loadItems() async {
    final url = Uri.https(
        'angular-backend-4c6f4-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-list.json');
    http.Response response = await http.get(url);
    Map<String, dynamic> catItems = json.decode(response.body);
    List<GroceryItem> loadedItems = [];
    for (final item in catItems.entries) {
      Category category = categories.entries
          .firstWhere((categoryItem) =>
              categoryItem.value.name == item.value['category'])
          .value;
      loadedItems.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category));
    }
    setState(() {
      _groceryItems = loadedItems;
    });
  }

  _addItem() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const AddGroceryItem()));
    _loadItems();
  }

  _removeItem(GroceryItem groceryItem) {
    setState(() {
      _groceryItems.remove(groceryItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screenBody =
        const Center(child: Text('No item to display. Add a new item'));
    if (_groceryItems.isNotEmpty) {
      screenBody = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          key: ValueKey(_groceryItems[index].id),
          child: ListTile(
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: screenBody,
    );
  }
}
