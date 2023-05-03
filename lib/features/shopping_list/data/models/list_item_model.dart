import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';

//TODO: We need id's
class ListItemModel extends ListItem {
  ListItemModel({required String title, required bool collected})
      : super(title: title, collected: collected);

  // A factory to enable casting from JSON to ListItemModel
  factory ListItemModel.fromJson(Map<String, dynamic> json) {
    return ListItemModel(title: json['title'], collected: json['collected']);
  }

  Map<String, dynamic> toJson() {
    return {"title": title, "collected": collected};
  }

  @override
  List<Object> get props => [title, collected];
}
