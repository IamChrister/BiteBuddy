import 'package:bite_buddy/features/shopping_list/data/models/list_item_model.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var tListItemModel = const ListItemModel(title: "title", collected: false);

  test('should be a subclass of ListItem entity', () async {
    expect(tListItemModel, isA<ListItem>());
  });
}
