import 'package:bite_buddy/features/shopping_list/data/datasources/shopping_list_datasource.dart';
import 'package:bite_buddy/features/shopping_list/data/repositories/shopping_list_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'shopping_list_repository_impl_test.mocks.dart';

@GenerateMocks([ShoppingListDatasource])
void main() {
  ShoppingListRepositoryImpl sut;
  MockShoppingListDatasource shoppingListDatasource;

  setUp(() {
    shoppingListDatasource = MockShoppingListDatasource();
    sut = ShoppingListRepositoryImpl(
        shoppingListDatasource: shoppingListDatasource);
  });

  group('ShoppingListRepositoryImpl', () {
    group('getShoppingList', () {});
    group('updateShoppingList', () {});
  });
}
