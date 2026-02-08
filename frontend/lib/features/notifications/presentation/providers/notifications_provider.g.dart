// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Simple notifications provider that maps insights to notifications
/// Uses FutureProvider for simplicity

@ProviderFor(notifications)
final notificationsProvider = NotificationsProvider._();

/// Simple notifications provider that maps insights to notifications
/// Uses FutureProvider for simplicity

final class NotificationsProvider extends $FunctionalProvider<
        AsyncValue<List<AppNotification>>,
        List<AppNotification>,
        FutureOr<List<AppNotification>>>
    with
        $FutureModifier<List<AppNotification>>,
        $FutureProvider<List<AppNotification>> {
  /// Simple notifications provider that maps insights to notifications
  /// Uses FutureProvider for simplicity
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

String _$notificationsHash() => r'dbb9fcf3efccad7be6225255251341ead88b01df';

/// Simple unread count provider

@ProviderFor(unreadNotificationsCount)
final unreadNotificationsCountProvider = UnreadNotificationsCountProvider._();

/// Simple unread count provider

final class UnreadNotificationsCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Simple unread count provider
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
    r'3c76ee69b533f0feabb9b62ea6346c348a3f49ed';
