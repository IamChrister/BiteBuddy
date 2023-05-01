import 'package:bite_buddy/core/error/failures.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:dartz/dartz.dart';

/// This is the use case for updating the shopping list, including clearing it
class UpdateShoppingListUsecase {
  final ShoppingListRepository repository;

  UpdateShoppingListUsecase({required this.repository});

  Future<Either<Failure, ShoppingList>> call(ShoppingList shoppingList) async {
    return await repository.updateShoppingList(shoppingList);
  }
}
