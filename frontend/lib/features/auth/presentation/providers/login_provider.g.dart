// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for login form logic

@ProviderFor(LoginNotifier)
final loginProvider = LoginNotifierProvider._();

/// Provider for login form logic
final class LoginNotifierProvider
    extends $NotifierProvider<LoginNotifier, LoginState> {
  /// Provider for login form logic
  LoginNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'loginProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$loginNotifierHash();

  @$internal
  @override
  LoginNotifier create() => LoginNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoginState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoginState>(value),
    );
  }
}

String _$loginNotifierHash() => r'cc49040c6867ffd98d3c94e15eb1c2457fa15547';

/// Provider for login form logic

abstract class _$LoginNotifier extends $Notifier<LoginState> {
  LoginState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<LoginState, LoginState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<LoginState, LoginState>, LoginState, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
