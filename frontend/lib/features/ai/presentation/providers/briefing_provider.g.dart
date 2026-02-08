// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'briefing_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for managing briefing state

@ProviderFor(BriefingNotifier)
final briefingProvider = BriefingNotifierProvider._();

/// Provider for managing briefing state
final class BriefingNotifierProvider
    extends $NotifierProvider<BriefingNotifier, BriefingState> {
  /// Provider for managing briefing state
  BriefingNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'briefingProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$briefingNotifierHash();

  @$internal
  @override
  BriefingNotifier create() => BriefingNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BriefingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BriefingState>(value),
    );
  }
}

String _$briefingNotifierHash() => r'665c48cab4758b638495747b25b2d113ec1e8342';

/// Provider for managing briefing state

abstract class _$BriefingNotifier extends $Notifier<BriefingState> {
  BriefingState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<BriefingState, BriefingState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<BriefingState, BriefingState>,
        BriefingState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
