// This is the use case for updating the shopping list to add a new item
import 'package:bite_buddy/core/error/failures.dart';
import 'package:bite_buddy/core/util/input_converter.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:dartz/dartz.dart';

/// This is the usecase for when the user presses the 'add' button.
class AddListItemToShoppingListUsecase {
  final InputConverter inputConverter;

  AddListItemToShoppingListUsecase({required this.inputConverter});

  Either<Failure, ShoppingList> call(
      ShoppingList shoppingList, String itemString) {
    // Convert item string to ListItem
    final result = inputConverter.stringToListItem(itemString);
    return result.fold((failure) => Left(InvalidInputFailure()), (listItem) {
      // Cannot add to immutable list so we'll create a new one.
      List<ListItem> items = List.from(shoppingList.items);
      items.add(listItem);

      return Right(ShoppingList(items: items));
    });
  }
}
