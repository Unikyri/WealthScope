import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../dashboard/domain/entities/portfolio_summary.dart';
import '../../domain/repositories/portfolio_repository.dart';

part 'portfolio_dto.freezed.dart';
part 'portfolio_dto.g.dart';

/// DTO for Portfolio Summary Response
@freezed
class PortfolioSummaryDto with _$PortfolioSummaryDto {
  const factory PortfolioSummaryDto({
    @JsonKey(name: 'total_value') required double totalValue,
    @JsonKey(name: 'total_invested') required double totalInvested,
    @JsonKey(name: 'gain_loss') required double gainLoss,
    @JsonKey(name: 'gain_loss_percent') required double gainLossPercent,
    @JsonKey(name: 'asset_count') required int assetCount,
    @JsonKey(name: 'breakdown_by_type') required List<AssetTypeBreakdownDto> breakdownByType,
    @JsonKey(name: 'last_updated') required String lastUpdated,
  }) = _PortfolioSummaryDto;

  factory PortfolioSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$PortfolioSummaryDtoFromJson(json);
}

@freezed
class AssetTypeBreakdownDto with _$AssetTypeBreakdownDto {
  const factory AssetTypeBreakdownDto({
    required String type,
    required double value,
    required double percent,
    required int count,
  }) = _AssetTypeBreakdownDto;

  factory AssetTypeBreakdownDto.fromJson(Map<String, dynamic> json) =>
      _$AssetTypeBreakdownDtoFromJson(json);
}

/// DTO for Risk Analysis Response
@freezed
class PortfolioRiskAnalysisDto with _$PortfolioRiskAnalysisDto {
  const factory PortfolioRiskAnalysisDto({
    @JsonKey(name: 'risk_score') required int riskScore,
    @JsonKey(name: 'diversification_level') required String diversificationLevel,
    required List<RiskAlertDto> alerts,
  }) = _PortfolioRiskAnalysisDto;

  factory PortfolioRiskAnalysisDto.fromJson(Map<String, dynamic> json) =>
      _$PortfolioRiskAnalysisDtoFromJson(json);
}

@freezed
class RiskAlertDto with _$RiskAlertDto {
  const factory RiskAlertDto({
    required String type,
    required String title,
    required String message,
    required String severity,
    required double value,
    required double threshold,
  }) = _RiskAlertDto;

  factory RiskAlertDto.fromJson(Map<String, dynamic> json) =>
      _$RiskAlertDtoFromJson(json);
}

/// Extensions to convert DTOs to Domain Entities
extension PortfolioSummaryDtoX on PortfolioSummaryDto {
  PortfolioSummary toDomain() {
    return PortfolioSummary(
      totalValue: totalValue,
      totalInvested: totalInvested,
      gainLoss: gainLoss,
      gainLossPercent: gainLossPercent,
      assetCount: assetCount,
      breakdownByType: breakdownByType.map((dto) => dto.toDomain()).toList(),
      lastUpdated: DateTime.parse(lastUpdated),
    );
  }
}

extension AssetTypeBreakdownDtoX on AssetTypeBreakdownDto {
  AssetTypeBreakdown toDomain() {
    return AssetTypeBreakdown(
      type: type,
      value: value,
      percent: percent,
      count: count,
    );
  }
}

extension PortfolioRiskAnalysisDtoX on PortfolioRiskAnalysisDto {
  PortfolioRiskAnalysis toDomain() {
    return PortfolioRiskAnalysis(
      riskScore: riskScore,
      diversificationLevel: diversificationLevel,
      alerts: alerts.map((dto) => dto.toDomain()).toList(),
    );
  }
}

extension RiskAlertDtoX on RiskAlertDto {
  RiskAlert toDomain() {
    return RiskAlert(
      type: type,
      title: title,
      message: message,
      severity: _parseSeverity(severity),
      value: value,
      threshold: threshold,
    );
  }

  AlertSeverity _parseSeverity(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return AlertSeverity.critical;
      case 'warning':
        return AlertSeverity.warning;
      default:
        return AlertSeverity.info;
    }
  }
}
