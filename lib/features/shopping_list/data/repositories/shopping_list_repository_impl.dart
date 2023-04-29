import 'package:bite_buddy/features/shopping_list/data/datasources/shopping_list_datasource.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:bite_buddy/core/error/failures.dart';
import 'package:bite_buddy/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:dartz/dartz.dart';

/// Implementation of the ShoppinListRepository
class ShoppingListRepositoryImpl implements ShoppingListRepository {
  final ShoppingListDatasource shoppingListDatasource;

  ShoppingListRepositoryImpl({required this.shoppingListDatasource});

  @override
  Future<Either<Failure, ShoppingList>> getShoppingList() {
    // TODO: implement getShoppingList
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ShoppingList>> updateShoppingList(
      ShoppingList shoppingList) {
    // TODO: implement updateShoppingList
    throw UnimplementedError();
  }
}
