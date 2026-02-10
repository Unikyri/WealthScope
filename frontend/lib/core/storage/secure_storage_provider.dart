import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/core/storage/secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'secure_storage_provider.g.dart';

/// Provider for the secure storage service.
/// Returns a singleton instance of [SecureStorageService].
@riverpod
SecureStorageService secureStorage(Ref ref) {
  return SecureStorageService();
}
