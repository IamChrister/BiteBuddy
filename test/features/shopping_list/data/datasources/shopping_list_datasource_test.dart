import 'dart:convert';
import 'package:bite_buddy/core/constants.dart';
import 'package:bite_buddy/core/error/exceptions.dart';
import 'package:bite_buddy/features/shopping_list/data/datasources/shopping_list_datasource.dart';
import 'package:bite_buddy/features/shopping_list/data/models/shopping_list_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'shopping_list_datasource_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ShoppingListDatasourceImpl sut;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    sut = ShoppingListDatasourceImpl(client: mockClient);
  });

  void setUpMockClientSuccess() {
    when(mockClient.get(any)).thenAnswer((realInvocation) async =>
        http.Response(fixture('shopping_list.json'), 200));
    when(mockClient.put(any, body: anyNamed('body'))).thenAnswer(
        (realInvocation) async =>
            http.Response(fixture('shopping_list.json'), 200));
  }

  void setUpMockClientFailure() {
    when(mockClient.get(any)).thenAnswer(
        (realInvocation) async => http.Response('Something went wrong', 404));
  }

  group('shoppingListDatasource', () {
    group('updateShoppingList', () {
      var tShoppingListModel = ShoppingListModel.fromJson(
          json.decode(fixture('shopping_list.json')));

      test(
          'should perform a PUT request to Firestore Realtime Database REST API is successful',
          () async {
        // Arrange
        setUpMockClientSuccess();

        // Act
        await sut.updateShoppingList(tShoppingListModel);

        // Assert
        verify(mockClient.put(Uri.parse(realtimeDatabaseUrl),
            body: json.decode(fixture('shopping_list.json'))));
      });
      test('should return ShoppingListModel when the response code is 200',
          () async {
        // Arrange
        final expected = tShoppingListModel;

        setUpMockClientSuccess();

        // Act
        final actual = await sut.updateShoppingList(tShoppingListModel);

        // Assert
        verify(mockClient.put(Uri.parse(realtimeDatabaseUrl),
            body: json.decode(fixture('shopping_list.json'))));
        expect(actual, expected);
      });
    });

    group('getShoppingList', () {
      test(
          'should perform a GET request to Firestore Realtime Database REST API is successful',
          () async {
        // Arrange
        setUpMockClientSuccess();

        // Act
        await sut.getShoppingList();

        // Assert
        verify(mockClient.get(Uri.parse(realtimeDatabaseUrl)));
      });

      test('should return ShoppingListModel when the response code is 200',
          () async {
        // Arrange
        final expected = ShoppingListModel.fromJson(
            json.decode(fixture('shopping_list.json')));

        setUpMockClientSuccess();

        // Act
        final actual = await sut.getShoppingList();

        // Assert
        verify(mockClient.get(Uri.parse(realtimeDatabaseUrl)));
        expect(actual, expected);
      });

      test(
          'should throw a ServerException when the call to Firebase Realtime Database REST API is unsuccessful',
          () async {
        // Arrange
        setUpMockClientFailure();

        // Act
        final call = sut.getShoppingList;

        // Assert
        expect(() => call(), throwsA(isA<ServerException>()));
      });
    });
  });
}
