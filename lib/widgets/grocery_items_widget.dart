import 'package:flutter/cupertino.dart';
import 'package:shopping_list/data/grocery_items_data.dart';

class GroceryItems extends StatelessWidget {
  const GroceryItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final groceryItem in groceryItems)
          Container(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  child: SizedBox(
                    width: 15.0,
                    height: 15.0,
                    child: DecoratedBox(
                      decoration:
                          BoxDecoration(color: groceryItem.category.color),
                    ),
                  ),
                ),
                Text(groceryItem.name),
                Container(
                  padding: const EdgeInsets.only(right: 15),
                  child: Text(
                    groceryItem.quantity.toString(),
                  ),
                )
              ],
            ),
          )
      ],
    );
  }
}
