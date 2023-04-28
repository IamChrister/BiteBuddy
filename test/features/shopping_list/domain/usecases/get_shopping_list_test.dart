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
  late GetShoppingList usecase;
  late MockShoppingListRepository sut;

  setUp(() {
    sut = MockShoppingListRepository();
    usecase = GetShoppingList(repository: sut);
  });

  group('GetShoppingList', () {
    test('Should get shopping list from repository', () async {
      // Arrange
      const expected =
          ShoppingList(items: [ListItem(title: "title", collected: false)]);

      when(sut.getShoppingList())
          .thenAnswer((_) async => const Right(expected));

      // Act
      final result = await usecase();

      // Assert
      result.fold((error) => fail("Expected Right value but got Left"),
          (value) => expect(value, expected));
      verify(sut.getShoppingList());
      verifyNoMoreInteractions(sut);
    });
  });
}
