import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_models.freezed.dart';
part 'subscription_models.g.dart';

/// Subscription status model
@freezed
class SubscriptionStatus with _$SubscriptionStatus {
  const factory SubscriptionStatus({
    required bool isActive,
    required bool isPremium,
    required String? activeEntitlementId,
    required DateTime? expirationDate,
    required bool willRenew,
    required String? managementURL,
  }) = _SubscriptionStatus;

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionStatusFromJson(json);
}

/// Subscription package model
@freezed
class SubscriptionPackage with _$SubscriptionPackage {
  const factory SubscriptionPackage({
    required String identifier,
    required String productId,
    required String title,
    required String description,
    required String price,
    required String currencyCode,
    required double priceAmount,
    String? introPrice,
    String? introPeriod,
  }) = _SubscriptionPackage;

  factory SubscriptionPackage.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPackageFromJson(json);
}

/// Offering model  
@freezed
class SubscriptionOffering with _$SubscriptionOffering {
  const factory SubscriptionOffering({
    required String identifier,
    required String serverDescription,
    required List<SubscriptionPackage> packages,
  }) = _SubscriptionOffering;

  factory SubscriptionOffering.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionOfferingFromJson(json);
}
