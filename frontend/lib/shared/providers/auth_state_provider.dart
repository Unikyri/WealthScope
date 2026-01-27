import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/features/auth/data/providers/auth_service_provider.dart';

part 'auth_state_provider.g.dart';

/// Auth state model that extends ChangeNotifier for GoRouter's refreshListenable
class AuthStateModel extends ChangeNotifier {
  bool _isAuthenticated;

  AuthStateModel({required bool isAuthenticated})
      : _isAuthenticated = isAuthenticated;

  bool get isAuthenticated => _isAuthenticated;

  void updateAuthState(bool isAuthenticated) {
    if (_isAuthenticated != isAuthenticated) {
      _isAuthenticated = isAuthenticated;
      notifyListeners();
    }
  }
}

/// Provider that manages auth state and notifies router when auth changes
@riverpod
class AuthStateNotifier extends _$AuthStateNotifier {
  @override
  AuthStateModel build() {
    // Initial state based on current user
    final currentUser = ref.watch(currentUserProvider);
    final authState = AuthStateModel(isAuthenticated: currentUser != null);

    // Listen to auth state changes from Supabase
    ref.listen(authStateChangesProvider, (previous, next) {
      next.whenData((supabaseAuthState) {
        final isAuthenticated = supabaseAuthState.session != null;
        authState.updateAuthState(isAuthenticated);
      });
    });

    return authState;
  }
}
