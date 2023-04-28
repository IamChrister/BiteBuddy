import 'package:bite_buddy/core/error/failures.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:dartz/dartz.dart';

import '../repositories/shopping_list_repository.dart';

class GetShoppingList {
  final ShoppingListRepository repository;

  GetShoppingList({required this.repository});

  Future<Either<Failure, ShoppingList>> call() async {
    return await repository.getShoppingList();
  }
}
