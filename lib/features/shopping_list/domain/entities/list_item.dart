import 'package:equatable/equatable.dart';

/// A single item in the shopping list
class ListItem extends Equatable {
  final String title;
  bool collected;

  ListItem({required this.title, required this.collected});

  @override
  List<Object?> get props => [title, collected];
}
