// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubscriptionStatus _$SubscriptionStatusFromJson(Map<String, dynamic> json) =>
    _SubscriptionStatus(
      isActive: json['is_active'] as bool,
      isPremium: json['is_premium'] as bool,
      activeEntitlementId: json['active_entitlement_id'] as String?,
      expirationDate: json['expiration_date'] == null
          ? null
          : DateTime.parse(json['expiration_date'] as String),
      willRenew: json['will_renew'] as bool,
      managementURL: json['management_u_r_l'] as String?,
    );

Map<String, dynamic> _$SubscriptionStatusToJson(_SubscriptionStatus instance) =>
    <String, dynamic>{
      'is_active': instance.isActive,
      'is_premium': instance.isPremium,
      'active_entitlement_id': instance.activeEntitlementId,
      'expiration_date': instance.expirationDate?.toIso8601String(),
      'will_renew': instance.willRenew,
      'management_u_r_l': instance.managementURL,
    };

_SubscriptionPackage _$SubscriptionPackageFromJson(Map<String, dynamic> json) =>
    _SubscriptionPackage(
      identifier: json['identifier'] as String,
      productId: json['product_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
      currencyCode: json['currency_code'] as String,
      priceAmount: (json['price_amount'] as num).toDouble(),
      introPrice: json['intro_price'] as String?,
      introPeriod: json['intro_period'] as String?,
    );

Map<String, dynamic> _$SubscriptionPackageToJson(
        _SubscriptionPackage instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'product_id': instance.productId,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'currency_code': instance.currencyCode,
      'price_amount': instance.priceAmount,
      'intro_price': instance.introPrice,
      'intro_period': instance.introPeriod,
    };

_SubscriptionOffering _$SubscriptionOfferingFromJson(
        Map<String, dynamic> json) =>
    _SubscriptionOffering(
      identifier: json['identifier'] as String,
      serverDescription: json['server_description'] as String,
      packages: (json['packages'] as List<dynamic>)
          .map((e) => SubscriptionPackage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubscriptionOfferingToJson(
        _SubscriptionOffering instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'server_description': instance.serverDescription,
      'packages': instance.packages.map((e) => e.toJson()).toList(),
    };
