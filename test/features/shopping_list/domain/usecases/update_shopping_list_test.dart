import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/update_shopping_list.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_shopping_list_test.mocks.dart';

@GenerateMocks([ShoppingListRepository])
void main() {
  late UpdateShoppingListUsecase sut;
  late MockShoppingListRepository mockShoppingListRepository;

  setUp(() {
    mockShoppingListRepository = MockShoppingListRepository();
    sut = UpdateShoppingListUsecase(repository: mockShoppingListRepository);
  });

  group('UpdateShoppingList', () {
    test('Updating a shopping list should return the same shopping list',
        () async {
      // Arrange
      var expected = const ShoppingList(
          items: [ListItem(id: "1", title: "title", collected: false)]);

      when(mockShoppingListRepository.updateShoppingList(expected))
          .thenAnswer((_) async => Right(expected));

      // Act
      final result = await sut(expected);

      // Assert
      result.fold((error) => fail("Expected Right value but got Left"),
          (actual) => expect(actual, expected));
      verify(mockShoppingListRepository.updateShoppingList(expected));
      verifyNoMoreInteractions(mockShoppingListRepository);
    });

    //TODO: Add a test for failure case
  });
}
