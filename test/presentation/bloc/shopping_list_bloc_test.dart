import 'package:bite_buddy/core/constants.dart';
import 'package:bite_buddy/core/error/failures.dart';
import 'package:bite_buddy/core/util/input_converter.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/add_list_item_to_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/get_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/update_shopping_list.dart';
import 'package:bite_buddy/presentation/bloc/shopping_list_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'shopping_list_bloc_test.mocks.dart';

// Here we're mostly testing if the states are emitted as expected

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

  void setUpGetShoppingListSuccess(ShoppingList tShoppingList) {
    when(mockGetShoppingListUsecase())
        .thenAnswer((realInvocation) async => Right(tShoppingList));
  }

  void setUpGetShoppingListFailure() {
    when(mockGetShoppingListUsecase())
        .thenAnswer((realInvocation) async => Left(ServerFailure()));
  }

  void setUpAddListItemToShoppingListFailure() {
    when(mockAddListItemToShoppingListUsecase(any, any))
        .thenReturn(Left(InvalidInputFailure()));
  }

  void setUpAddListItemToShoppingListSuccess(ShoppingList tShoppingList) {
    when(mockAddListItemToShoppingListUsecase(any, any))
        .thenReturn(Right(tShoppingList));
  }

  void setUpUpdateShoppingListFailure(ShoppingList tShoppingList) {
    when(mockUpdateShoppingListUsecase(tShoppingList))
        .thenAnswer((realInvocation) async => Left(ServerFailure()));
  }

  void setUpUpdateShoppingListSuccess(ShoppingList tShoppingList) {
    when(mockUpdateShoppingListUsecase(tShoppingList))
        .thenAnswer((realInvocation) async => Right(tShoppingList));
  }

  group('ShoppingListBloc', () {
    const tItemName = "test item 1";
    const tEmptyShoppingList = ShoppingList(items: []);
    var tShoppingList =
        ShoppingList(items: [ListItem(title: "test item 1", collected: false)]);

    test('should emit initialState & initialState should be Empty', () {
      // Assert
      expect(sut.initialState, ShoppingListInitial());
    });

    group('getShoppingList', () {
      blocTest('should emit [Loading, Loaded] when data is gotten successfully',
          build: () => sut,
          act: (bloc) async {
            setUpGetShoppingListSuccess(tShoppingList);

            sut.add(GetShoppingListEvent());
          },
          expect: () => [
                ShoppingListLoading(),
                ShoppingListLoaded(shoppingList: tShoppingList)
              ]);

      blocTest('should emit [Loading, Error] when getting data fails',
          build: () => sut,
          act: (bloc) async {
            setUpGetShoppingListFailure();

            sut.add(GetShoppingListEvent());
          },
          expect: () => [
                ShoppingListLoading(),
                ShoppingListError(message: SERVER_FAILURE_MESSAGE)
              ]);
    });

    //TODO: Test server error
    group('addItemToShoppingList', () {
      const tEmptyName = "   ";
      // [] marks state
      blocTest<ShoppingListBloc, ShoppingListState>(
          'should emit [ShoppingListError] when the input is invalid',
          build: () => sut,
          seed: () => ShoppingListLoaded(shoppingList: tEmptyShoppingList),
          act: (bloc) {
            setUpAddListItemToShoppingListFailure();

            sut.add(AddItemToShoppingListEvent(
                tEmptyName, (bloc.state as ShoppingListLoaded).shoppingList));
          },
          expect: () =>
              [ShoppingListError(message: INVALID_INPUT_FAILURE_MESSAGE)],
          verify: (sut) => verify(mockAddListItemToShoppingListUsecase(
              tEmptyShoppingList, tEmptyName)));

      //TODO: Test for when the input is valid but the upload to server fails. Should emit [ShoppingListError(message: SERVER_FAILURE_MESSAGE)]

      //TODO: Complete update stuff before going here
      blocTest<ShoppingListBloc, ShoppingListState>(
          'Should emit [ShoppingListLoading, ShoppingListLoaded] when the input is correct',
          build: () => sut,
          seed: () => ShoppingListLoaded(shoppingList: tEmptyShoppingList),
          act: (bloc) {
            setUpAddListItemToShoppingListSuccess(tShoppingList);

            sut.add(AddItemToShoppingListEvent("Test item 1",
                (bloc.state as ShoppingListLoaded).shoppingList));
          },
          expect: () => [ShoppingListLoaded(shoppingList: tShoppingList)]);
    });
  });
}
