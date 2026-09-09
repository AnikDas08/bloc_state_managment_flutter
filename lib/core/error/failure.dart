import 'package:equatable/equatable.dart';

/// Base class for all failures and errors
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Handled server or API related errors (e.g., 400, 404, 500)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Network connectivity or timeout failure
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = "No internet connection. Please try again."]);
}

/// Cache or local storage error (e.g., SharedPreferences, Hive, SQLite)
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Form or UI input validation error
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
