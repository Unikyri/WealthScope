import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/scenario_entity.dart';

part 'scenario_dto.freezed.dart';
part 'scenario_dto.g.dart';

@freezed
class AllocationItemDto with _$AllocationItemDto {
  const factory AllocationItemDto({
    required String type,
    required double value,
    required double percent,
  }) = _AllocationItemDto;

  factory AllocationItemDto.fromJson(Map<String, dynamic> json) =>
      _$AllocationItemDtoFromJson(json);
}

@freezed
class PortfolioStateDto with _$PortfolioStateDto {
  const factory PortfolioStateDto({
    @JsonKey(name: 'total_value') required double totalValue,
    @JsonKey(name: 'total_invested') required double totalInvested,
    @JsonKey(name: 'gain_loss') required double gainLoss,
    @JsonKey(name: 'gain_loss_percent') required double gainLossPercent,
    @JsonKey(name: 'asset_count') required int assetCount,
    required List<AllocationItemDto> allocation,
  }) = _PortfolioStateDto;

  factory PortfolioStateDto.fromJson(Map<String, dynamic> json) =>
      _$PortfolioStateDtoFromJson(json);
}

@freezed
class ChangeDetailDto with _$ChangeDetailDto {
  const factory ChangeDetailDto({
    required String type,
    required String description,
    @JsonKey(name: 'old_value') required double oldValue,
    @JsonKey(name: 'new_value') required double newValue,
    required double difference,
  }) = _ChangeDetailDto;

  factory ChangeDetailDto.fromJson(Map<String, dynamic> json) =>
      _$ChangeDetailDtoFromJson(json);
}

@freezed
class SimulationResultDto with _$SimulationResultDto {
  const factory SimulationResultDto({
    @JsonKey(name: 'current_state') required PortfolioStateDto currentState,
    @JsonKey(name: 'projected_state') required PortfolioStateDto projectedState,
    required List<ChangeDetailDto> changes,
    @JsonKey(name: 'ai_analysis') required String aiAnalysis,
    required List<String> warnings,
  }) = _SimulationResultDto;

  factory SimulationResultDto.fromJson(Map<String, dynamic> json) =>
      _$SimulationResultDtoFromJson(json);
}

@freezed
class HistoricalStatsDto with _$HistoricalStatsDto {
  const factory HistoricalStatsDto({
    required String symbol,
    required String period,
    required double volatility,
    @JsonKey(name: 'max_drawdown') required double maxDrawdown,
    @JsonKey(name: 'average_return') required double averageReturn,
    @JsonKey(name: 'best_day') required double bestDay,
    @JsonKey(name: 'worst_day') required double worstDay,
    @JsonKey(name: 'positive_days') required int positiveDays,
    @JsonKey(name: 'negative_days') required int negativeDays,
    @JsonKey(name: 'data_points') required int dataPoints,
  }) = _HistoricalStatsDto;

  factory HistoricalStatsDto.fromJson(Map<String, dynamic> json) =>
      _$HistoricalStatsDtoFromJson(json);
}

@freezed
class ScenarioTemplateDto with _$ScenarioTemplateDto {
  const factory ScenarioTemplateDto({
    required String id,
    required String name,
    required String description,
    required String type,
    required Map<String, dynamic> parameters,
  }) = _ScenarioTemplateDto;

  factory ScenarioTemplateDto.fromJson(Map<String, dynamic> json) =>
      _$ScenarioTemplateDtoFromJson(json);
}

/// Request DTO for simulation
@freezed
class SimulateRequestDto with _$SimulateRequestDto {
  const factory SimulateRequestDto({
    required String type,
    required Map<String, dynamic> parameters,
  }) = _SimulateRequestDto;

  factory SimulateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SimulateRequestDtoFromJson(json);
}

/// Extensions to convert DTOs to Domain Entities
extension AllocationItemDtoX on AllocationItemDto {
  AllocationItemEntity toDomain() {
    return AllocationItemEntity(
      type: type,
      value: value,
      percent: percent,
    );
  }
}

extension PortfolioStateDtoX on PortfolioStateDto {
  PortfolioStateEntity toDomain() {
    return PortfolioStateEntity(
      totalValue: totalValue,
      totalInvested: totalInvested,
      gainLoss: gainLoss,
      gainLossPercent: gainLossPercent,
      assetCount: assetCount,
      allocation: allocation.map((dto) => dto.toDomain()).toList(),
    );
  }
}

extension ChangeDetailDtoX on ChangeDetailDto {
  ChangeDetailEntity toDomain() {
    return ChangeDetailEntity(
      type: type,
      description: description,
      oldValue: oldValue,
      newValue: newValue,
      difference: difference,
    );
  }
}

extension SimulationResultDtoX on SimulationResultDto {
  SimulationResultEntity toDomain() {
    return SimulationResultEntity(
      currentState: currentState.toDomain(),
      projectedState: projectedState.toDomain(),
      changes: changes.map((dto) => dto.toDomain()).toList(),
      aiAnalysis: aiAnalysis,
      warnings: warnings,
    );
  }
}

extension HistoricalStatsDtoX on HistoricalStatsDto {
  HistoricalStatsEntity toDomain() {
    return HistoricalStatsEntity(
      symbol: symbol,
      period: period,
      volatility: volatility,
      maxDrawdown: maxDrawdown,
      averageReturn: averageReturn,
      bestDay: bestDay,
      worstDay: worstDay,
      positiveDays: positiveDays,
      negativeDays: negativeDays,
      dataPoints: dataPoints,
    );
  }
}

extension ScenarioTemplateDtoX on ScenarioTemplateDto {
  ScenarioTemplateEntity toDomain() {
    return ScenarioTemplateEntity(
      id: id,
      name: name,
      description: description,
      type: type,
      parameters: parameters,
    );
  }
}
