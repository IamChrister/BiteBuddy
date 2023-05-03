import 'package:bite_buddy/core/constants.dart';
import 'package:bite_buddy/core/util/input_converter.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/add_list_item_to_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/delete_item_from_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/get_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/update_shopping_list.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'shopping_list_event.dart';
part 'shopping_list_state.dart';

class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  final GetShoppingListUsecase getShoppingList;
  final UpdateShoppingListUsecase updateShoppingList;
  final AddListItemToShoppingListUsecase addItemToShoppingList;
  final DeleteItemFromShoppingListUsecase deleteItemFromShoppingList;
  final InputConverter inputConverter;

  ShoppingListBloc(
      {required this.getShoppingList,
      required this.updateShoppingList,
      required this.addItemToShoppingList,
      required this.deleteItemFromShoppingList,
      required this.inputConverter})
      : super(ShoppingListInitial()) {
    on<AddItemToShoppingListEvent>(_onAddItemToShoppingListEvent);
    on<GetShoppingListEvent>(_onGetShoppingListEvent);
    on<UpdateShoppingListEvent>(_onUpdateShoppingListEvent);
    on<DeleteItemFromShoppingListEvent>(_onDeleteItemFromShoppingListEvent);
  }

  ShoppingListState get initialState => ShoppingListInitial();

  Future<void> _onGetShoppingListEvent(
      GetShoppingListEvent event, Emitter<ShoppingListState> emit) async {
    emit(ShoppingListLoading());
    final result = await getShoppingList();
    result.fold(
        (error) => emit(ShoppingListError(message: SERVER_FAILURE_MESSAGE)),
        (shoppingList) {
      emit(ShoppingListLoaded(shoppingList: shoppingList));
    });
  }

  Future<void> _onDeleteItemFromShoppingListEvent(
      DeleteItemFromShoppingListEvent event,
      Emitter<ShoppingListState> emit) async {
    /// Should
    /// 1. Delete the item from shoppinglist
    /// 2. Should emit [Error] if the item is not in the shopping list
    /// 3. Update the shopping list to a new state and emit [ShoppingListLoaded on success]
    /// 4. Emit [Error] if the server update fails

    if (state is ShoppingListLoaded) {
      final result = deleteItemFromShoppingList(
          (state as ShoppingListLoaded).shoppingList, event.item);

      result.fold(
          (failure) =>
              emit(ShoppingListError(message: ITEM_NOT_FOUND_FAILURE_MESSAGE)),
          (res) async {
        emit(ShoppingListLoading());

        final updated = await updateShoppingList(res);

        updated.fold(
            (error) => emit(ShoppingListError(message: SERVER_FAILURE_MESSAGE)),
            (newShoppingList) =>
                emit(ShoppingListLoaded(shoppingList: newShoppingList)));
      });
    }
  }

  Future<void> _onUpdateShoppingListEvent(
      UpdateShoppingListEvent event, Emitter<ShoppingListState> emit) async {
    // Actually probably should have a different effect since it's a bit different from the initial load maybe in the UI
    emit(ShoppingListLoading());
    final updateResult = await updateShoppingList(event.shoppingList);

    updateResult.fold(
        (failure) => emit(ShoppingListError(message: SERVER_FAILURE_MESSAGE)),
        (result) {
      emit(ShoppingListLoaded(shoppingList: result));
    });
  }

  /// Event that runs when an item is added to the shopping list
  Future<void> _onAddItemToShoppingListEvent(
      AddItemToShoppingListEvent event, Emitter<ShoppingListState> emit) async {
    //TODO: Handle what happens if the item with the same title is added again

    ShoppingList currentShoppingList = const ShoppingList(items: []);
    if (state is ShoppingListLoaded) {
      currentShoppingList = (state as ShoppingListLoaded).shoppingList;
    }
    final result = addItemToShoppingList(currentShoppingList, event.newItem);

    await result.fold((failure) {
      emit(ShoppingListError(message: INVALID_INPUT_FAILURE_MESSAGE));
    }, (result) async {
      emit(ShoppingListLoading());
      final updated = await updateShoppingList(result);

      updated.fold(
          (error) => emit(ShoppingListError(message: SERVER_FAILURE_MESSAGE)),
          (newShoppingList) =>
              emit(ShoppingListLoaded(shoppingList: newShoppingList)));
    });
  }
}
