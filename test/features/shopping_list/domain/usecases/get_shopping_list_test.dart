import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/get_shopping_list.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'get_shopping_list_test.mocks.dart';

@GenerateMocks([ShoppingListRepository])
void main() {
  late GetShoppingListUsecase sut;
  late MockShoppingListRepository shoppingListRepository;

  setUp(() {
    shoppingListRepository = MockShoppingListRepository();
    sut = GetShoppingListUsecase(repository: shoppingListRepository);
  });

  group('GetShoppingList', () {
    test('Should get shopping list from repository', () async {
      // Arrange
      var expected = const ShoppingList(
          items: [ListItem(id: "1", title: "title", collected: false)]);

      when(shoppingListRepository.getShoppingList())
          .thenAnswer((_) async => Right(expected));

      // Act
      final result = await sut();

      // Assert
      result.fold((error) => fail("Expected Right value but got Left"),
          (actual) => expect(actual, expected));
      verify(shoppingListRepository.getShoppingList());
      verifyNoMoreInteractions(shoppingListRepository);
    });

    //TODO: Add a test for Failure
  });
}
