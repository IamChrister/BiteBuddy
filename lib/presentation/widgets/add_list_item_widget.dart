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
    ShoppingListState state = BlocProvider.of<ShoppingListBloc>(context).state;
    if (state is! ShoppingListLoading) {
      _textEditingController.clear();
      BlocProvider.of<ShoppingListBloc>(context)
          .add(AddItemToShoppingListEvent(title));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Handle the error messages here if needed
        BlocBuilder<ShoppingListBloc, ShoppingListState>(
            builder: (context, state) {
          if (state is ShoppingListError) {
            String errorMsg = state.message;
            return (Text(
              errorMsg,
              style: const TextStyle(color: Colors.red),
            ));
          } else {
            return Container();
          }
        }),
        Row(
          children: [
            Expanded(
              child: TextField(
                key: const Key("addItemField"),
                controller: _textEditingController,
                decoration: const InputDecoration(hintText: 'Add new item...'),
                onChanged: (value) {
                  inputStr = value;
                },
              ),
            ),
            IconButton(
              key: const Key("addItemButton"),
              onPressed: () {
                if (_textEditingController.text.isNotEmpty) {
                  _addItem(inputStr);
                }
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
