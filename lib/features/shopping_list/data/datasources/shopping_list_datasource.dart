import 'dart:convert';
import 'package:bite_buddy/core/constants.dart';
import 'package:bite_buddy/core/error/exceptions.dart';
import 'package:eventsource/eventsource.dart';
import 'package:http/http.dart' as http;
import '../models/shopping_list_model.dart';

abstract class ShoppingListDatasource {
  /// Calls the Firebase Realtime database endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<ShoppingListModel> getShoppingList();

  /// Gets the stream to Firebase Realtime database endpoint
  Future<EventSource> streamShoppingList();

  /// Calls the Firebase Realtime database endpoint
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
      // If the decoded json is null then there is no data currently.
      final decodedJson = json.decode(response.body);
      if (decodedJson == null) {
        return const ShoppingListModel(items: []);
      } else {
        return ShoppingListModel.fromJson(decodedJson);
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ShoppingListModel> updateShoppingList(
      ShoppingListModel shoppingList) async {
    final response = await client.put(Uri.parse(realtimeDatabaseUrl),
        body: jsonEncode(shoppingList));

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      if (decodedJson == null) {
        return const ShoppingListModel(items: []);
      } else {
        return ShoppingListModel.fromJson(jsonDecode(response.body));
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<EventSource> streamShoppingList() async {
    return await EventSource.connect(Uri.parse(realtimeDatabaseUrl));
  }
}
