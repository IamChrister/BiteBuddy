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
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bite Buddy")),
      body: BlocProvider(
        create: (context) => sl<ShoppingListBloc>(),
        child: buildBody(),
      ),
    );
  }

  Padding buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          // List display area
          Expanded(
            child: BlocBuilder<ShoppingListBloc, ShoppingListState>(
              // Here is how we get access to the bloc
              builder: (context, state) {
                if (state is Loading) {
                  return const Placeholder(
                    child: Text('Empty state'),
                  );
                }

                return ShoppingListWidget(
                  items: [
                    ListItem(title: "item 1", collected: true),
                    ListItem(title: "item 2", collected: false),
                    ListItem(title: "item 3", collected: false)
                  ],
                  onDelete: () {
                    print("Delete item");
                  },
                );
              },
            ),
          ),
          AddListItemWidget()
        ],
      ),
    );
  }
}
