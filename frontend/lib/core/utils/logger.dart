import 'dart:developer' as developer;

/// Simple logger utility for development
class Logger {
  // Private constructor
  Logger._();

  /// Log debug message
  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: 'DEBUG',
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log info message
  static void info(String message) {
    developer.log(message, name: 'INFO');
  }

  /// Log warning message
  static void warning(String message, [Object? error]) {
    developer.log(
      message,
      name: 'WARNING',
      error: error,
    );
  }

  /// Log error message
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: 'ERROR',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
