import 'package:bite_buddy/core/error/failures.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:dartz/dartz.dart';

/// Contracts
/// To keep error handling as low as possible, we're returning errors here
abstract class ShoppingListRepository {
  Future<Either<Failure, ShoppingList>> getShoppingList();
  Future<Either<Failure, ShoppingList>> updateShoppingList(
      ShoppingList shoppingList);
}
