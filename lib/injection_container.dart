import 'package:bite_buddy/core/util/input_converter.dart';
import 'package:bite_buddy/features/shopping_list/data/datasources/shopping_list_datasource.dart';
import 'package:bite_buddy/features/shopping_list/data/repositories/shopping_list_repository_impl.dart';
import 'package:bite_buddy/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/add_list_item_to_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/delete_item_from_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/get_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/update_shopping_list.dart';
import 'package:bite_buddy/presentation/bloc/shopping_list_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

/// Dependency injection
void init() {
  //! Features - ShoppingList feature
  // Bloc - will need to get cleaned on dispose()
  sl.registerFactory(() {
    return ShoppingListBloc(
        getShoppingList: sl(),
        updateShoppingList: sl(),
        deleteItemFromShoppingList: sl(),
        addItemToShoppingList: sl(),
        inputConverter: sl());
  });

  // Use cases
  sl.registerLazySingleton(() => GetShoppingListUsecase(repository: sl()));
  sl.registerLazySingleton(
      () => AddListItemToShoppingListUsecase(inputConverter: sl()));
  sl.registerLazySingleton(() => UpdateShoppingListUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteItemFromShoppingListUsecase());

  // Repository
  sl.registerLazySingleton<ShoppingListRepository>(() => ShoppingListRepositoryImpl(
      shoppingListDatasource:
          sl())); // Whenever we want to instantiate ShoppingListRepository it will resolve to its implementation

  // Datasource
  sl.registerLazySingleton<ShoppingListDatasource>(
      () => ShoppingListDatasourceImpl(client: sl()));

  //! Core
  sl.registerLazySingleton(() => InputConverter());

  //! External
  sl.registerLazySingleton(() => http.Client());
}
