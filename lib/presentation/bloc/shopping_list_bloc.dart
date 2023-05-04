import 'dart:async';
import 'dart:convert';

import 'package:bite_buddy/core/constants.dart';
import 'package:bite_buddy/core/util/input_converter.dart';
import 'package:bite_buddy/features/shopping_list/data/models/shopping_list_model.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/add_list_item_to_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/delete_item_from_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/get_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/stream_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/update_shopping_list.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eventsource/eventsource.dart';

part 'shopping_list_event.dart';
part 'shopping_list_state.dart';

class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  final GetShoppingListUsecase getShoppingList;
  final UpdateShoppingListUsecase updateShoppingList;
  final AddListItemToShoppingListUsecase addItemToShoppingList;
  final DeleteItemFromShoppingListUsecase deleteItemFromShoppingList;
  final StreamShoppingListUsecase streamShoppingList;
  final InputConverter inputConverter;

  ShoppingList _shoppingList = const ShoppingList(items: []);

  ShoppingListBloc(
      {required this.getShoppingList,
      required this.updateShoppingList,
      required this.addItemToShoppingList,
      required this.deleteItemFromShoppingList,
      required this.streamShoppingList,
      required this.inputConverter})
      : super(ShoppingListInitial()) {
    on<AddItemToShoppingListEvent>(_onAddItemToShoppingListEvent);
    on<GetShoppingListEvent>(_onGetShoppingListEvent);
    on<UpdateShoppingListEvent>(_onUpdateShoppingListEvent);
    on<DeleteItemFromShoppingListEvent>(_onDeleteItemFromShoppingListEvent);
    on<StreamShoppingListEvent>(_onStreamShoppingListEvent);
    on<ShoppingListLoadedFromStreamEvent>(_onShoppingListLoadedFromStreamEvent);
  }

  ShoppingListState get initialState => ShoppingListInitial();
  ShoppingList get shoppingList => _shoppingList;

  FutureOr<void> _onStreamShoppingListEvent(
      StreamShoppingListEvent event, Emitter<ShoppingListState> emit) async {
    final EventSource source = await streamShoppingList();
    source.listen((event) async {
      if (event.event == "put") {
        if (event.data != null && jsonDecode(event.data!)["data"] != null) {
          ShoppingList shoppingList =
              ShoppingListModel.fromJson(jsonDecode(event.data!)["data"]);

          add(ShoppingListLoadedFromStreamEvent(shoppingList: shoppingList));
        } else {
          add(ShoppingListLoadedFromStreamEvent(
              shoppingList: const ShoppingList(items: [])));
        }
      }
      //ShoppingList.
    });
  }

  Future<void> _onShoppingListLoadedFromStreamEvent(
      ShoppingListLoadedFromStreamEvent event,
      Emitter<ShoppingListState> emit) async {
    _shoppingList = event.shoppingList;
    emit(ShoppingListLoaded(shoppingList: event.shoppingList));
  }

  Future<void> _onGetShoppingListEvent(
      GetShoppingListEvent event, Emitter<ShoppingListState> emit) async {
    emit(ShoppingListLoading());
    final result = await getShoppingList();
    result.fold(
        (error) => emit(ShoppingListError(message: SERVER_FAILURE_MESSAGE)),
        (shoppingList) {
      _shoppingList = shoppingList;
      emit(ShoppingListLoaded(shoppingList: shoppingList));
    });
  }

  Future<void> _onDeleteItemFromShoppingListEvent(
      DeleteItemFromShoppingListEvent event,
      Emitter<ShoppingListState> emit) async {
    final result = deleteItemFromShoppingList(_shoppingList, event.item);

    result.fold(
        (failure) =>
            emit(ShoppingListError(message: ITEM_NOT_FOUND_FAILURE_MESSAGE)),
        (res) async {
      emit(ShoppingListLoading());

      final updated = await updateShoppingList(res);

      updated.fold(
          (error) => emit(ShoppingListError(message: SERVER_FAILURE_MESSAGE)),
          (newShoppingList) {
        emit(ShoppingListLoaded(shoppingList: newShoppingList));
        _shoppingList = newShoppingList;
      });
    });
  }

  Future<void> _onUpdateShoppingListEvent(
      UpdateShoppingListEvent event, Emitter<ShoppingListState> emit) async {
    // Actually probably should have a different effect since it's a bit different from the initial load maybe in the UI
    emit(ShoppingListLoading());
    final updateResult = await updateShoppingList(event.shoppingList);

    updateResult.fold(
        (failure) => emit(ShoppingListError(message: SERVER_FAILURE_MESSAGE)),
        (result) {
      _shoppingList = result;
      emit(ShoppingListLoaded(shoppingList: result));
    });
  }

  /// Event that runs when an item is added to the shopping list
  Future<void> _onAddItemToShoppingListEvent(
      AddItemToShoppingListEvent event, Emitter<ShoppingListState> emit) async {
    final result = addItemToShoppingList(_shoppingList, event.newItem);

    await result.fold((failure) {
      emit(ShoppingListError(message: INVALID_INPUT_FAILURE_MESSAGE));
    }, (result) async {
      emit(ShoppingListLoading());
      final updated = await updateShoppingList(result);

      updated.fold(
          (error) => emit(ShoppingListError(message: SERVER_FAILURE_MESSAGE)),
          (newShoppingList) {
        emit(ShoppingListLoaded(shoppingList: newShoppingList));
        _shoppingList = newShoppingList;
      });
    });
  }
}
