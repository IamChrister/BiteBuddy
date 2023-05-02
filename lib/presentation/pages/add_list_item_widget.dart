import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AddListItemWidget extends StatefulWidget {
  const AddListItemWidget({super.key});

  @override
  State<AddListItemWidget> createState() => _AddListItemWidgetState();
}

class _AddListItemWidgetState extends State<AddListItemWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  String inputStr = "";

  void _addItem(String title) {
    //TODO: Implement
    print("Adding new item: $title");
    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(hintText: 'Add new item...'),
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
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}
