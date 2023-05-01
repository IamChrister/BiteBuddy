import 'package:bite_buddy/core/util/input_converter.dart';
import 'package:bite_buddy/features/shopping_list/data/models/list_item_model.dart';
import 'package:bite_buddy/features/shopping_list/data/models/shopping_list_model.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/add_list_item_model_to_shopping_list.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_list_item_model_to_shopping_list_test.mocks.dart';

@GenerateMocks([InputConverter])
void main() {
  late AddListItemToShoppingListUsecase sut;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockInputConverter = MockInputConverter();
    sut = AddListItemToShoppingListUsecase(inputConverter: mockInputConverter);
  });

  group('AddListItemModelToShoppingList', () {
    //TODO: Test with more cases
    ShoppingListModel tShoppingListModel = const ShoppingListModel(items: []);
    ListItemModel tListItemModel =
        const ListItemModel(title: "test item 1", collected: false);
    String newItemName = "test item 1";

    test('should call the inputConverter to convert the input', () {
      // Arrange
      when(mockInputConverter.stringToListItem(any))
          .thenAnswer((realInvocation) => Right(tListItemModel));

      // Act
      sut.call(tShoppingListModel, newItemName);

      // Assert
      verify(mockInputConverter.stringToListItem(newItemName));
    });

    test('should add a new item to the shoppingListModel', () {
      // Arrange
      ShoppingListModel expected = ShoppingListModel(items: [tListItemModel]);

      when(mockInputConverter.stringToListItem(any))
          .thenAnswer((realInvocation) => Right(tListItemModel));

      // Act
      final result = sut.call(tShoppingListModel, newItemName);

      // Assert
      result.fold((error) => fail('Expected Right but got left'),
          (actual) => expect(actual, expected));
    });

    test('should return a failure if the name of the item is empty', () {
      // Arrange
      final emptyName = '  ';
      when(mockInputConverter.stringToListItem(any))
          .thenAnswer((realInvocation) => Left(InvalidInputFailure()));

      // Act
      final result = sut.call(tShoppingListModel, emptyName);

      // Assert
      result.fold((error) => expect(error, InvalidInputFailure()),
          (actual) => fail('Expected Left but got Right'));
    });
  });
}
