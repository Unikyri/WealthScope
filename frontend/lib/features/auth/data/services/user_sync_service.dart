import 'package:dio/dio.dart';

/// Service for syncing user data with backend after Supabase authentication
class UserSyncService {
  final Dio _dio;

  UserSyncService(this._dio);

  /// Sync newly registered user with backend
  /// This creates the user profile in the backend database
  Future<void> syncUserWithBackend({
    required String accessToken,
    required String userId,
    required String email,
  }) async {
    try {
      await _dio.post(
        '/api/v1/users/sync',
        data: {
          'userId': userId,
          'email': email,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
    } on DioException catch (e) {
      // Log error but don't throw - user is already registered in Supabase
      // This can be retried later or handled via background sync
      throw Exception(
        'Failed to sync with backend: ${e.message}',
      );
    }
  }
}
