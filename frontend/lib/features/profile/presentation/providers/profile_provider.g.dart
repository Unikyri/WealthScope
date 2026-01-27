// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileHash() => r'3185f4c61783d9a77c3f223e249818e8468e2dbc';

/// Provider for User Profile
/// Returns the current user's profile information
///
/// Copied from [Profile].
@ProviderFor(Profile)
final profileProvider =
    AutoDisposeAsyncNotifierProvider<Profile, UserProfile?>.internal(
  Profile.new,
  name: r'profileProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$profileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Profile = AutoDisposeAsyncNotifier<UserProfile?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
