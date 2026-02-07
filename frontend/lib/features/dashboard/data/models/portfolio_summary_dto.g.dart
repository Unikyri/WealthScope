// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PortfolioSummaryDto _$PortfolioSummaryDtoFromJson(Map<String, dynamic> json) =>
    _PortfolioSummaryDto(
      totalValue: (json['total_value'] as num).toDouble(),
      totalInvested: (json['total_invested'] as num).toDouble(),
      gainLoss: (json['gain_loss'] as num).toDouble(),
      gainLossPercent: (json['gain_loss_percent'] as num).toDouble(),
      assetCount: (json['asset_count'] as num?)?.toInt() ?? 0,
      breakdownByType: (json['breakdown_by_type'] as List<dynamic>?)
              ?.map((e) =>
                  AssetTypeBreakdownDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lastUpdated: json['last_updated'] as String?,
    );

Map<String, dynamic> _$PortfolioSummaryDtoToJson(
        _PortfolioSummaryDto instance) =>
    <String, dynamic>{
      'total_value': instance.totalValue,
      'total_invested': instance.totalInvested,
      'gain_loss': instance.gainLoss,
      'gain_loss_percent': instance.gainLossPercent,
      'asset_count': instance.assetCount,
      'breakdown_by_type':
          instance.breakdownByType.map((e) => e.toJson()).toList(),
      'last_updated': instance.lastUpdated,
    };

_AssetTypeBreakdownDto _$AssetTypeBreakdownDtoFromJson(
        Map<String, dynamic> json) =>
    _AssetTypeBreakdownDto(
      type: json['type'] as String,
      value: (json['value'] as num).toDouble(),
      percent: (json['percent'] as num).toDouble(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$AssetTypeBreakdownDtoToJson(
        _AssetTypeBreakdownDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'value': instance.value,
      'percent': instance.percent,
      'count': instance.count,
    };
