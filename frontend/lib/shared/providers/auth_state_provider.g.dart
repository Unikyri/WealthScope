// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that manages auth state and listens to Supabase auth changes

@ProviderFor(AuthState)
final authStateProvider = AuthStateProvider._();

/// Provider that manages auth state and listens to Supabase auth changes
final class AuthStateProvider
    extends $NotifierProvider<AuthState, AuthStateModel> {
  /// Provider that manages auth state and listens to Supabase auth changes
  AuthStateProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authStateHash();

  @$internal
  @override
  AuthState create() => AuthState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthStateModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthStateModel>(value),
    );
  }
}

String _$authStateHash() => r'c3463fb867745af6b6502aed459766f8649c3bc4';

/// Provider that manages auth state and listens to Supabase auth changes

abstract class _$AuthState extends $Notifier<AuthStateModel> {
  AuthStateModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthStateModel, AuthStateModel>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AuthStateModel, AuthStateModel>,
        AuthStateModel,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Convenience provider: checks if user is authenticated

@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = IsAuthenticatedProvider._();

/// Convenience provider: checks if user is authenticated

final class IsAuthenticatedProvider
    extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
  /// Convenience provider: checks if user is authenticated
  IsAuthenticatedProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'isAuthenticatedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$isAuthenticatedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isAuthenticated(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isAuthenticatedHash() => r'218691fd17c6b44fb74c3ffac9408787db617ed4';

/// Convenience provider: gets current user

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

/// Convenience provider: gets current user

final class CurrentUserProvider extends $FunctionalProvider<User?, User?, User?>
    with $Provider<User?> {
  /// Convenience provider: gets current user
  CurrentUserProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'currentUserProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $ProviderElement<User?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  User? create(Ref ref) {
    return currentUser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(User? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<User?>(value),
    );
  }
}

String _$currentUserHash() => r'2f845cf1754ef15a640a9621309d4fdbd11a3753';

/// Convenience provider: gets current user ID

@ProviderFor(userId)
final userIdProvider = UserIdProvider._();

/// Convenience provider: gets current user ID

final class UserIdProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Convenience provider: gets current user ID
  UserIdProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'userIdProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userIdHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return userId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$userIdHash() => r'f13459042173fd5df413e76dda170a8315c71e05';

/// Convenience provider: gets current user email

@ProviderFor(userEmail)
final userEmailProvider = UserEmailProvider._();

/// Convenience provider: gets current user email

final class UserEmailProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Convenience provider: gets current user email
  UserEmailProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'userEmailProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userEmailHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return userEmail(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$userEmailHash() => r'80d3af7df59df693d5097264fa22e40cc6a586bd';
