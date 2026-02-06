// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationPreferencesNotifierHash() =>
    r'206c6c143eb2d3f0d039380dbd406013b1b4630a';

/// Provider for managing notification preferences
/// Persists user's notification settings to SharedPreferences
///
/// Copied from [NotificationPreferencesNotifier].
@ProviderFor(NotificationPreferencesNotifier)
final notificationPreferencesNotifierProvider =
    AutoDisposeAsyncNotifierProvider<NotificationPreferencesNotifier,
        NotificationPreferences>.internal(
  NotificationPreferencesNotifier.new,
  name: r'notificationPreferencesNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationPreferencesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationPreferencesNotifier
    = AutoDisposeAsyncNotifier<NotificationPreferences>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
