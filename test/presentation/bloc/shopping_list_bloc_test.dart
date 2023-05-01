import 'package:bite_buddy/core/util/input_converter.dart';
import 'package:bite_buddy/features/shopping_list/data/models/list_item_model.dart';
import 'package:bite_buddy/features/shopping_list/data/models/shopping_list_model.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/add_list_item_model_to_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/get_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/update_shopping_list.dart';
import 'package:bite_buddy/presentation/bloc/shopping_list_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'shopping_list_bloc_test.mocks.dart';

@GenerateMocks([
  GetShoppingListUsecase,
  UpdateShoppingListUsecase,
  AddListItemToShoppingListUsecase,
  InputConverter
])
void main() {
  late ShoppingListBloc sut;
  late MockGetShoppingListUsecase mockGetShoppingListUsecase;
  late MockUpdateShoppingListUsecase mockUpdateShoppingListUsecase;
  late MockAddListItemToShoppingListUsecase
      mockAddListItemToShoppingListUsecase;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockInputConverter = MockInputConverter();
    mockGetShoppingListUsecase = MockGetShoppingListUsecase();
    mockUpdateShoppingListUsecase = MockUpdateShoppingListUsecase();
    mockAddListItemToShoppingListUsecase =
        MockAddListItemToShoppingListUsecase();

    sut = ShoppingListBloc(
        getShoppingList: mockGetShoppingListUsecase,
        updateShoppingList: mockUpdateShoppingListUsecase,
        addItemToShoppingList: mockAddListItemToShoppingListUsecase,
        inputConverter: mockInputConverter);
  });

  group('ShoppingListBloc', () {
    const tListItemModel =
        ListItemModel(title: "test item 1", collected: false);
    const tShoppingListModel = ShoppingListModel(
        items: [ListItemModel(title: "test item 1", collected: false)]);

    test('should emit initialState & initialState should be Empty', () {
      // Assert
      expect(sut.initialState, Empty());
    });

    group('getShoppingList', () {
      test('should ', () {
        // Arrange

        // Act

        // Assert
      });
    });

    group('addItemToShoppingList', () {
      // Mimic what's coming in from the UI
      const itemString = 'Milk';

      //TODO: Delete this since implemented elsewhere?
      test(
          'should call the InputConverter to convert the string to a ListItemModel',
          () async {
        // Arrange
        when(mockInputConverter.stringToListItem(any))
            .thenReturn(const Right(tListItemModel));

        // Act
        sut.add(AddItemToShoppingListEvent("Test item", tShoppingListModel));
        await untilCalled(mockInputConverter.stringToListItem(any));

        // Assert
        verify(mockInputConverter.stringToListItem("Test item"));
      });

      // [] marks state
      blocTest<ShoppingListBloc, ShoppingListState>(
          'should emit [Error] when the input is invalid',
          build: () => sut,
          act: (bloc) {
            when(mockInputConverter.stringToListItem(any))
                .thenReturn(Left(InvalidInputFailure()));

            // Act
            sut.add(
                AddItemToShoppingListEvent("Test item", tShoppingListModel));
          },
          expect: () => [Error(message: INVALID_INPUT_FAILURE_MESSAGE)]);
    });
  });
}
