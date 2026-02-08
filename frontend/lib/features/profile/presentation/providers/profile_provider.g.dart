// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for User Profile
/// Returns the current user's profile information

@ProviderFor(Profile)
final profileProvider = ProfileProvider._();

/// Provider for User Profile
/// Returns the current user's profile information
final class ProfileProvider
    extends $AsyncNotifierProvider<Profile, UserProfile?> {
  /// Provider for User Profile
  /// Returns the current user's profile information
  ProfileProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'profileProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$profileHash();

  @$internal
  @override
  Profile create() => Profile();
}

String _$profileHash() => r'3185f4c61783d9a77c3f223e249818e8468e2dbc';

/// Provider for User Profile
/// Returns the current user's profile information

abstract class _$Profile extends $AsyncNotifier<UserProfile?> {
  FutureOr<UserProfile?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserProfile?>, UserProfile?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<UserProfile?>, UserProfile?>,
        AsyncValue<UserProfile?>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
