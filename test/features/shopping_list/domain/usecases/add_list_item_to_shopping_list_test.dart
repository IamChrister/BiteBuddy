import 'package:bite_buddy/core/util/input_converter.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/add_list_item_to_shopping_list.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_list_item_to_shopping_list_test.mocks.dart';

@GenerateMocks([InputConverter])
void main() {
  late AddListItemToShoppingListUsecase sut;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockInputConverter = MockInputConverter();
    sut = AddListItemToShoppingListUsecase(inputConverter: mockInputConverter);
  });

  group('AddListItemToShoppingList', () {
    //TODO: Test with more cases
    ShoppingList tShoppingList = const ShoppingList(items: []);
    ListItem tListItem =
        const ListItem(id: "1", title: "test item 1", collected: false);
    String newItemName = "test item 1";

    test('should add a new item to the shoppingList', () {
      // Arrange
      ShoppingList expected = ShoppingList(items: [tListItem]);

      when(mockInputConverter.stringToListItem(any))
          .thenAnswer((realInvocation) => Right(tListItem));

      // Act
      final result = sut.call(tShoppingList, newItemName);

      // Assert
      result.fold((error) => fail('Expected Right but got left'),
          (actual) => expect(actual, expected));
    });

    test('should return a failure if the name of the item is empty', () {
      // Arrange
      const emptyName = '  ';
      when(mockInputConverter.stringToListItem(any))
          .thenAnswer((realInvocation) => Left(InvalidInputFailure()));

      // Act
      final result = sut.call(tShoppingList, emptyName);

      // Assert
      result.fold((error) => expect(error, InvalidInputFailure()),
          (actual) => fail('Expected Left but got Right'));
    });
  });
}
