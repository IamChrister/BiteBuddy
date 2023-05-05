import 'dart:async';
import 'package:bite_buddy/core/util/input_converter.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/add_list_item_to_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/delete_item_from_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/get_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/stream_shopping_list.dart';
import 'package:bite_buddy/features/shopping_list/domain/usecases/update_shopping_list.dart';
import 'package:bite_buddy/main.dart' as app;
import 'package:bite_buddy/presentation/bloc/shopping_list_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../test/presentation/bloc/shopping_list_bloc_test.mocks.dart';
import 'package:eventsource/eventsource.dart';

@GenerateMocks([
  AddListItemToShoppingListUsecase,
  UpdateShoppingListUsecase,
  GetShoppingListUsecase,
  DeleteItemFromShoppingListUsecase,
  StreamShoppingListUsecase,
  EventSource,
])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final mockAddListItemToShoppingListUsecase =
      MockAddListItemToShoppingListUsecase();
  final mockGetShoppingListUsecase = MockGetShoppingListUsecase();
  final mockDeleteItemFromShoppingListUsecase =
      MockDeleteItemFromShoppingListUsecase();
  final mockStreamShoppingListUsecase = MockStreamShoppingListUsecase();
  final mockUpdateShoppingListUsecase = MockUpdateShoppingListUsecase();
  final mockEventSource = MockEventSource();

  const ListItem tAddedItem =
      ListItem(title: "Milk", collected: false, id: "1");
  const tResultingShoppingList = ShoppingList(items: [tAddedItem]);

  group('integrationTests', () {
    testWidgets('Should display the new item after it has been added',
        (tester) async {
      //Arrange
      final shoppingListBloc = ShoppingListBloc(
          addItemToShoppingList: mockAddListItemToShoppingListUsecase,
          getShoppingList: mockGetShoppingListUsecase,
          deleteItemFromShoppingList: mockDeleteItemFromShoppingListUsecase,
          streamShoppingList: mockStreamShoppingListUsecase,
          inputConverter: InputConverter(),
          updateShoppingList: mockUpdateShoppingListUsecase);

      when(mockStreamShoppingListUsecase())
          .thenAnswer((realInvocation) async => mockEventSource);
      when(mockEventSource.listen((any))).thenAnswer((realInvocation) {
        final onEvent =
            realInvocation.positionalArguments[0] as void Function(Event);
        onEvent(Event(event: "put", id: ""));
        return StreamController<Event>().stream.listen((event) {});
      });

      when(mockAddListItemToShoppingListUsecase(any, any))
          .thenAnswer((realInvocation) {
        return const Right(tResultingShoppingList);
      });

      when(mockUpdateShoppingListUsecase(tResultingShoppingList))
          .thenAnswer((_) async {
        return const Right(tResultingShoppingList);
      });

      //Act
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<ShoppingListBloc>.value(
          value: shoppingListBloc,
          child: const app.ShoppingListApp(),
        ),
      ));

      //Find a widget, tap on it, and wait for something
      final addItemField = find.byKey(const ValueKey("addItemField"));
      final addItemButton = find.byKey(const ValueKey("addItemButton"));

      await tester.pumpAndSettle();
      await tester.enterText(addItemField, "Milk");
      await tester.pumpAndSettle();
      await tester.tap(addItemButton);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text("Milk"), findsOneWidget);
    });
  });
}
