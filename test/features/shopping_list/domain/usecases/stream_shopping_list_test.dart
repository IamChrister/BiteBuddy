import 'package:bite_buddy/core/constants.dart';
import 'package:bite_buddy/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/stream_shopping_list.dart';
import 'package:eventsource/eventsource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_shopping_list_test.mocks.dart';

@GenerateMocks([ShoppingListRepository])
void main() {
  late StreamShoppingListUsecase sut;
  late MockShoppingListRepository mockShoppingListRepository;

  setUp(() {
    mockShoppingListRepository = MockShoppingListRepository();
    sut = StreamShoppingListUsecase(repository: mockShoppingListRepository);
  });

  group('streamShoppingList', () {
    test('should return an EventSource object', () async {
      // Arrange
      when(mockShoppingListRepository.streamShoppingList()).thenAnswer(
          (realInvocation) =>
              EventSource.connect(Uri.parse(realtimeDatabaseUrl)));

      // Act
      final result = await sut();

      // Assert
      expect(result, isA<EventSource>());
      verify(mockShoppingListRepository.streamShoppingList());
    });
  });
}
