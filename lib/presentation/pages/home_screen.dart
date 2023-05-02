import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:bite_buddy/injection_container.dart';
import 'package:bite_buddy/presentation/bloc/shopping_list_bloc.dart';
import 'package:bite_buddy/presentation/pages/add_list_item_widget.dart';
import 'package:bite_buddy/presentation/pages/shopping_list_widget.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bite Buddy")),
      body: BlocProvider(
        create: (context) => sl<ShoppingListBloc>(),
        child: HomeBody(),
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({
    super.key,
  });

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  void dispatchGetShoppingList() {
    BlocProvider.of<ShoppingListBloc>(context).add(GetShoppingListEvent());
  }

  @override
  void initState() {
    super.initState();

    dispatchGetShoppingList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(children: [
        // List display area
        BlocBuilder<ShoppingListBloc, ShoppingListState>(
          // Here is how we get access to the bloc
          builder: (context, state) {
            if (state is ShoppingListInitial) {
              return Expanded(
                  child: Placeholder(
                child: TextButton(
                  onPressed: dispatchGetShoppingList,
                  child: Text("Get shopping list"),
                ),
              ));
            } else if (state is ShoppingListLoaded) {
              return ShoppingListWidget(
                items: state.shoppingList.items,
                onDelete: () {
                  print("Delete item");
                },
              );
            } else if (state is ShoppingListLoading) {
              return const Placeholder(
                child: Text('Loading state'),
              );
            } else if (state is ShoppingListError) {
              return const Placeholder(
                child: Text('Error state'),
              );
            } else {
              return const Placeholder(
                child: Text('Else state'),
              );
            }
          },
        ),
        AddListItemWidget(),
      ]),
    );
  }
}
