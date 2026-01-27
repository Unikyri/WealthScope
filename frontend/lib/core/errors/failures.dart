/// Base class for all failures in the application
abstract class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;
}

/// Failure when server returns an error
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

/// Failure when there's no internet connection
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// Failure when data is not found
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

/// Failure when authentication fails
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}

/// Failure when validation fails
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation error']);
}

/// Unexpected failure
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred']);
}
