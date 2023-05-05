import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:bite_buddy/presentation/bloc/shopping_list_bloc.dart';
import 'package:bite_buddy/presentation/widgets/add_list_item_widget.dart';
import 'package:bite_buddy/presentation/widgets/shopping_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
  The main screen for interacting with the shopping list
*/
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Clear the entire list
  void _clearShoppingList() {
    if (BlocProvider.of<ShoppingListBloc>(context).state
        is! ShoppingListLoading) {
      BlocProvider.of<ShoppingListBloc>(context)
          .add(UpdateShoppingListEvent(const ShoppingList(items: [])));
    }
  }

  /// Gets the shopping list on initialisation
  void dispatchGetShoppingList() {
    BlocProvider.of<ShoppingListBloc>(context).add(StreamShoppingListEvent());
  }

  @override
  void initState() {
    super.initState();

    dispatchGetShoppingList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bite Buddy"),
        actions: [
          IconButton(
              onPressed: _clearShoppingList, icon: const Icon(Icons.clear))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: const [
          ShoppingListWidget(),
          AddListItemWidget(),
        ]),
      ),
    );
  }
}
