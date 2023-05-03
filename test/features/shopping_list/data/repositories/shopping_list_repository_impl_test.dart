import 'package:bite_buddy/core/error/exceptions.dart';
import 'package:bite_buddy/core/error/failures.dart';
import 'package:bite_buddy/features/shopping_list/data/datasources/shopping_list_datasource.dart';
import 'package:bite_buddy/features/shopping_list/data/models/list_item_model.dart';
import 'package:bite_buddy/features/shopping_list/data/models/shopping_list_model.dart';
import 'package:bite_buddy/features/shopping_list/data/repositories/shopping_list_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'shopping_list_repository_impl_test.mocks.dart';

@GenerateMocks([ShoppingListDatasource])
void main() {
  late ShoppingListRepositoryImpl sut;
  late MockShoppingListDatasource mockShoppingListDatasource;

  setUp(() {
    mockShoppingListDatasource = MockShoppingListDatasource();
    sut = ShoppingListRepositoryImpl(
        shoppingListDatasource: mockShoppingListDatasource);
  });

  group('ShoppingListRepositoryImpl', () {
    group('getShoppingList', () {
      test(
          'should return a shopping list when the call to datasource is successful',
          () async {
        // Arrange
        var expected = const ShoppingListModel(
            items: [ListItemModel(title: "test item 1", collected: false)]);

        when(mockShoppingListDatasource.getShoppingList())
            .thenAnswer((realInvocation) async => expected);

        // Act
        final result = await sut.getShoppingList();

        // Assert
        result.fold((error) => fail("Expected Right value but got Left"),
            (actual) => expect(actual, expected));
        verify(mockShoppingListDatasource
            .getShoppingList()); // Make sure it was called
      });

      test(
          'should return a server failure when the call to datasource is unsuccessful',
          () async {
        // Arrange
        when(mockShoppingListDatasource.getShoppingList())
            .thenThrow(ServerException());

        // Act
        final result = await sut.getShoppingList();

        // Assert

        result.fold((error) => expect(error, ServerFailure()),
            (actual) => fail("Expected Left value but got Right"));
        verify(mockShoppingListDatasource.getShoppingList());
      });
    });

    group('updateShoppingList', () {
      test(
          'should return a shopping list when the call to datasource is successful',
          () async {
        // Arrange
        var expected = const ShoppingListModel(
            items: [ListItemModel(title: "test item 1", collected: false)]);

        when(mockShoppingListDatasource.updateShoppingList(expected))
            .thenAnswer((realInvocation) async => expected);

        // Act
        final result = await sut.updateShoppingList(expected);

        // Assert
        result.fold((error) => fail("Expected Right value but got Left"),
            (actual) => expect(actual, expected));
        verify(mockShoppingListDatasource.updateShoppingList(
            expected)); // Make sure it was called with the correct data
      });
      test(
          'should return a server failure when the call to datasource is unsuccessful',
          () async {
        // Arrange
        var tShoppingList = const ShoppingListModel(
            items: [ListItemModel(title: "test item 1", collected: false)]);

        when(mockShoppingListDatasource.updateShoppingList(tShoppingList))
            .thenThrow(ServerException());

        // Act
        final result = await sut.updateShoppingList(tShoppingList);

        // Assert
        result.fold((error) => expect(error, ServerFailure()),
            (actual) => fail("Expected Left value but got Right"));
        verify(mockShoppingListDatasource.updateShoppingList(
            tShoppingList)); // Make sure it was called with the correct data
      });
    });
  });
}
