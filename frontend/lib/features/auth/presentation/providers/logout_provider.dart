import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/features/auth/data/providers/auth_service_provider.dart';

part 'logout_provider.g.dart';

/// Provider for handling user logout
/// Manages the async state of the logout operation
@riverpod
class Logout extends _$Logout {
  @override
  FutureOr<void> build() {
    // Initial state is idle
  }

  /// Sign out the current user
  /// Clears Supabase session, tokens, and local cache
  Future<void> signOut() async {
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      await authService.signOut();
    });
  }
}
