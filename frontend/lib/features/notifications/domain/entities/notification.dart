class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? assetId;
  final String? actionUrl;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.assetId,
    this.actionUrl,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? assetId,
    String? actionUrl,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      assetId: assetId ?? this.assetId,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }
}

enum NotificationType {
  alert,
  insight,
  milestone,
  priceAlert,
}
