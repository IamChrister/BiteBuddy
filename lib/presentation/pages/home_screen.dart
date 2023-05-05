import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:bite_buddy/presentation/bloc/shopping_list_bloc.dart';
import 'package:bite_buddy/presentation/pages/gpt_screen.dart';
import 'package:bite_buddy/presentation/widgets/add_list_item_widget.dart';
import 'package:bite_buddy/presentation/widgets/shopping_list_widget.dart';
import 'package:bite_buddy/services/gpt_service.dart';
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
  final GPTService _gptService = GPTService();

  void _clearShoppingList() {
    if (BlocProvider.of<ShoppingListBloc>(context).state
        is! ShoppingListLoading) {
      BlocProvider.of<ShoppingListBloc>(context)
          .add(UpdateShoppingListEvent(const ShoppingList(items: [])));
    }
  }

  void _getGPTRecommendation() async {
    final result = await _gptService
        .generateText(BlocProvider.of<ShoppingListBloc>(context).shoppingList);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GPTScreen(
                  results: result,
                )));
  }

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
              onPressed: _getGPTRecommendation,
              icon: const Icon(Icons.android)),
          IconButton(
              onPressed: _clearShoppingList, icon: const Icon(Icons.clear)),
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
