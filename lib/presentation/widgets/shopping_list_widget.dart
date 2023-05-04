import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:bite_buddy/presentation/widgets/list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bite_buddy/presentation/bloc/shopping_list_bloc.dart';

class ShoppingListWidget extends StatefulWidget {
  const ShoppingListWidget({Key? key}) : super(key: key);

  @override
  State<ShoppingListWidget> createState() => _ShoppingListWidgetState();
}

class _ShoppingListWidgetState extends State<ShoppingListWidget> {
  List<ListItem> _items = [];

  void onUpdateShoppingList() {
    if (BlocProvider.of<ShoppingListBloc>(context).state
        is! ShoppingListLoading) {
      BlocProvider.of<ShoppingListBloc>(context)
          .add(UpdateShoppingListEvent(ShoppingList(items: _items)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ShoppingListBloc, ShoppingListState>(
        builder: (context, state) {
          if (state is ShoppingListLoaded) {
            _items = state.shoppingList.items;
          }
          // _items =
          //     BlocProvider.of<ShoppingListBloc>(context).shoppingList.items;

          bool isLoading = state is ShoppingListLoading;

          return Stack(
            children: [
              ReorderableListView.builder(
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
              ),
              isLoading
                  ? Positioned.fill(
                      child: Container(
                      color: Colors.white.withOpacity(0.6),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ))
                  : Container(),
            ],
          );
        },
      ),
    );
  }

  void onDismissed(int index) {
    if (BlocProvider.of<ShoppingListBloc>(context).state
        is! ShoppingListLoading) {
      setState(() {
        _items.removeAt(index);
      });
      onUpdateShoppingList();
    }
  }

  void onTap(index, item) {
    if (BlocProvider.of<ShoppingListBloc>(context).state
        is! ShoppingListLoading) {
      setState(() {
        _items[index] = item.toggleCollected();
      });
      onUpdateShoppingList();
    }
  }
}
