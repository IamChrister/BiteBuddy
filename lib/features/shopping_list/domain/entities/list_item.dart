import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

/// A single item in the shopping list
class ListItem extends Equatable {
  final String title;
  final bool collected;
  final String id;

  const ListItem(
      {required this.title, required this.collected, required this.id});

  ListItem.withTitle(this.title)
      : id = const Uuid().v4(),
        collected = false;

  ListItem toggleCollected() {
    return ListItem(id: id, title: title, collected: !collected);
  }

  @override
  List<Object?> get props => [id, title, collected];
}
