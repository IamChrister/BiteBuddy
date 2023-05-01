// This is the use case for updating the shopping list to add a new item
import 'package:bite_buddy/core/error/failures.dart';
import 'package:bite_buddy/core/util/input_converter.dart';
import 'package:bite_buddy/features/shopping_list/data/models/list_item_model.dart';
import 'package:bite_buddy/features/shopping_list/data/models/shopping_list_model.dart';
import 'package:dartz/dartz.dart';

class AddListItemToShoppingListUsecase {
  final InputConverter inputConverter;

  AddListItemToShoppingListUsecase({required this.inputConverter});

  Either<Failure, ShoppingListModel> call(
      ShoppingListModel shoppingListModel, String itemString) {
    // Convert item string to ListItemModel
    final result = inputConverter.stringToListItem(itemString);
    return result.fold((failure) => Left(InvalidInputFailure()),
        (listItemModel) {
      // Cannot add to immutable list so we'll create a new one.
      List<ListItemModel> items = List.from(shoppingListModel.items);
      items.add(listItemModel);

      return Right(ShoppingListModel(items: items));
    });
  }
}
