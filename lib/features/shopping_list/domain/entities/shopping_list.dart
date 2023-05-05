import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:equatable/equatable.dart';

/// A complete shopping list containing an array of [ListItems]
class ShoppingList extends Equatable {
  final List<ListItem> items;

  const ShoppingList({required this.items});

  @override
  List<Object?> get props => [items];
}
