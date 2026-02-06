// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AllocationItemDtoImpl _$$AllocationItemDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$AllocationItemDtoImpl(
      type: json['type'] as String,
      value: (json['value'] as num).toDouble(),
      percent: (json['percent'] as num).toDouble(),
    );

Map<String, dynamic> _$$AllocationItemDtoImplToJson(
        _$AllocationItemDtoImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'value': instance.value,
      'percent': instance.percent,
    };

_$PortfolioStateDtoImpl _$$PortfolioStateDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PortfolioStateDtoImpl(
      totalValue: (json['total_value'] as num).toDouble(),
      totalInvested: (json['total_invested'] as num).toDouble(),
      gainLoss: (json['gain_loss'] as num).toDouble(),
      gainLossPercent: (json['gain_loss_percent'] as num).toDouble(),
      assetCount: (json['asset_count'] as num).toInt(),
      allocation: (json['allocation'] as List<dynamic>)
          .map((e) => AllocationItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PortfolioStateDtoImplToJson(
        _$PortfolioStateDtoImpl instance) =>
    <String, dynamic>{
      'total_value': instance.totalValue,
      'total_invested': instance.totalInvested,
      'gain_loss': instance.gainLoss,
      'gain_loss_percent': instance.gainLossPercent,
      'asset_count': instance.assetCount,
      'allocation': instance.allocation.map((e) => e.toJson()).toList(),
    };

_$ChangeDetailDtoImpl _$$ChangeDetailDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ChangeDetailDtoImpl(
      type: json['type'] as String,
      description: json['description'] as String,
      oldValue: (json['old_value'] as num).toDouble(),
      newValue: (json['new_value'] as num).toDouble(),
      difference: (json['difference'] as num).toDouble(),
    );

Map<String, dynamic> _$$ChangeDetailDtoImplToJson(
        _$ChangeDetailDtoImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'description': instance.description,
      'old_value': instance.oldValue,
      'new_value': instance.newValue,
      'difference': instance.difference,
    };

_$SimulationResultDtoImpl _$$SimulationResultDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$SimulationResultDtoImpl(
      currentState: PortfolioStateDto.fromJson(
          json['current_state'] as Map<String, dynamic>),
      projectedState: PortfolioStateDto.fromJson(
          json['projected_state'] as Map<String, dynamic>),
      changes: (json['changes'] as List<dynamic>)
          .map((e) => ChangeDetailDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      aiAnalysis: json['ai_analysis'] as String,
      warnings:
          (json['warnings'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$SimulationResultDtoImplToJson(
        _$SimulationResultDtoImpl instance) =>
    <String, dynamic>{
      'current_state': instance.currentState.toJson(),
      'projected_state': instance.projectedState.toJson(),
      'changes': instance.changes.map((e) => e.toJson()).toList(),
      'ai_analysis': instance.aiAnalysis,
      'warnings': instance.warnings,
    };

_$HistoricalStatsDtoImpl _$$HistoricalStatsDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$HistoricalStatsDtoImpl(
      symbol: json['symbol'] as String,
      period: json['period'] as String,
      volatility: (json['volatility'] as num).toDouble(),
      maxDrawdown: (json['max_drawdown'] as num).toDouble(),
      averageReturn: (json['average_return'] as num).toDouble(),
      bestDay: (json['best_day'] as num).toDouble(),
      worstDay: (json['worst_day'] as num).toDouble(),
      positiveDays: (json['positive_days'] as num).toInt(),
      negativeDays: (json['negative_days'] as num).toInt(),
      dataPoints: (json['data_points'] as num).toInt(),
    );

Map<String, dynamic> _$$HistoricalStatsDtoImplToJson(
        _$HistoricalStatsDtoImpl instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'period': instance.period,
      'volatility': instance.volatility,
      'max_drawdown': instance.maxDrawdown,
      'average_return': instance.averageReturn,
      'best_day': instance.bestDay,
      'worst_day': instance.worstDay,
      'positive_days': instance.positiveDays,
      'negative_days': instance.negativeDays,
      'data_points': instance.dataPoints,
    };

_$ScenarioTemplateDtoImpl _$$ScenarioTemplateDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ScenarioTemplateDtoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      parameters: json['parameters'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$ScenarioTemplateDtoImplToJson(
        _$ScenarioTemplateDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': instance.type,
      'parameters': instance.parameters,
    };

_$SimulateRequestDtoImpl _$$SimulateRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$SimulateRequestDtoImpl(
      type: json['type'] as String,
      parameters: json['parameters'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$SimulateRequestDtoImplToJson(
        _$SimulateRequestDtoImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'parameters': instance.parameters,
    };
