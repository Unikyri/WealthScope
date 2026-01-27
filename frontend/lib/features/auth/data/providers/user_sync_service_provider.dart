import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/core/network/dio_client.dart';
import 'package:wealthscope_app/features/auth/data/services/user_sync_service.dart';

part 'user_sync_service_provider.g.dart';

/// Provider for UserSyncService instance
@riverpod
UserSyncService userSyncService(UserSyncServiceRef ref) {
  return UserSyncService(DioClient.instance);
}
