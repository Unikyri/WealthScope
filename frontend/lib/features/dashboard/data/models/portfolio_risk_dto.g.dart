// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_risk_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PortfolioRiskDto _$PortfolioRiskDtoFromJson(Map<String, dynamic> json) =>
    _PortfolioRiskDto(
      riskScore: (json['risk_score'] as num).toInt(),
      diversificationLevel: json['diversification_level'] as String,
      alerts: (json['alerts'] as List<dynamic>?)
              ?.map((e) => RiskAlertDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PortfolioRiskDtoToJson(_PortfolioRiskDto instance) =>
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
