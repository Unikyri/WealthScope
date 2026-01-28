import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wealthscope_app/core/constants/app_config.dart';
import 'package:wealthscope_app/core/network/auth_interceptor.dart';
import 'package:wealthscope_app/core/network/error_interceptor.dart';

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

  /// Reset instance (useful for testing or re-initialization)
  static void reset() {
    _instance = null;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: '${AppConfig.apiBaseUrl}/api/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors in order: Auth -> Error -> Logging
    dio.interceptors.addAll([
      AuthInterceptor(Supabase.instance.client),
      ErrorInterceptor(),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (log) {
          // Only log in development
          if (AppConfig.isDevelopment) {
            print(log);
          }
        },
      ),
    ]);

    return dio;
  }
}
