// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Theme provider - WealthScope is dark-mode only.
/// Kept as a provider for potential future extensibility.

@ProviderFor(ThemeMode)
final themeModeProvider = ThemeModeProvider._();

/// Theme provider - WealthScope is dark-mode only.
/// Kept as a provider for potential future extensibility.
final class ThemeModeProvider
    extends $NotifierProvider<ThemeMode, ThemeModeOption> {
  /// Theme provider - WealthScope is dark-mode only.
  /// Kept as a provider for potential future extensibility.
  ThemeModeProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'themeModeProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$themeModeHash();

  @$internal
  @override
  ThemeMode create() => ThemeMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeModeOption value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeModeOption>(value),
    );
  }
}

String _$themeModeHash() => r'5a1ffe7ef0b500d6b1cb6a9e988cb58ac305210e';

/// Theme provider - WealthScope is dark-mode only.
/// Kept as a provider for potential future extensibility.

abstract class _$ThemeMode extends $Notifier<ThemeModeOption> {
  ThemeModeOption build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ThemeModeOption, ThemeModeOption>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ThemeModeOption, ThemeModeOption>,
        ThemeModeOption,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
