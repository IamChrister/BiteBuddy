import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('listItem', () {
    test(
        'should create a listItem with an id when the withTitle method is called',
        () {
      //Arrange

      //Act
      final tItem = ListItem.withTitle("test title");

      //Assert
      expect(tItem.id.isNotEmpty, true);
    });
  });
}
