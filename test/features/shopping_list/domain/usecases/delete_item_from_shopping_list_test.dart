import 'package:bite_buddy/core/util/input_converter.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/add_list_item_to_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/delete_item_from_shopping_list.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_list_item_to_shopping_list_test.mocks.dart';

@GenerateMocks([InputConverter])
void main() {
  late DeleteItemFromShoppingListUsecase sut;

  setUp(() {
    sut = DeleteItemFromShoppingListUsecase();
  });

  group('DeleteListItemToShoppingList', () {
    final ShoppingList tShoppingList =
        ShoppingList(items: [ListItem(title: "test item 1", collected: false)]);
    final tItem = ListItem(title: "test item 1", collected: false);

    final tMissingItem =
        ListItem(title: "No such item should be in list", collected: true);

    test('should remove an item from the shoppingList', () {
      // Arrange
      final expected = ShoppingList(items: []);

      // Act
      final result = sut.call(tShoppingList, tItem);

      // Assert
      result.fold((error) => fail('Expected Right but got Left'),
          (actual) => expect(actual, expected));
    });

    test('should return ItemNotFoundFailure if', () {
      // Arrange

      // Act
      final result = sut.call(tShoppingList, tMissingItem);

      // Assert
      result.fold((error) => expect(error, ItemNotFoundFailure()),
          (actual) => fail('Expected Left but got Right'));
    });
  });
}
