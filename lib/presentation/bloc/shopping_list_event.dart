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
  final ShoppingList shoppingList;

  AddItemToShoppingListEvent(this.newItem, this.shoppingList)
      : super([shoppingList, newItem]);
}
