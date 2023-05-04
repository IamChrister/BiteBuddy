import 'package:bite_buddy/core/error/failures.dart';
import 'package:bite_buddy/features/shopping_list/domain/entities/list_item.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, ListItem> stringToListItem(String str) {
    String formattedInput = str.trim();

    if (formattedInput.isEmpty) {
      return Left(InvalidInputFailure());
    } else {
      return Right(ListItem.withTitle(formattedInput));
    }
  }
}

class InvalidInputFailure extends Failure {}
