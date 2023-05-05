import 'package:bite_buddy/core/error/exceptions.dart';
import 'package:bite_buddy/features/shopping_list/data/datasources/shopping_list_datasource.dart';
import 'package:bite_buddy/features/shopping_list/data/mappers/shopping_list_mapper.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:bite_buddy/core/error/failures.dart';
import 'package:bite_buddy/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:eventsource/eventsource.dart';

/// Implementation of the ShoppinListRepository
class ShoppingListRepositoryImpl implements ShoppingListRepository {
  final ShoppingListDatasource shoppingListDatasource;

  ShoppingListRepositoryImpl({required this.shoppingListDatasource});

  /// Get the shopping list from the database.
  /// Will return an empty shopping list if no data is found
  /// For remaining up to date on the database state it is recommended to use streamShoppingList() instead.
  ///
  /// Returns a [ServerFailure] for any errors
  @override
  Future<Either<Failure, ShoppingList>> getShoppingList() async {
    try {
      return Right(await shoppingListDatasource.getShoppingList());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  /// Used to update the state of the shopping list in the database.
  /// Can be used for any type of update including deletion, adding items, clearing the list etc.
  ///
  /// Returns a [ServerFailure] for any errors
  @override
  Future<Either<Failure, ShoppingList>> updateShoppingList(
      ShoppingList shoppingList) async {
    try {
      return Right(await shoppingListDatasource.updateShoppingList(
          ShoppingListMapper().entityToModel(shoppingList)));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  /// Used to get a stream from the database that sends an event every time the database experiences a change from another device.
  @override
  Future<EventSource> streamShoppingList() async {
    return await shoppingListDatasource.streamShoppingList();
  }
}
