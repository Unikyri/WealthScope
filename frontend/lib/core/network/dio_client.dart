import 'package:dio/dio.dart';
import 'package:wealthscope_app/core/constants/app_config.dart';

/// Dio HTTP Client Configuration
/// Centralized HTTP client for all API calls.
class DioClient {
  // Private constructor
  DioClient._();

  static Dio? _instance;

  /// Get singleton Dio instance
  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors for logging, auth, etc.
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );

    return dio;
  }
}
