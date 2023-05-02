import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:flutter/material.dart';

class ShoppingListWidget extends StatefulWidget {
  final List<ListItem> items;
  final VoidCallback onDelete;
  const ShoppingListWidget(
      {required this.items, required this.onDelete, Key? key})
      : super(key: key);

  @override
  State<ShoppingListWidget> createState() => _ShoppingListWidgetState();
}

// TODO: Separate ListItemWidget & make everything pretty and stuff
class _ShoppingListWidgetState extends State<ShoppingListWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ReorderableListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          return Dismissible(
            key: ValueKey(item.hashCode),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              color: Colors.red,
              child: Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              widget.onDelete();
            },
            child: ListTile(
              onTap: () {
                setState(() {
                  item.collected = !item.collected;
                });
              },
              title: Text(
                item.title,
                style: TextStyle(
                    color: item.collected ? Colors.grey : Colors.black,
                    decoration:
                        item.collected ? TextDecoration.lineThrough : null),
              ),
            ),
          );
        },
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final ListItem item = widget.items.removeAt(oldIndex);
            widget.items.insert(newIndex, item);
          });
        },
      ),
    );
  }
}
