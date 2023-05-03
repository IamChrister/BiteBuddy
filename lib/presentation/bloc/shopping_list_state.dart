part of 'shopping_list_bloc.dart';

abstract class ShoppingListState extends Equatable {
  const ShoppingListState(List<Object> props);

  @override
  List<Object> get props => [];
}

/// Finished loading - This keeps the state of the shoppingList
class ShoppingListLoaded extends ShoppingListState {
  final ShoppingList shoppingList;

  ShoppingListLoaded({required this.shoppingList}) : super([shoppingList]);

  @override
  List<Object> get props => [shoppingList];
}

/// Initial state
class ShoppingListInitial extends ShoppingListState {
  ShoppingListInitial() : super([]);
}

/// Loading something
class ShoppingListLoading extends ShoppingListState {
  ShoppingListLoading() : super([]);
}

/// Error
class ShoppingListError extends ShoppingListState {
  final String message;

  ShoppingListError({required this.message}) : super([message]);
}