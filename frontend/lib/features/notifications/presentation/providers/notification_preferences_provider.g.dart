// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for managing notification preferences
/// Persists user's notification settings to SharedPreferences

@ProviderFor(NotificationPreferencesNotifier)
final notificationPreferencesProvider =
    NotificationPreferencesNotifierProvider._();

/// Provider for managing notification preferences
/// Persists user's notification settings to SharedPreferences
final class NotificationPreferencesNotifierProvider
    extends $AsyncNotifierProvider<NotificationPreferencesNotifier,
        NotificationPreferences> {
  /// Provider for managing notification preferences
  /// Persists user's notification settings to SharedPreferences
  NotificationPreferencesNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'notificationPreferencesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notificationPreferencesNotifierHash();

  @$internal
  @override
  NotificationPreferencesNotifier create() => NotificationPreferencesNotifier();
}

String _$notificationPreferencesNotifierHash() =>
    r'9055bf7c174acd4d889e5c97f0b502c98497e744';

/// Provider for managing notification preferences
/// Persists user's notification settings to SharedPreferences

abstract class _$NotificationPreferencesNotifier
    extends $AsyncNotifier<NotificationPreferences> {
  FutureOr<NotificationPreferences> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<NotificationPreferences>, NotificationPreferences>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<NotificationPreferences>,
            NotificationPreferences>,
        AsyncValue<NotificationPreferences>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
