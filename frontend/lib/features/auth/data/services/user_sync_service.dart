import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Service for syncing user data with backend after Supabase authentication
class UserSyncService {
  final Dio _dio;

  UserSyncService(this._dio);

  /// Sync user with backend after Supabase authentication
  /// This creates or updates the user profile in the backend database
  /// 
  /// The user_id and email are extracted from the JWT token by the backend,
  /// so we only need to send optional display_name
  Future<void> syncUserWithBackend({
    String? displayName,
  }) async {
    try {
      debugPrint('🔄 Syncing user with backend...');
      final response = await _dio.post(
        '/auth/sync',
        data: {
          if (displayName != null && displayName.isNotEmpty)
            'display_name': displayName,
        },
      );
      debugPrint('✅ User synced with backend: ${response.statusCode}');
    } on DioException catch (e) {
      debugPrint('❌ Backend sync failed: ${e.message}');
      debugPrint('   Response: ${e.response?.data}');
      // Log error but don't throw - user is already registered in Supabase
      // This can be retried later or handled via background sync
      throw Exception(
        'Failed to sync with backend: ${e.message}',
      );
    }
  }
}
