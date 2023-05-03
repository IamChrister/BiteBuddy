import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bite_buddy/presentation/bloc/shopping_list_bloc.dart';

class ShoppingListWidget extends StatefulWidget {
  const ShoppingListWidget({Key? key}) : super(key: key);

  @override
  State<ShoppingListWidget> createState() => _ShoppingListWidgetState();
}

class _ShoppingListWidgetState extends State<ShoppingListWidget> {
  late List<ListItem> _items;

  void onDeleteItem(ListItem item) {
    BlocProvider.of<ShoppingListBloc>(context)
        .add(UpdateShoppingListEvent(ShoppingList(items: _items)));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ShoppingListBloc, ShoppingListState>(
        builder: (context, state) {
          if (state is ShoppingListLoaded) {
            _items = state.shoppingList.items;
            return ReorderableListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
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
                    _items.removeAt(index);
                    onDeleteItem(item);
                    setState(() {});
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
                          decoration: item.collected
                              ? TextDecoration.lineThrough
                              : null),
                    ),
                  ),
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final ListItem item = _items.removeAt(oldIndex);
                  _items.insert(newIndex, item);
                });
              },
            );
          } else if (state is ShoppingListError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
