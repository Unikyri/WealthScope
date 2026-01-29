// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dioClientHash() => r'6a99f6ba06c9d8d8122b8e4e2672318e67dca0f6';

/// Dio Client Provider
/// Provides the configured Dio instance for API calls
///
/// Copied from [dioClient].
@ProviderFor(dioClient)
final dioClientProvider = AutoDisposeProvider<Dio>.internal(
  dioClient,
  name: r'dioClientProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dioClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DioClientRef = AutoDisposeProviderRef<Dio>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
