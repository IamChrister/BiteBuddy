import 'package:equatable/equatable.dart';

/// A single item in the shopping list
class ListItem extends Equatable {
  final String title;
  final bool collected;

  const ListItem({required this.title, required this.collected});

  @override
  List<Object?> get props => [title, collected];
}
