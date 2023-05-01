import 'package:bite_buddy/core/error/exceptions.dart';
import 'package:bite_buddy/features/shopping_list/data/datasources/shopping_list_datasource.dart';
import 'package:bite_buddy/features/shopping_list/data/mappers/shopping_list_mapper.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:bite_buddy/core/error/failures.dart';
import 'package:bite_buddy/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:dartz/dartz.dart';

/// Implementation of the ShoppinListRepository
class ShoppingListRepositoryImpl implements ShoppingListRepository {
  final ShoppingListDatasource shoppingListDatasource;

  ShoppingListRepositoryImpl({required this.shoppingListDatasource});

  @override
  Future<Either<Failure, ShoppingList>> getShoppingList() async {
    try {
      return Right(await shoppingListDatasource.getShoppingList());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ShoppingList>> updateShoppingList(
      ShoppingList shoppingList) async {
    try {
      //TODO: Check if I'm doing this correctly, do I need the mapper or is this bs?
      return Right(await shoppingListDatasource.updateShoppingList(
          ShoppingListMapper().entityToModel(shoppingList)));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
