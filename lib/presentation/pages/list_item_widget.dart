import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:flutter/material.dart';

class ListItemWidget extends StatelessWidget {
  final ListItem item;
  final Function(int) onDismissed;
  final Function(int, ListItem) onTap;
  final int index;

  const ListItemWidget(
      {super.key,
      required this.item,
      required this.onDismissed,
      required this.onTap,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.hashCode),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        onDismissed(index);
      },
      child: ListTile(
        onTap: () {
          onTap(index, item);
        },
        title: Text(
          item.title,
          style: TextStyle(
              color: item.collected ? Colors.grey : Colors.black,
              decoration: item.collected ? TextDecoration.lineThrough : null),
        ),
      ),
    );
  }
}
