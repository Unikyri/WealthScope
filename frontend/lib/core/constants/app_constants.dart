/// Application-wide constants
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  /// App information
  static const String appName = 'WealthScope';
  static const String appVersion = '1.0.0';

  /// API Configuration
  static const String apiVersion = 'v1';

  /// Storage keys
  static const String authTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';

  /// Timeouts
  static const Duration defaultTimeout = Duration(seconds: 30);

  /// Pagination
  static const int defaultPageSize = 20;
}
