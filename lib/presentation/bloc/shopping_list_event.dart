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
  final ShoppingListModel shoppingListModel;

  UpdateShoppingListEvent(this.shoppingListModel) : super([shoppingListModel]);
}

class AddItemToShoppingListEvent extends ShoppingListEvent {
  final String newItem;
  final ShoppingListModel shoppingListModel;

  AddItemToShoppingListEvent(this.newItem, this.shoppingListModel)
      : super([shoppingListModel, newItem]);
}
