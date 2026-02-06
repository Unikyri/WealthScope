// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'87f7c0811db991852c74d72376df550977c6d6db';

/// Provider for SharedPreferences instance
///
/// Copied from [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = FutureProvider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesRef = FutureProviderRef<SharedPreferences>;
String _$onboardingRepositoryHash() =>
    r'5f7d892d2b74a0deb40dde03304bc96a40ea0c80';

/// Provider for OnboardingRepository
///
/// Copied from [onboardingRepository].
@ProviderFor(onboardingRepository)
final onboardingRepositoryProvider =
    FutureProvider<OnboardingRepository>.internal(
  onboardingRepository,
  name: r'onboardingRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$onboardingRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OnboardingRepositoryRef = FutureProviderRef<OnboardingRepository>;
String _$onboardingHash() => r'3d3f7a5d6342c2e8d8d5f896db9a4c200e7a4462';

/// Onboarding state notifier
///
/// Copied from [Onboarding].
@ProviderFor(Onboarding)
final onboardingProvider =
    AutoDisposeAsyncNotifierProvider<Onboarding, bool>.internal(
  Onboarding.new,
  name: r'onboardingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$onboardingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Onboarding = AutoDisposeAsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
