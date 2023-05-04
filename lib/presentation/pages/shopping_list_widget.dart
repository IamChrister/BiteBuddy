import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:bite_buddy/presentation/pages/list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bite_buddy/presentation/bloc/shopping_list_bloc.dart';

class ShoppingListWidget extends StatefulWidget {
  const ShoppingListWidget({Key? key}) : super(key: key);

  @override
  State<ShoppingListWidget> createState() => _ShoppingListWidgetState();
}

class _ShoppingListWidgetState extends State<ShoppingListWidget> {
  late List<ListItem> _items = [];

  void onUpdateShoppingList() {
    BlocProvider.of<ShoppingListBloc>(context)
        .add(UpdateShoppingListEvent(ShoppingList(items: _items)));
  }

  //TODO: Add a small loading icon as the last item in the list if the shoppinglist is not loaded.
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ShoppingListBloc, ShoppingListState>(
        builder: (context, state) {
          if (state is ShoppingListLoaded) {
            _items = state.shoppingList.items;
          }
          return ReorderableListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              return ListItemWidget(
                  key: ValueKey(item.hashCode),
                  item: item,
                  index: index,
                  onDismissed: onDismissed,
                  onTap: onTap);
            },
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final ListItem item = _items.removeAt(oldIndex);
                _items.insert(newIndex, item);
              });

              //onUpdateShoppingList();
            },
          );
        },
      ),
    );
  }

  void onDismissed(int index) {
    setState(() {
      _items.removeAt(index);
    });
    onUpdateShoppingList();
  }

  void onTap(index, item) {
    setState(() {
      _items[index] = item.toggleCollected();
    });
    //onUpdateShoppingList();
  }
}
