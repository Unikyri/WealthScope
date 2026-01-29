// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PortfolioSummaryDtoImpl _$$PortfolioSummaryDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PortfolioSummaryDtoImpl(
      totalValue: (json['total_value'] as num).toDouble(),
      totalGain: (json['total_gain'] as num).toDouble(),
      totalGainPercentage: (json['total_gain_percentage'] as num).toDouble(),
      dayChange: (json['day_change'] as num).toDouble(),
      dayChangePercentage: (json['day_change_percentage'] as num).toDouble(),
      assetCount: (json['asset_count'] as num?)?.toInt() ?? 0,
      allocations: (json['allocations'] as List<dynamic>?)
              ?.map(
                  (e) => AssetAllocationDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      topAssets: (json['top_assets'] as List<dynamic>?)
              ?.map((e) => TopAssetDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      alerts: (json['alerts'] as List<dynamic>?)
              ?.map((e) => RiskAlertDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PortfolioSummaryDtoImplToJson(
        _$PortfolioSummaryDtoImpl instance) =>
    <String, dynamic>{
      'total_value': instance.totalValue,
      'total_gain': instance.totalGain,
      'total_gain_percentage': instance.totalGainPercentage,
      'day_change': instance.dayChange,
      'day_change_percentage': instance.dayChangePercentage,
      'asset_count': instance.assetCount,
      'allocations': instance.allocations.map((e) => e.toJson()).toList(),
      'top_assets': instance.topAssets.map((e) => e.toJson()).toList(),
      'alerts': instance.alerts.map((e) => e.toJson()).toList(),
    };

_$AssetAllocationDtoImpl _$$AssetAllocationDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$AssetAllocationDtoImpl(
      type: json['type'] as String,
      label: json['label'] as String,
      value: (json['value'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$$AssetAllocationDtoImplToJson(
        _$AssetAllocationDtoImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'label': instance.label,
      'value': instance.value,
      'percentage': instance.percentage,
    };

_$TopAssetDtoImpl _$$TopAssetDtoImplFromJson(Map<String, dynamic> json) =>
    _$TopAssetDtoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      value: (json['value'] as num).toDouble(),
      gain: (json['gain'] as num).toDouble(),
      gainPercentage: (json['gain_percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$$TopAssetDtoImplToJson(_$TopAssetDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'value': instance.value,
      'gain': instance.gain,
      'gain_percentage': instance.gainPercentage,
    };

_$RiskAlertDtoImpl _$$RiskAlertDtoImplFromJson(Map<String, dynamic> json) =>
    _$RiskAlertDtoImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      severity: json['severity'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$RiskAlertDtoImplToJson(_$RiskAlertDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'severity': instance.severity,
      'timestamp': instance.timestamp.toIso8601String(),
    };
