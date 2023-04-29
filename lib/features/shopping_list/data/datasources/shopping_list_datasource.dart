import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';

abstract class ShoppingListDatasource {
  /// Calls the Firebase Firestore/Realtime database endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<ShoppingList> getShoppingList();

  /// Calls the Firebase Firestore/Realtime database endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<ShoppingList> updateShoppingList(ShoppingList shoppingList);
}
