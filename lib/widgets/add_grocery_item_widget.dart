import 'package:flutter/material.dart';

class AddGroceryItem extends StatefulWidget {
  const AddGroceryItem({super.key});

  @override
  State<AddGroceryItem> createState() {
    return _AddGroceryItemState();
  }
}

class _AddGroceryItemState extends State<AddGroceryItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Your Grocery Item'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(12),
        child: Text('add item'),
      ),
    );
  }
}
