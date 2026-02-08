// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// News provider with pagination, filtering, and search

@ProviderFor(News)
final newsProvider = NewsProvider._();

/// News provider with pagination, filtering, and search
final class NewsProvider extends $NotifierProvider<News, NewsState> {
  /// News provider with pagination, filtering, and search
  NewsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'newsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$newsHash();

  @$internal
  @override
  News create() => News();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NewsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NewsState>(value),
    );
  }
}

String _$newsHash() => r'6939dc1c336131a30f5878bc3fd6ffa200c6d830';

/// News provider with pagination, filtering, and search

abstract class _$News extends $Notifier<NewsState> {
  NewsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<NewsState, NewsState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<NewsState, NewsState>, NewsState, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
