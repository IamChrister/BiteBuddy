import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/data/models/shopping_list_model.dart';
import 'package:bite_buddy/features/shopping_list/data/models/list_item_model.dart';

class ShoppingListMapper {
  /// Maps an entity to a model
  ShoppingListModel entityToModel(ShoppingList shoppingList) {
    List<ListItemModel> items = shoppingList.items
        .map((item) => ListItemModel(
            id: item.id, title: item.title, collected: item.collected))
        .toList();

    return ShoppingListModel(items: items);
  }
}
