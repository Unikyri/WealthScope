import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope/core/storage/secure_storage.dart';

part 'secure_storage_provider.g.dart';

/// Provider for the secure storage service.
/// Returns a singleton instance of [SecureStorageService].
@riverpod
SecureStorageService secureStorage(SecureStorageRef ref) {
  return SecureStorageService();
}
