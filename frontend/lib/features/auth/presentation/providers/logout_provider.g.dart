// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logout_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for handling user logout
/// Manages the async state of the logout operation

@ProviderFor(Logout)
final logoutProvider = LogoutProvider._();

/// Provider for handling user logout
/// Manages the async state of the logout operation
final class LogoutProvider extends $AsyncNotifierProvider<Logout, void> {
  /// Provider for handling user logout
  /// Manages the async state of the logout operation
  LogoutProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'logoutProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$logoutHash();

  @$internal
  @override
  Logout create() => Logout();
}

String _$logoutHash() => r'de77658cc1cb91803030c4f858000cf4c02453fa';

/// Provider for handling user logout
/// Manages the async state of the logout operation

abstract class _$Logout extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<void>, void>,
        AsyncValue<void>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
