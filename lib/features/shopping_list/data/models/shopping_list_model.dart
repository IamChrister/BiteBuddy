import 'package:bite_buddy/features/shopping_list/data/models/list_item_model.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';

class ShoppingListModel extends ShoppingList {
  const ShoppingListModel({required List<ListItemModel> items}) : super(items: items);

  // A factory to enable casting from JSON to ShoppingListModel
  factory ShoppingListModel.fromJson(Map<String, dynamic> json) {
    // Since ListItemModel also requires conversion from JSON we need to map over each item and run .fromJson on each one.
    var itemsFromJson = json['items'] as List;
    List<ListItemModel> items =
        itemsFromJson.map((item) => ListItemModel.fromJson(item)).toList();
    return ShoppingListModel(items: items);
  }

  Map<String, dynamic> toJson() {
    return {
      "items": (items as List<ListItemModel>).map((item) => item.toJson())
    };
  }
}
