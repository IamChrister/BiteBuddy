import 'package:bite_buddy/core/util/input_converter.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('inputConverter', () {
    test('should return a ListItem when the string is not empty', () {
      // Arrange
      const str = 'milk';

      // Act
      final result = inputConverter.stringToListItem(str);

      // Assert
      result.fold((error) => fail('Got Left but was expecting Right'),
          (actual) => expect(actual, isA<ListItem>()));
    });

    test('should return a Failure when the string is empty', () {
      // Arrange
      const str = '';

      // Act
      final result = inputConverter.stringToListItem(str);

      // Assert
      result.fold((actual) => const Left(InvalidInputFailure),
          (result) => fail('Expected Left but got Right'));
    });

    test('should return a Failure when the string is made of only whitespaces',
        () {
      // Arrange
      const str = '   ';

      // Act
      final result = inputConverter.stringToListItem(str);

      // Assert
      result.fold((actual) => const Left(InvalidInputFailure),
          (result) => fail('Expected Left but got Right'));
    });
  });
}
