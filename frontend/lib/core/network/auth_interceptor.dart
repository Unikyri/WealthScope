import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Auth Interceptor for Dio
/// Automatically adds JWT token from Supabase to all requests
class AuthInterceptor extends Interceptor {
  final SupabaseClient _supabase;

  AuthInterceptor(this._supabase);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get current session
    final session = _supabase.auth.currentSession;

    // Add Bearer token if available
    if (session != null) {
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 errors (token expired)
    if (err.response?.statusCode == 401) {
      // Token might be expired, trigger refresh
      _supabase.auth.refreshSession();
    }

    handler.next(err);
  }
}
