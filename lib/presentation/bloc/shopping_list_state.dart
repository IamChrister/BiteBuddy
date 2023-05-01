part of 'shopping_list_bloc.dart';

abstract class ShoppingListState extends Equatable {
  const ShoppingListState(List<Object> props);

  @override
  List<Object> get props => [];
}

class Empty extends ShoppingListState {
  Empty() : super([]);
}

class Loading extends ShoppingListState {
  Loading() : super([]);
}

class Loaded extends ShoppingListState {
  final ShoppingList shoppingList;

  Loaded({required this.shoppingList}) : super([shoppingList]);
}

class Error extends ShoppingListState {
  final String message;

  Error({required this.message}) : super([message]);
}

class Updated extends ShoppingListState {
  Updated() : super([]);
}
