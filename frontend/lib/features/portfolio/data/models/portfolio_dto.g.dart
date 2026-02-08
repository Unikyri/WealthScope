// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PortfolioSummaryDto _$PortfolioSummaryDtoFromJson(Map<String, dynamic> json) =>
    _PortfolioSummaryDto(
      totalValue: (json['total_value'] as num).toDouble(),
      totalInvested: (json['total_invested'] as num).toDouble(),
      gainLoss: (json['gain_loss'] as num).toDouble(),
      gainLossPercent: (json['gain_loss_percent'] as num).toDouble(),
      assetCount: (json['asset_count'] as num).toInt(),
      breakdownByType: (json['breakdown_by_type'] as List<dynamic>)
          .map((e) => AssetTypeBreakdownDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdated: json['last_updated'] as String,
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

_PortfolioRiskAnalysisDto _$PortfolioRiskAnalysisDtoFromJson(
        Map<String, dynamic> json) =>
    _PortfolioRiskAnalysisDto(
      riskScore: (json['risk_score'] as num).toInt(),
      diversificationLevel: json['diversification_level'] as String,
      alerts: (json['alerts'] as List<dynamic>)
          .map((e) => RiskAlertDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PortfolioRiskAnalysisDtoToJson(
        _PortfolioRiskAnalysisDto instance) =>
    <String, dynamic>{
      'risk_score': instance.riskScore,
      'diversification_level': instance.diversificationLevel,
      'alerts': instance.alerts.map((e) => e.toJson()).toList(),
    };

_RiskAlertDto _$RiskAlertDtoFromJson(Map<String, dynamic> json) =>
    _RiskAlertDto(
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      severity: json['severity'] as String,
      value: (json['value'] as num).toDouble(),
      threshold: (json['threshold'] as num).toDouble(),
    );

Map<String, dynamic> _$RiskAlertDtoToJson(_RiskAlertDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'message': instance.message,
      'severity': instance.severity,
      'value': instance.value,
      'threshold': instance.threshold,
    };
