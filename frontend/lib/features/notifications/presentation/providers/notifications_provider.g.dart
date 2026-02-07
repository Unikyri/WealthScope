// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Backwards compatibility: Convert insights to notifications format
/// Backwards compatibility: Convert insights to notifications format

@ProviderFor(notifications)
final notificationsProvider = NotificationsProvider._();

/// Backwards compatibility: Convert insights to notifications format
/// Backwards compatibility: Convert insights to notifications format

final class NotificationsProvider extends $FunctionalProvider<
        AsyncValue<List<AppNotification>>,
        List<AppNotification>,
        FutureOr<List<AppNotification>>>
    with
        $FutureModifier<List<AppNotification>>,
        $FutureProvider<List<AppNotification>> {
  /// Backwards compatibility: Convert insights to notifications format
  /// Backwards compatibility: Convert insights to notifications format
  NotificationsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'notificationsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notificationsHash();

  @$internal
  @override
  $FutureProviderElement<List<AppNotification>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<AppNotification>> create(Ref ref) {
    return notifications(ref);
  }
}

String _$notificationsHash() => r'e742ad7b940df5af87d8e403219444c271246078';

/// Provider for unread notifications count (backwards compatibility)

@ProviderFor(unreadNotificationsCount)
final unreadNotificationsCountProvider = UnreadNotificationsCountProvider._();

/// Provider for unread notifications count (backwards compatibility)

final class UnreadNotificationsCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Provider for unread notifications count (backwards compatibility)
  UnreadNotificationsCountProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'unreadNotificationsCountProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$unreadNotificationsCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return unreadNotificationsCount(ref);
  }
}

String _$unreadNotificationsCountHash() =>
    r'327aacca23724cca2da09a11a40625753f870a5f';
