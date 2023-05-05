part of 'shopping_list_bloc.dart';

abstract class ShoppingListEvent extends Equatable {
  const ShoppingListEvent(List<Object> props);

  @override
  List<Object> get props => [];
}

/// Event for when a new shopping list is gotten from the database
class GetShoppingListEvent extends ShoppingListEvent {
  GetShoppingListEvent() : super([]);
}

/// Event for updating the shopping list in the database
class UpdateShoppingListEvent extends ShoppingListEvent {
  final ShoppingList shoppingList;

  UpdateShoppingListEvent(this.shoppingList) : super([shoppingList]);
}

/// Event for adding an item to the shopping list
class AddItemToShoppingListEvent extends ShoppingListEvent {
  final String newItem;

  AddItemToShoppingListEvent(this.newItem) : super([newItem]);
}

/// Event from deleting an item from the shopping list
class DeleteItemFromShoppingListEvent extends ShoppingListEvent {
  final ListItem item;

  DeleteItemFromShoppingListEvent(this.item) : super([item]);
}

/// Event for streaming a shopping list from the database
class StreamShoppingListEvent extends ShoppingListEvent {
  StreamShoppingListEvent() : super([]);
}

/// Event for receiving an update from the stream to the database
class ShoppingListLoadedFromStreamEvent extends ShoppingListEvent {
  final ShoppingList shoppingList;

  ShoppingListLoadedFromStreamEvent({required this.shoppingList})
      : super([shoppingList]);
}
