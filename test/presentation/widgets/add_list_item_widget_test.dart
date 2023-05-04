import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:bite_buddy/presentation/bloc/shopping_list_bloc.dart';
import 'package:bite_buddy/presentation/widgets/add_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_list_item_widget_test.mocks.dart';

@GenerateMocks([ShoppingListBloc])
void main() {
  final mockShoppingListBloc = MockShoppingListBloc();

  group('addListItemWidget', () {
    testWidgets('Should contain an addItemField and addItemButton',
        (tester) async {
      // Arrange
      setUpStreamAndStateSuccess(mockShoppingListBloc);

      // Act
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: BlocProvider<ShoppingListBloc>.value(
          value: mockShoppingListBloc,
          child: const AddListItemWidget(),
        ),
      )));

      expect(find.byKey(const ValueKey("addItemField")), findsOneWidget);
      expect(find.byKey(const ValueKey("addItemButton")), findsOneWidget);
    });

    testWidgets(
        "Pressing the add item button should add the AddItemToShoppingListEvent",
        (WidgetTester tester) async {
      // Arrange
      //SHoppingListState stream
      setUpStreamAndStateSuccess(mockShoppingListBloc);

      final addItemField = find.byKey(const ValueKey("addItemField"));
      final addItemButton = find.byKey(const ValueKey("addItemButton"));

      // Act
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: BlocProvider<ShoppingListBloc>.value(
          value: mockShoppingListBloc,
          child: const AddListItemWidget(),
        ),
      )));

      await tester.enterText(addItemField, "Milk");
      await tester.tap(addItemButton);
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.add), findsOneWidget);
      verify(mockShoppingListBloc.add(AddItemToShoppingListEvent("Milk")))
          .called(1);
    });
  });
  testWidgets(
      "Pressing the add item button when the item name is invalid should emit the [ShoppingListError] state",
      (WidgetTester tester) async {
    // Arrange
    //SHoppingListState stream
    setUpStreamAndStateSuccess(mockShoppingListBloc);

    final addItemField = find.byKey(const ValueKey("addItemField"));
    final addItemButton = find.byKey(const ValueKey("addItemButton"));

    // Act
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: BlocProvider<ShoppingListBloc>.value(
        value: mockShoppingListBloc,
        child: const AddListItemWidget(),
      ),
    )));

    await tester.enterText(addItemField, "   ");
    await tester.tap(addItemButton);
    await tester.pump();

    // Assert
    expect(find.byIcon(Icons.add), findsOneWidget);
    verify(mockShoppingListBloc.state is ShoppingListError);
  });
}

void setUpStreamAndStateSuccess(MockShoppingListBloc mockShoppingListBloc) {
  when(mockShoppingListBloc.stream).thenAnswer((realInvocation) =>
      Stream<ShoppingListState>.value(
          ShoppingListLoaded(shoppingList: const ShoppingList(items: []))));
  when(mockShoppingListBloc.state).thenAnswer((realInvocation) =>
      ShoppingListLoaded(shoppingList: const ShoppingList(items: [])));
}
