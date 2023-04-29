import 'package:bite_buddy/core/error/failures.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:dartz/dartz.dart';

/// These are contracts, implementation is done in the data layer
abstract class ShoppingListRepository {
  Future<Either<Failure, ShoppingList>> getShoppingList();
  Future<Either<Failure, ShoppingList>> updateShoppingList(
      ShoppingList shoppingList);
}
