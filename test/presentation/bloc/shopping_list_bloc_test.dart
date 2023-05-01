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
    const tItemName = "test item 1";
    const tEmptyShoppingList = ShoppingListModel(items: []);
    const tShoppingListModel = ShoppingListModel(
        items: [ListItemModel(title: "test item 1", collected: false)]);

    test('should emit initialState & initialState should be Empty', () {
      // Assert
      expect(sut.initialState, Empty());
    });

    group('getShoppingList', () {
      // blocTest('should emit [Loading, Loaded] when data is gotten successfully',
      //     build: () => sut,
      //     act: (bloc) async {
      //       when(mockGetShoppingListUsecase()).thenAnswer(
      //           (realInvocation) async => const Right(tShoppingListModel));

      //       sut.add(GetShoppingListEvent());
      //     },
      //     expect: () => [Loading(), Loaded(shoppingList: tShoppingListModel)]);
    });

    group('addItemToShoppingList', () {
      // [] marks state
      blocTest<ShoppingListBloc, ShoppingListState>(
          'should emit [Error] when the input is invalid',
          build: () => sut,
          act: (bloc) {
            const emptyName = "   ";
            when(mockAddListItemToShoppingListUsecase(
                    tEmptyShoppingList, emptyName))
                .thenReturn(Left(InvalidInputFailure()));

            // Act
            sut.add(AddItemToShoppingListEvent(emptyName, tEmptyShoppingList));
          },
          expect: () => [Error(message: INVALID_INPUT_FAILURE_MESSAGE)]);

      blocTest<ShoppingListBloc, ShoppingListState>(
          'should emit [Updated] when an item is added',
          build: () => sut,
          act: (bloc) {
            when(mockAddListItemToShoppingListUsecase(
                    tEmptyShoppingList, tItemName))
                .thenReturn(Right(tShoppingListModel));

            // Act
            sut.add(AddItemToShoppingListEvent(tItemName, tEmptyShoppingList));
          },
          expect: () => [Updated()],
          verify: (sut) => verify(mockAddListItemToShoppingListUsecase(
              tEmptyShoppingList, tItemName)));
    });
  });
}
