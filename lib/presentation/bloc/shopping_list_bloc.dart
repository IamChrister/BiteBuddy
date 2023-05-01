import 'package:bite_buddy/core/util/input_converter.dart';
import 'package:bite_buddy/features/shopping_list/data/models/shopping_list_model.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/add_list_item_model_to_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/get_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/update_shopping_list.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'shopping_list_event.dart';
part 'shopping_list_state.dart';

const INVALID_INPUT_FAILURE_MESSAGE = "Name of the item should not be empty.";

class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  final GetShoppingListUsecase getShoppingList;
  final UpdateShoppingListUsecase updateShoppingList;
  final AddListItemToShoppingListUsecase addItemToShoppingList;
  final InputConverter inputConverter;

  ShoppingListBloc(
      {required this.getShoppingList,
      required this.updateShoppingList,
      required this.addItemToShoppingList,
      required this.inputConverter})
      : super(Empty()) {
    on<AddItemToShoppingListEvent>(_onAddItemToShoppingListEvent);
  }

  @override
  ShoppingListState get initialState => Empty();

  Future<void> _onAddItemToShoppingListEvent(
      AddItemToShoppingListEvent event, Emitter<ShoppingListState> emit) async {
    //TODO: Continue here

    final inputEither = inputConverter.stringToListItem(event.newItem);

    inputEither.fold((failure) {
      emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE));
    }, (result) {
      emit(throw UnimplementedError());
    });
  }
}
