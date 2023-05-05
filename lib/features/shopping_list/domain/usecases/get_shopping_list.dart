import 'package:bite_buddy/core/error/failures.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:dartz/dartz.dart';

import '../repositories/shopping_list_repository.dart';

/// This is the use case for getting updates on the shopping list
class GetShoppingListUsecase {
  final ShoppingListRepository repository;

  GetShoppingListUsecase({required this.repository});

  /// Gets the state of the shopping list from the database
  Future<Either<Failure, ShoppingList>> call() async {
    return await repository.getShoppingList();
  }
}
