import 'dart:async';
import 'package:eventsource/eventsource.dart';
import '../repositories/shopping_list_repository.dart';

/// This is the use case for getting updates on the shopping list
class StreamShoppingListUsecase {
  final ShoppingListRepository repository;

  StreamShoppingListUsecase({required this.repository});

  // Gets the stream to the database
  Future<EventSource> call() async {
    EventSource stream = await repository.streamShoppingList();

    return stream;
  }
}
