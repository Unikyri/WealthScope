// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ThemeMode)
final themeModeProvider = ThemeModeProvider._();

final class ThemeModeProvider
    extends $NotifierProvider<ThemeMode, ThemeModeOption> {
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

String _$themeModeHash() => r'f1c635b31f00160ba4d92d8f50b10ea61382463b';

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
