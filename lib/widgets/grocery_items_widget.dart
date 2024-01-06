import 'dart:convert';
import 'dart:developer';

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
  bool _loadingItems = false;
  String? _error;

  @override
  initState() {
    _loadItems();
    super.initState();
  }

  _loadItems() async {
    _loadingItems = true;
    final url = Uri.https(
        'angular-backend-4c6f4-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-list.json');
    try {
      http.Response response = await http.get(url);
      if (response.statusCode >= 400) {
        setState(() {
          log('Error while fetching data!!', error: response.statusCode);
          _error = 'Failed to fetch data';
        });
        return;
      }
      if (response.body == 'null') {
        setState(() {
          _loadingItems = false;
        });
        return;
      }
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
    } catch (error) {
      log("Error occurred while loading items", error: error);
    }
  }

  _addItem() async {
    final newItem = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const AddGroceryItem()));

    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  _removeItem(GroceryItem groceryItem) async {
    var index = _groceryItems.indexOf(groceryItem);
    setState(() {
      _groceryItems.remove(groceryItem);
    });
    final url = Uri.https(
        'angular-backend-4c6f4-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-list/${groceryItem.id}.json');
    http.Response response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        log('Error while deleting data!!', error: response.statusCode);
        _groceryItems.insert(index, groceryItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget screenBody =
        const Center(child: Text('No item to display. Add a new item'));
    if (_loadingItems) {
      screenBody = const Center(child: CircularProgressIndicator());
    }

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
    if (_error != null) {
      screenBody = Center(
        child: Text(_error!),
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
