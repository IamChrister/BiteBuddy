import 'package:bite_buddy/core/error/failures.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateShoppingList {
  final ShoppingListRepository repository;

  UpdateShoppingList({required this.repository});

  Future<Either<Failure, ShoppingList>> call(ShoppingList shoppingList) async {
    return await repository.updateShoppingList(shoppingList);
  }
}
