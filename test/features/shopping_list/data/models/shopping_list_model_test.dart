import 'dart:convert';

import 'package:bite_buddy/features/shopping_list/data/models/list_item_model.dart';
import 'package:bite_buddy/features/shopping_list/data/models/shopping_list_model.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  group('ShoppingListModel', () {
    test('should be a subclass of ShoppingList entity', () async {
      // Arrange
      var tShoppingListModel = const ShoppingListModel(
          items: [ListItemModel(id: "1", title: "title", collected: false)]);

      // Assert
      expect(tShoppingListModel, isA<ShoppingList>());
    });

    group('fromJson', () {
      test(
          'should return a valid model when the JSON contains a non-empty shopping list',
          () async {
        // Arrange
        final List<dynamic> jsonMap =
            json.decode(fixture('shopping_list.json'));

//TODO: Refactor
        var expected = const ShoppingListModel(items: [
          ListItemModel(id: "1", title: "test item 1", collected: false),
          ListItemModel(id: "2", title: "test item 2", collected: true)
        ]);

        // Act
        final actual = ShoppingListModel.fromJson(jsonMap);

        // Assert
        expect(actual, expected);
      });
      test(
          'should return a valid model when the JSON contains an empty shopping list',
          () async {
        // Arrange
        final List<dynamic> jsonMap =
            json.decode(fixture('shopping_list_empty.json'));

        const expected = ShoppingListModel(items: []);

        // Act
        final actual = ShoppingListModel.fromJson(jsonMap);

        // Assert
        expect(actual, expected);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing the proper data', () async {
        // Arrange
        ShoppingListModel tShoppingListModel = const ShoppingListModel(items: [
          ListItemModel(id: "1", title: "test item 1", collected: false),
          ListItemModel(id: "2", title: "test item 2", collected: true)
        ]);

        final expected = [
          {"id": "1", "title": "test item 1", "collected": false},
          {"id": "2", "title": "test item 2", "collected": true}
        ];

        // Act
        final actual = tShoppingListModel.toJson();

        // Assert
        expect(actual, expected);
      });
    });
  });
}
