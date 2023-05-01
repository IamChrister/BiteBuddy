part of 'shopping_list_bloc.dart';

abstract class ShoppingListState extends Equatable {
  const ShoppingListState(List<Object> props);

  @override
  List<Object> get props => [];
}

/// Initial state
class Empty extends ShoppingListState {
  Empty() : super([]);
}

/// Loading something
class Loading extends ShoppingListState {
  Loading() : super([]);
}

/// Finished loading
class Loaded extends ShoppingListState {
  final ShoppingList shoppingList;

  Loaded({required this.shoppingList}) : super([shoppingList]);
}

/// Error
class Error extends ShoppingListState {
  final String message;

  Error({required this.message}) : super([message]);
}

/// Item added by the user, not yet updated in the server
class Added extends ShoppingListState {
  final ShoppingList shoppingList;

  Added({required this.shoppingList}) : super([shoppingList]);
}

/// Server update happened
class Updated extends ShoppingListState {
  final ShoppingList shoppingList;
  Updated({required this.shoppingList}) : super([shoppingList]);
}
