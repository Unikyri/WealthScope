import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wealthscope_app/core/storage/secure_storage_provider.dart';
import 'package:wealthscope_app/features/auth/data/services/auth_service.dart';

part 'auth_service_provider.g.dart';

/// Provider for AuthService instance
@riverpod
AuthService authService(AuthServiceRef ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthService(Supabase.instance.client, secureStorage);
}

/// Provider for current authenticated user
@riverpod
User? currentUser(CurrentUserRef ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.currentUser;
}

/// Provider for auth state changes stream
@riverpod
Stream<AuthState> authStateChanges(AuthStateChangesRef ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
}
