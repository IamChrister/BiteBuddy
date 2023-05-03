import 'package:bite_buddy/presentation/bloc/shopping_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddListItemWidget extends StatefulWidget {
  const AddListItemWidget({super.key});

  @override
  State<AddListItemWidget> createState() => _AddListItemWidgetState();
}

class _AddListItemWidgetState extends State<AddListItemWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  String inputStr = "";

  void _addItem(String title) {
    if (BlocProvider.of<ShoppingListBloc>(context).state
        is ShoppingListLoaded) {
      _textEditingController.clear();
      BlocProvider.of<ShoppingListBloc>(context)
          .add(AddItemToShoppingListEvent(title));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(hintText: 'Add new item...'),
            onChanged: (value) {
              inputStr = value;
            },
          ),
        ),
        IconButton(
          onPressed: () {
            if (_textEditingController.text.isNotEmpty) {
              _addItem(inputStr);
            }
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
