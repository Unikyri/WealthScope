// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_sync_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for UserSyncService instance

@ProviderFor(userSyncService)
final userSyncServiceProvider = UserSyncServiceProvider._();

/// Provider for UserSyncService instance

final class UserSyncServiceProvider extends $FunctionalProvider<UserSyncService,
    UserSyncService, UserSyncService> with $Provider<UserSyncService> {
  /// Provider for UserSyncService instance
  UserSyncServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'userSyncServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userSyncServiceHash();

  @$internal
  @override
  $ProviderElement<UserSyncService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserSyncService create(Ref ref) {
    return userSyncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserSyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserSyncService>(value),
    );
  }
}

String _$userSyncServiceHash() => r'02df0a8ffe6e52883b6ea91135c9b8399fc4e039';
