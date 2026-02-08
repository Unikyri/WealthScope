import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_state_provider.g.dart';

/// Auth state model that extends ChangeNotifier for GoRouter's refreshListenable
class AuthStateModel extends ChangeNotifier {
  User? _user;
  bool _isLoading;

  AuthStateModel({User? user, bool isLoading = false})
      : _user = user,
        _isLoading = isLoading;

  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  User? get user => _user;
  String? get userId => _user?.id;
  String? get userEmail => _user?.email;

  void updateAuthState(User? user, {bool? isLoading}) {
    bool hasChanged = false;

    if (_user?.id != user?.id) {
      _user = user;
      hasChanged = true;
    }

    if (isLoading != null && _isLoading != isLoading) {
      _isLoading = isLoading;
      hasChanged = true;
    }

    if (hasChanged) {
      notifyListeners();
    }
  }
}

/// Provider that manages auth state and listens to Supabase auth changes
@riverpod
class AuthState extends _$AuthState {
  @override
  AuthStateModel build() {
    final authStateModel = AuthStateModel(
      user: Supabase.instance.client.auth.currentUser,
      isLoading: false,
    );

    // Listen to Supabase auth state changes
    final subscription = Supabase.instance.client.auth.onAuthStateChange.listen(
      (data) {
        authStateModel.updateAuthState(data.session?.user, isLoading: false);
      },
      onError: (error) {
        authStateModel.updateAuthState(null, isLoading: false);
      },
    );

    // Cancel subscription when provider is disposed
    ref.onDispose(() {
      subscription.cancel();
      authStateModel.dispose();
    });

    return authStateModel;
  }
}

/// Convenience provider: checks if user is authenticated
@riverpod
bool isAuthenticated(Ref ref) {
  return ref.watch(authStateProvider).isAuthenticated;
}

/// Convenience provider: gets current user
@riverpod
User? currentUser(Ref ref) {
  return ref.watch(authStateProvider).user;
}

/// Convenience provider: gets current user ID
@riverpod
String? userId(Ref ref) {
  return ref.watch(authStateProvider).userId;
}

/// Convenience provider: gets current user email
@riverpod
String? userEmail(Ref ref) {
  return ref.watch(authStateProvider).userEmail;
}
