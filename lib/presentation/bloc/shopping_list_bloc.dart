import 'package:bite_buddy/core/constants.dart';
import 'package:bite_buddy/core/util/input_converter.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/add_list_item_to_shopping_list.dart';
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
  //TODO: Implement deleteItem
  final InputConverter inputConverter;

// TODO: Implement updating of the shopping list
  ShoppingListBloc(
      {required this.getShoppingList,
      required this.updateShoppingList,
      required this.addItemToShoppingList,
      required this.inputConverter})
      : super(ShoppingListInitial()) {
    on<AddItemToShoppingListEvent>(_onAddItemToShoppingListEvent);
    on<GetShoppingListEvent>(_onGetShoppingListEvent);
  }

  @override
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

  /// Event that runs when an item is added to the shopping list
  Future<void> _onAddItemToShoppingListEvent(
      AddItemToShoppingListEvent event, Emitter<ShoppingListState> emit) async {
    ShoppingList currentShoppingList = ShoppingList(items: []);
    if (state is ShoppingListLoaded) {
      currentShoppingList = (state as ShoppingListLoaded).shoppingList;
    } else {
      //Initial state
      //TODO: Should actually wait until the shopping list is loaded or handle this some way
    }

    final result = addItemToShoppingList(currentShoppingList, event.newItem);

    // Deal with the result
    result.fold((failure) {
      emit(ShoppingListError(message: INVALID_INPUT_FAILURE_MESSAGE));
    }, (result) async {
      //TODO:emit(Added(shoppingList: result));

      //Call the backend update
      emit(ShoppingListLoading());
      final updated = await updateShoppingList(result);

      updated.fold(
          (error) => emit(ShoppingListError(message: SERVER_FAILURE_MESSAGE)),
          (newShoppingList) {
        //TODO:emit(Updated(shoppingList: newShoppingList));
      });
    });
  }
}
