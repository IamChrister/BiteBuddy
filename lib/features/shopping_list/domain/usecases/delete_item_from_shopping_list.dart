// This is the use case for updating the shopping list to add a new item
import 'package:bite_buddy/core/error/failures.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:dartz/dartz.dart';

/// This is the usecase for when the user deletes an item
class DeleteItemFromShoppingListUsecase {
  DeleteItemFromShoppingListUsecase();

  Either<Failure, ShoppingList> call(ShoppingList shoppingList, ListItem item) {
    // Convert item string to ListItem

    // Cannot add to immutable list so we'll create a new one.
    List<ListItem> items = List<ListItem>.from(shoppingList.items);
    print(
        "Deleting item: item: ${item} shoppingList: ${shoppingList} || Items: ${items} || IndexOf: ${items.indexOf(item)}");

    for (int i = 0; i < items.length; i++) {
      if (items[i].title == item.title) {
        print("GOT A HIT!");
      } else {
        print("No hit");
      }
    }
    bool itemRemoved = items.remove(item);

    if (itemRemoved) {
      return Right(ShoppingList(items: items));
    } else {
      return Left(ItemNotFoundFailure());
    }
  }
}

class ItemNotFoundFailure extends Failure {}
