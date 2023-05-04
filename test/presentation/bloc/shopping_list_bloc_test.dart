import 'dart:async';
import 'package:bite_buddy/core/constants.dart';
import 'package:bite_buddy/core/error/failures.dart';
import 'package:bite_buddy/core/util/input_converter.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/add_list_item_to_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/delete_item_from_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/get_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/stream_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/update_shopping_list.dart';
import 'package:bite_buddy/presentation/bloc/shopping_list_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:eventsource/eventsource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../features/shopping_list/data/datasources/shopping_list_datasource_test.mocks.dart';
import 'shopping_list_bloc_test.mocks.dart';

// Here we're mostly testing if the states are emitted as expected
@GenerateMocks([
  GetShoppingListUsecase,
  UpdateShoppingListUsecase,
  AddListItemToShoppingListUsecase,
  DeleteItemFromShoppingListUsecase,
  StreamShoppingListUsecase,
  InputConverter
])
void main() {
  late ShoppingListBloc sut;
  late MockGetShoppingListUsecase mockGetShoppingListUsecase;
  late MockUpdateShoppingListUsecase mockUpdateShoppingListUsecase;
  late MockStreamShoppingListUsecase mockStreamShoppingListUsecase;
  late MockDeleteItemFromShoppingListUsecase
      mockDeleteItemFromShoppingListUsecase;
  late MockAddListItemToShoppingListUsecase
      mockAddListItemToShoppingListUsecase;
  late MockInputConverter mockInputConverter;
  late MockEventSource mockEventSource;

  setUp(() {
    mockEventSource = MockEventSource();
    mockInputConverter = MockInputConverter();
    mockGetShoppingListUsecase = MockGetShoppingListUsecase();
    mockUpdateShoppingListUsecase = MockUpdateShoppingListUsecase();
    mockDeleteItemFromShoppingListUsecase =
        MockDeleteItemFromShoppingListUsecase();
    mockAddListItemToShoppingListUsecase =
        MockAddListItemToShoppingListUsecase();
    mockStreamShoppingListUsecase = MockStreamShoppingListUsecase();

    sut = ShoppingListBloc(
        getShoppingList: mockGetShoppingListUsecase,
        updateShoppingList: mockUpdateShoppingListUsecase,
        deleteItemFromShoppingList: mockDeleteItemFromShoppingListUsecase,
        addItemToShoppingList: mockAddListItemToShoppingListUsecase,
        streamShoppingList: mockStreamShoppingListUsecase,
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

  void setUpUpdateShoppingListSuccess(ShoppingList tShoppingList) {
    when(mockUpdateShoppingListUsecase(any))
        .thenAnswer((realInvocation) async => Right(tShoppingList));
  }

  void setUpUpdateShoppingListFailure() {
    when(mockUpdateShoppingListUsecase(any))
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

  void setUpDeleteItemFromShoppingListSuccess(ShoppingList shoppingList) {
    when(mockDeleteItemFromShoppingListUsecase(any, any))
        .thenReturn(Right(shoppingList));
  }

  const tEmptyName = "   ";
  const tItemName = "test item 1";
  const tEmptyShoppingList = ShoppingList(items: []);
  var tListItem =
      const ListItem(id: "1", title: "test item 1", collected: false);
  const tShoppingList = ShoppingList(
      items: [ListItem(id: "1", title: "test item 1", collected: false)]);

  group('ShoppingListBloc', () {
    test('should emit initialState & initialState should be Empty', () {
      // Assert
      expect(sut.initialState, ShoppingListInitial());
    });

    //TODO: unsure of what to test here
    group('streamShoppingList', () {
      //TODO: Try different data formats
      blocTest<ShoppingListBloc, ShoppingListState>(
          'should emit [ShoppingListLoadedFromStreamEvent] when a "put" event is received',
          build: () => sut,
          act: (bloc) async {
            when(mockStreamShoppingListUsecase())
                .thenAnswer((realInvocation) async => mockEventSource);
            when(mockEventSource.listen((any))).thenAnswer((realInvocation) {
              final onEvent =
                  realInvocation.positionalArguments[0] as void Function(Event);
              //TODO: Continue here, not sure what the data should be
              onEvent(Event(event: "put", id: ""));
              return StreamController<Event>().stream.listen((event) {});
            });

            bloc.add(StreamShoppingListEvent());
          },
          expect: () =>
              //TODO: Why is this SHoppingListLoaded, not ShoppingListLoadedFromStreamEvent?
              [ShoppingListLoaded(shoppingList: const ShoppingList(items: []))]);
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

    group('updateShoppingList', () {
      blocTest('Should emit an error on server failure',
          build: () => sut,
          act: (bloc) async {
            setUpUpdateShoppingListFailure();

            sut.add(UpdateShoppingListEvent(tShoppingList));
          },
          expect: () => [
                ShoppingListLoading(),
                ShoppingListError(message: SERVER_FAILURE_MESSAGE)
              ]);
      blocTest('Should Update the shopping list',
          build: () => sut,
          act: (bloc) async {
            setUpUpdateShoppingListSuccess(tShoppingList);

            sut.add(UpdateShoppingListEvent(tShoppingList));
          },
          expect: () => [
                ShoppingListLoading(),
                ShoppingListLoaded(shoppingList: tShoppingList)
              ],
          verify: (sut) =>
              verify(mockUpdateShoppingListUsecase(tShoppingList)));
    });

    group('addItemToShoppingList', () {
      // [] marks state
      blocTest<ShoppingListBloc, ShoppingListState>(
          'should emit [ShoppingListError] when the input is invalid',
          build: () => sut,
          seed: () => ShoppingListLoaded(shoppingList: tEmptyShoppingList),
          act: (bloc) {
            setUpAddListItemToShoppingListFailure();

            sut.add(AddItemToShoppingListEvent(tEmptyName));
          },
          expect: () =>
              [ShoppingListError(message: INVALID_INPUT_FAILURE_MESSAGE)],
          verify: (sut) => verify(mockAddListItemToShoppingListUsecase(
              tEmptyShoppingList, tEmptyName)));

      blocTest<ShoppingListBloc, ShoppingListState>(
          'should emit [ShoppingListLoading, ShoppingListError] when server fails',
          build: () => sut,
          seed: () => ShoppingListLoaded(shoppingList: tEmptyShoppingList),
          act: (bloc) {
            setUpAddListItemToShoppingListSuccess(tShoppingList);
            setUpUpdateShoppingListFailure();

            sut.add(AddItemToShoppingListEvent(tItemName));
          },
          expect: () => [
                ShoppingListLoading(),
                ShoppingListError(message: SERVER_FAILURE_MESSAGE)
              ],
          verify: (sut) => verify(mockAddListItemToShoppingListUsecase(
              tEmptyShoppingList, tItemName)));

      blocTest<ShoppingListBloc, ShoppingListState>(
          'should emit [ShoppingListLoading, ShoppingListLoaded] when item is added',
          build: () => sut,
          seed: () => ShoppingListLoaded(shoppingList: tEmptyShoppingList),
          act: (bloc) {
            setUpAddListItemToShoppingListSuccess(tShoppingList);
            setUpUpdateShoppingListSuccess(tShoppingList);

            // Item is added to the current shopping list which is empty
            sut.add(AddItemToShoppingListEvent(tItemName));
          },
          expect: () => [
                ShoppingListLoading(),
                ShoppingListLoaded(shoppingList: tShoppingList)
              ],
          verify: (sut) => verify(mockAddListItemToShoppingListUsecase(
              tEmptyShoppingList, tItemName)));
    });

    group('deleteItemFromShoppingList', () {
      blocTest<ShoppingListBloc, ShoppingListState>(
          'Sshould emit [ShoppingListError] when item does not exist in the list',
          build: () => sut,
          seed: () => ShoppingListLoaded(shoppingList: tEmptyShoppingList),
          act: (bloc) {
            // Set up the mock for failure
            when(mockDeleteItemFromShoppingListUsecase(any, any))
                .thenReturn(Left(ItemNotFoundFailure()));

            sut.add(DeleteItemFromShoppingListEvent(tListItem));
          },
          expect: () =>
              [ShoppingListError(message: ITEM_NOT_FOUND_FAILURE_MESSAGE)],
          verify: (bloc) => (mockDeleteItemFromShoppingListUsecase(
              tShoppingList, tListItem)));

      blocTest<ShoppingListBloc, ShoppingListState>(
          'Sshould emit [ShoppingListLoading, ShoppingListError] when the server update fails',
          build: () => sut,
          seed: () => ShoppingListLoaded(shoppingList: tShoppingList),
          act: (bloc) {
            setUpDeleteItemFromShoppingListSuccess(tEmptyShoppingList);
            setUpUpdateShoppingListFailure();

            sut.add(DeleteItemFromShoppingListEvent(tListItem));
          },
          expect: () => [
                ShoppingListLoading(),
                ShoppingListError(message: SERVER_FAILURE_MESSAGE)
              ]);

      blocTest<ShoppingListBloc, ShoppingListState>(
          'Sshould emit [ShoppingListLoading, ShoppingListLoaded] when item is deleted',
          build: () => sut,
          seed: () => ShoppingListLoaded(shoppingList: tShoppingList),
          act: (bloc) {
            setUpDeleteItemFromShoppingListSuccess(tEmptyShoppingList);
            setUpUpdateShoppingListSuccess(tEmptyShoppingList);

            sut.add(DeleteItemFromShoppingListEvent(tListItem));
          },
          expect: () => [
                ShoppingListLoading(),
                ShoppingListLoaded(shoppingList: tEmptyShoppingList)
              ]);
    });
  });
}
