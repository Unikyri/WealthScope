
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Auth Interceptor for Dio
/// Automatically adds JWT token from Supabase to all requests.
/// Proactively refreshes token if it's about to expire.
class AuthInterceptor extends QueuedInterceptor {
  final SupabaseClient _supabase;
  final Dio _dio;

  AuthInterceptor(this._supabase, this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      var session = _supabase.auth.currentSession;

      // Proactively refresh if token expires within 60 seconds
      if (session != null && session.expiresAt != null) {
        final expiresAt =
            DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000);
        final now = DateTime.now();
        if (expiresAt.difference(now).inSeconds < 60) {
          print('🔄 [AUTH] Token expiring soon, refreshing proactively...');
          try {
            final refreshResult = await _supabase.auth.refreshSession();
            if (refreshResult.session != null) {
              session = refreshResult.session;
              print('✅ [AUTH] Token refreshed proactively');
            }
          } catch (e) {
            print('⚠️ [AUTH] Proactive refresh failed: $e');
          }
        }
      }

      // Add Bearer token if available
      if (session != null) {
        options.headers['Authorization'] = 'Bearer ${session.accessToken}';
        print(
            '✅ [AUTH] Token added (expires: ${DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000)})');
      } else {
        print('⚠️ [AUTH] No session found!');
      }
    } catch (e) {
      print('❌ [AUTH] Error getting session: $e');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      print('⚠️ [AUTH] 401 on ${err.requestOptions.path} - attempting token refresh');
      
      try {
        // Try to refresh the token
        final refreshResult = await _supabase.auth.refreshSession();
        
        if (refreshResult.session != null) {
          print('✅ [AUTH] Token refreshed successfully, retrying request');
          
          // Update the request with new token
          err.requestOptions.headers['Authorization'] = 
              'Bearer ${refreshResult.session!.accessToken}';
          
          // Retry the request
          try {
            final response = await _dio.fetch(err.requestOptions);
            return handler.resolve(response);
          } catch (e) {
            print('❌ [AUTH] Retry failed: $e');
            return handler.next(err);
          }
        } else {
          print('❌ [AUTH] Token refresh returned null session');
        }
      } catch (e) {
        print('❌ [AUTH] Token refresh error: $e');
      }
    }
    
    handler.next(err);
  }
}
