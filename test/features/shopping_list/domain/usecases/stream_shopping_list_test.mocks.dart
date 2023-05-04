// Mocks generated by Mockito 5.4.0 from annotations
// in bite_buddy/test/features/shopping_list/domain/usecases/stream_shopping_list_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:bite_buddy/core/error/failures.dart' as _i6;
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart'
    as _i7;
import 'package:bite_buddy/features/shopping_list/domain/repositories/shopping_list_repository.dart'
    as _i4;
import 'package:dartz/dartz.dart' as _i2;
import 'package:eventsource/eventsource.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEventSource_1 extends _i1.SmartFake implements _i3.EventSource {
  _FakeEventSource_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ShoppingListRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockShoppingListRepository extends _i1.Mock
    implements _i4.ShoppingListRepository {
  MockShoppingListRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i2.Either<_i6.Failure, _i7.ShoppingList>> getShoppingList() =>
      (super.noSuchMethod(
        Invocation.method(
          #getShoppingList,
          [],
        ),
        returnValue:
            _i5.Future<_i2.Either<_i6.Failure, _i7.ShoppingList>>.value(
                _FakeEither_0<_i6.Failure, _i7.ShoppingList>(
          this,
          Invocation.method(
            #getShoppingList,
            [],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, _i7.ShoppingList>>);
  @override
  _i5.Future<_i2.Either<_i6.Failure, _i7.ShoppingList>> updateShoppingList(
          _i7.ShoppingList? shoppingList) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateShoppingList,
          [shoppingList],
        ),
        returnValue:
            _i5.Future<_i2.Either<_i6.Failure, _i7.ShoppingList>>.value(
                _FakeEither_0<_i6.Failure, _i7.ShoppingList>(
          this,
          Invocation.method(
            #updateShoppingList,
            [shoppingList],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, _i7.ShoppingList>>);
  @override
  _i5.Future<_i3.EventSource> streamShoppingList() => (super.noSuchMethod(
        Invocation.method(
          #streamShoppingList,
          [],
        ),
        returnValue: _i5.Future<_i3.EventSource>.value(_FakeEventSource_1(
          this,
          Invocation.method(
            #streamShoppingList,
            [],
          ),
        )),
      ) as _i5.Future<_i3.EventSource>);
}
