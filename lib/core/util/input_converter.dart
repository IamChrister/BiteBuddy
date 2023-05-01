import 'package:bite_buddy/core/error/failures.dart';
import 'package:bite_buddy/features/shopping_list/data/models/list_item_model.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, ListItemModel> stringToListItem(String str) {
    String formattedInput = str.trim();

    if (formattedInput.isEmpty) {
      return Left(InvalidInputFailure());
    } else {
      return Right(ListItemModel(title: formattedInput, collected: false));
    }
  }
}

class InvalidInputFailure extends Failure {}
