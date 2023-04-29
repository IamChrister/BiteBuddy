import 'package:equatable/equatable.dart';

/// Abstract class for handling failures
abstract class Failure extends Equatable {
  final List<dynamic> properties;

  const Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object?> get props => properties;
}

class ServerFailure extends Failure {}
