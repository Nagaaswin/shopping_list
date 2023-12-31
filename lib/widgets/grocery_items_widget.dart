import 'package:flutter/material.dart';
import 'package:shopping_list/data/grocery_items_data.dart';

class GroceryItems extends StatelessWidget {
  const GroceryItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
      ),
      body: ListView.builder(
          itemCount: groceryItems.length,
          itemBuilder: (ctx, index) => ListTile(
                leading: Container(
                  height: 24,
                  width: 24,
                  color: groceryItems[index].category.color,
                ),
                title: Text(groceryItems[index].name),
                trailing: Text(groceryItems[index].quantity.toString()),
              )),
    );
  }
}
