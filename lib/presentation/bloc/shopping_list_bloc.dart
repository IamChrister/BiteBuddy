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
  final InputConverter inputConverter;

// TODO: Implement updating of the shopping list
  ShoppingListBloc(
      {required this.getShoppingList,
      required this.updateShoppingList,
      required this.addItemToShoppingList,
      required this.inputConverter})
      : super(Empty()) {
    on<AddItemToShoppingListEvent>(_onAddItemToShoppingListEvent);
    on<GetShoppingListEvent>(_onGetShoppingListEvent);
  }

  @override
  ShoppingListState get initialState => Empty();

  Future<void> _onGetShoppingListEvent(
      GetShoppingListEvent event, Emitter<ShoppingListState> emit) async {
    emit(Loading());
    final result = await getShoppingList();
    result.fold((error) => emit(Error(message: SERVER_FAILURE_MESSAGE)),
        (shoppingList) {
      emit(Loaded(shoppingList: shoppingList));
    });
  }

  /// Event that runs when an item is added to the shopping list
  Future<void> _onAddItemToShoppingListEvent(
      AddItemToShoppingListEvent event, Emitter<ShoppingListState> emit) async {
    // Run the usecase itself
    final result = addItemToShoppingList(event.shoppingList, event.newItem);

    // Deal with the result
    result.fold((failure) {
      emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE));
    }, (result) async {
      emit(Added(shoppingList: result));

      //Call the backend update
      emit(Loading());
      final updated = await updateShoppingList(result);

      updated.fold((error) => emit(Error(message: SERVER_FAILURE_MESSAGE)),
          (newShoppingList) {
        emit(Updated(shoppingList: newShoppingList));
      });
    });
  }
}
