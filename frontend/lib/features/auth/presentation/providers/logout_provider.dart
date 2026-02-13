import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/features/auth/data/providers/auth_service_provider.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/revenuecat_service.dart';

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
  /// Clears Supabase session, tokens, local cache, and RevenueCat identity
  Future<void> signOut() async {
    state = const AsyncValue.loading();

    try {
      // Log out from RevenueCat (revert to anonymous)
      try {
        final rcService = ref.read(revenueCatServiceProvider);
        await rcService.logout();
        debugPrint('Logout: RevenueCat identity cleared');
      } catch (rcError) {
        debugPrint('Logout: RevenueCat logout failed: $rcError');
      }

      final authService = ref.read(authServiceProvider);
      await authService.signOut();

      // Check if the provider is still mounted before updating state
      if (!ref.mounted) return;

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      // Check if the provider is still mounted before updating state
      if (!ref.mounted) return;

      state = AsyncValue.error(error, stackTrace);
    }
  }
}
