import 'package:bite_buddy/features/shopping_list/data/mappers/shopping_list_mapper.dart';
import 'package:bite_buddy/features/shopping_list/data/models/list_item_model.dart';
import 'package:bite_buddy/features/shopping_list/data/models/shopping_list_model.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShoppingListMapper', () {
    late ShoppingListMapper sut;

    setUp(() {
      sut = ShoppingListMapper();
    });

    test(
        'should return a valid ShoppingListModel when given a ShoppingList entity',
        () {
      // Arrange
      var expected = const ShoppingListModel(items: [
        ListItemModel(id: "1", title: "test item 1", collected: false)
      ]);

      var tShoppingListEntity = const ShoppingList(
          items: [ListItem(id: "1", title: "test item 1", collected: false)]);

      // Act
      final actual = sut.entityToModel(tShoppingListEntity);

      // Assert
      expect(actual, expected);
    });
  });
}
