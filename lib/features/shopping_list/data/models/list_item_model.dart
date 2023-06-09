import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';

class ListItemModel extends ListItem {
  const ListItemModel(
      {required String id, required String title, required bool collected})
      : super(id: id, title: title, collected: collected);

  // A factory to enable casting from JSON to ListItemModel
  factory ListItemModel.fromJson(Map<String, dynamic> json) {
    return ListItemModel(
        id: json['id'], title: json['title'], collected: json['collected']);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "title": title, "collected": collected};
  }

  @override
  ListItemModel toggleCollected() {
    return ListItemModel(id: id, title: title, collected: !collected);
  }

  @override
  List<Object> get props => [id, title, collected];
}
