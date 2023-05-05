// This is the use case for updating the shopping list to add a new item
import 'package:bite_buddy/core/error/failures.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:dartz/dartz.dart';

/// This is the usecase for when the user deletes an item
class DeleteItemFromShoppingListUsecase {
  DeleteItemFromShoppingListUsecase();

  /// Removes the item from the shopping list
  ///
  /// Returns [ItemNotFoundFailure] if item to be removed is not present in the shopping list
  Either<Failure, ShoppingList> call(ShoppingList shoppingList, ListItem item) {
    List<ListItem> items = List<ListItem>.from(shoppingList.items);

    bool itemRemoved = items.remove(item);
    if (itemRemoved) {
      return Right(ShoppingList(items: items));
    } else {
      return Left(ItemNotFoundFailure());
    }
  }
}

class ItemNotFoundFailure extends Failure {}
