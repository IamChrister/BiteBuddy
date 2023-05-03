part of 'shopping_list_bloc.dart';

abstract class ShoppingListEvent extends Equatable {
  const ShoppingListEvent(List<Object> props);

  @override
  List<Object> get props => [];
}

class GetShoppingListEvent extends ShoppingListEvent {
  GetShoppingListEvent() : super([]);
}

class UpdateShoppingListEvent extends ShoppingListEvent {
  final ShoppingList shoppingList;

  UpdateShoppingListEvent(this.shoppingList) : super([shoppingList]);
}

class AddItemToShoppingListEvent extends ShoppingListEvent {
  final String newItem;

  AddItemToShoppingListEvent(this.newItem) : super([newItem]);
}

class DeleteItemFromShoppingListEvent extends ShoppingListEvent {
  final ListItem item;

  DeleteItemFromShoppingListEvent(this.item) : super([item]);
}

class StreamShoppingListEvent extends ShoppingListEvent {
  StreamShoppingListEvent() : super([]);
}

class ShoppingListLoadedFromStreamEvent extends ShoppingListEvent {
  final ShoppingList shoppingList;

  ShoppingListLoadedFromStreamEvent({required this.shoppingList})
      : super([shoppingList]);
}
