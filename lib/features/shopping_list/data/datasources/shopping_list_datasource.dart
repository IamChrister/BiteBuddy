import 'dart:convert';
import 'package:bite_buddy/core/constants.dart';
import 'package:bite_buddy/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import '../models/shopping_list_model.dart';

abstract class ShoppingListDatasource {
  /// Calls the Firebase Firestore/Realtime database endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<ShoppingListModel> getShoppingList();

  /// Calls the Firebase Firestore/Realtime database endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<ShoppingListModel> updateShoppingList(ShoppingListModel shoppingList);
}

class ShoppingListDatasourceImpl implements ShoppingListDatasource {
  final http.Client client;

  ShoppingListDatasourceImpl({required this.client});

  @override
  Future<ShoppingListModel> getShoppingList() async {
    final response = await client.get(Uri.parse(realtimeDatabaseUrl));

    if (response.statusCode == 200) {
      return ShoppingListModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ShoppingListModel> updateShoppingList(
      ShoppingListModel shoppingList) async {
    final response = await client.put(Uri.parse(realtimeDatabaseUrl),
        body: shoppingList.toJson());

    if (response.statusCode == 200) {
      return ShoppingListModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
