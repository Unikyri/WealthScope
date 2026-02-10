// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for register form logic

@ProviderFor(RegisterNotifier)
final registerProvider = RegisterNotifierProvider._();

/// Provider for register form logic
final class RegisterNotifierProvider
    extends $NotifierProvider<RegisterNotifier, RegisterState> {
  /// Provider for register form logic
  RegisterNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'registerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$registerNotifierHash();

  @$internal
  @override
  RegisterNotifier create() => RegisterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegisterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegisterState>(value),
    );
  }
}

String _$registerNotifierHash() => r'7e596397ba9bbfdb8f4c0f4e3b532f175f42fa6e';

/// Provider for register form logic

abstract class _$RegisterNotifier extends $Notifier<RegisterState> {
  RegisterState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<RegisterState, RegisterState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<RegisterState, RegisterState>,
        RegisterState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
