import 'package:bite_buddy/core/error/failures.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:dartz/dartz.dart';

/// This is the use case for updating the shopping list in the backend, including clearing it
/// Takes as input a ShoppingList
/// Calls on the repository with the given shoppingList
/// Repository updates the server state
class UpdateShoppingListUsecase {
  final ShoppingListRepository repository;

  UpdateShoppingListUsecase({required this.repository});

  /// Returns
  Future<Either<Failure, ShoppingList>> call(ShoppingList shoppingList) async {
    return await repository.updateShoppingList(shoppingList);
  }
}
