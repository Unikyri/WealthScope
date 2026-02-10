import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wealthscope_app/core/storage/secure_storage.dart';

/// Service that encapsulates all authentication operations with Supabase
class AuthService {
  final SupabaseClient _supabase;
  final SecureStorageService _secureStorage;

  AuthService(this._supabase, this._secureStorage);

  /// Sign up a new user with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  /// Sign in an existing user with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out the current user
  /// Clears Supabase session, secure storage tokens, and local cache
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      await _clearLocalData();
    } catch (e) {
      // Log error but continue with local cleanup to ensure clean state
      await _clearLocalData();
      rethrow;
    }
  }

  /// Clear all local data including tokens and cache
  Future<void> _clearLocalData() async {
    try {
      // Clear secure storage tokens
      await _secureStorage.clearTokens();

      // Clear Hive cache if it exists
      if (Hive.isBoxOpen('cache')) {
        final cacheBox = Hive.box('cache');
        await cacheBox.clear();
      } else {
        // Open and clear if not already open
        final cacheBox = await Hive.openBox('cache');
        await cacheBox.clear();
      }
    } catch (e) {
      // Silently handle cleanup errors to prevent blocking logout
      // In production, you might want to log this error
    }
  }

  /// Get the current authenticated user
  User? get currentUser => _supabase.auth.currentUser;

  /// Stream of authentication state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
