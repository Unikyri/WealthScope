// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_news_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides a [NewsRemoteDatasource] singleton backed by [DioClient].

@ProviderFor(newsRemoteDatasource)
final newsRemoteDatasourceProvider = NewsRemoteDatasourceProvider._();

/// Provides a [NewsRemoteDatasource] singleton backed by [DioClient].

final class NewsRemoteDatasourceProvider extends $FunctionalProvider<
    NewsRemoteDatasource,
    NewsRemoteDatasource,
    NewsRemoteDatasource> with $Provider<NewsRemoteDatasource> {
  /// Provides a [NewsRemoteDatasource] singleton backed by [DioClient].
  NewsRemoteDatasourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'newsRemoteDatasourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$newsRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<NewsRemoteDatasource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NewsRemoteDatasource create(Ref ref) {
    return newsRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NewsRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NewsRemoteDatasource>(value),
    );
  }
}

String _$newsRemoteDatasourceHash() =>
    r'f8ba622f15356c9ddb9da9e654d6a20a3b30d802';

/// Fetches news for an asset using a 3-level fallback strategy:
///
/// 1. **Symbol** -- news mentioning the specific ticker (e.g. AAPL).
/// 2. **Category** -- news matching the asset type keywords (e.g. "cryptocurrency").
/// 3. **Trending** -- general trending financial news.
///
/// [symbol] may be null/empty for assets without a ticker (e.g. real estate).
/// [assetTypeStr] is the API-format string of the asset type.

@ProviderFor(assetNews)
final assetNewsProvider = AssetNewsFamily._();

/// Fetches news for an asset using a 3-level fallback strategy:
///
/// 1. **Symbol** -- news mentioning the specific ticker (e.g. AAPL).
/// 2. **Category** -- news matching the asset type keywords (e.g. "cryptocurrency").
/// 3. **Trending** -- general trending financial news.
///
/// [symbol] may be null/empty for assets without a ticker (e.g. real estate).
/// [assetTypeStr] is the API-format string of the asset type.

final class AssetNewsProvider extends $FunctionalProvider<
        AsyncValue<AssetNewsResult>, AssetNewsResult, FutureOr<AssetNewsResult>>
    with $FutureModifier<AssetNewsResult>, $FutureProvider<AssetNewsResult> {
  /// Fetches news for an asset using a 3-level fallback strategy:
  ///
  /// 1. **Symbol** -- news mentioning the specific ticker (e.g. AAPL).
  /// 2. **Category** -- news matching the asset type keywords (e.g. "cryptocurrency").
  /// 3. **Trending** -- general trending financial news.
  ///
  /// [symbol] may be null/empty for assets without a ticker (e.g. real estate).
  /// [assetTypeStr] is the API-format string of the asset type.
  AssetNewsProvider._(
      {required AssetNewsFamily super.from,
      required (
        String?,
        String,
      )
          super.argument})
      : super(
          retry: null,
          name: r'assetNewsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$assetNewsHash();

  @override
  String toString() {
    return r'assetNewsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<AssetNewsResult> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AssetNewsResult> create(Ref ref) {
    final argument = this.argument as (
      String?,
      String,
    );
    return assetNews(
      ref,
      argument.$1,
      argument.$2,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AssetNewsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assetNewsHash() => r'2ec4492b0b3b2094eb7945f2d92bf9f61caea825';

/// Fetches news for an asset using a 3-level fallback strategy:
///
/// 1. **Symbol** -- news mentioning the specific ticker (e.g. AAPL).
/// 2. **Category** -- news matching the asset type keywords (e.g. "cryptocurrency").
/// 3. **Trending** -- general trending financial news.
///
/// [symbol] may be null/empty for assets without a ticker (e.g. real estate).
/// [assetTypeStr] is the API-format string of the asset type.

final class AssetNewsFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<AssetNewsResult>,
            (
              String?,
              String,
            )> {
  AssetNewsFamily._()
      : super(
          retry: null,
          name: r'assetNewsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Fetches news for an asset using a 3-level fallback strategy:
  ///
  /// 1. **Symbol** -- news mentioning the specific ticker (e.g. AAPL).
  /// 2. **Category** -- news matching the asset type keywords (e.g. "cryptocurrency").
  /// 3. **Trending** -- general trending financial news.
  ///
  /// [symbol] may be null/empty for assets without a ticker (e.g. real estate).
  /// [assetTypeStr] is the API-format string of the asset type.

  AssetNewsProvider call(
    String? symbol,
    String assetTypeStr,
  ) =>
      AssetNewsProvider._(argument: (
        symbol,
        assetTypeStr,
      ), from: this);

  @override
  String toString() => r'assetNewsProvider';
}
