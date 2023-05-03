import 'dart:async';

import 'package:bite_buddy/core/error/failures.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:dartz/dartz.dart';
import 'package:eventsource/eventsource.dart';

import '../repositories/shopping_list_repository.dart';

/// This is the use case for getting updates on the shopping list
class StreamShoppingListUsecase {
  final ShoppingListRepository repository;

  StreamShoppingListUsecase({required this.repository});

  Future<EventSource> call() async {
    EventSource stream = await repository.streamShoppingList();

    return stream;
    //   return stream;
  }
}
