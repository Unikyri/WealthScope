import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_risk.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';

part 'portfolio_risk_dto.freezed.dart';
part 'portfolio_risk_dto.g.dart';

/// Portfolio Risk DTO
/// Matches GET /api/v1/portfolio/risk response
@freezed
abstract class PortfolioRiskDto with _$PortfolioRiskDto {
  const factory PortfolioRiskDto({
    @JsonKey(name: 'risk_score') required int riskScore,
    @JsonKey(name: 'diversification_level') required String diversificationLevel,
    @Default([]) List<RiskAlertDto> alerts,
  }) = _PortfolioRiskDto;

  const PortfolioRiskDto._();

  factory PortfolioRiskDto.fromJson(Map<String, dynamic> json) =>
      _$PortfolioRiskDtoFromJson(json);
}

/// Risk Alert DTO
@freezed
abstract class RiskAlertDto with _$RiskAlertDto {
  const factory RiskAlertDto({
    required String type,
    required String title,
    required String message,
    required String severity,
    required double value,
    required double threshold,
  }) = _RiskAlertDto;

  const RiskAlertDto._();

  factory RiskAlertDto.fromJson(Map<String, dynamic> json) =>
      _$RiskAlertDtoFromJson(json);
}

/// Extension to convert DTO to Domain Entity
extension PortfolioRiskDtoX on PortfolioRiskDto {
  PortfolioRisk toDomain() {
    return PortfolioRisk(
      riskScore: riskScore,
      diversificationLevel: diversificationLevel,
      alerts: alerts.map((a) => a.toDomain()).toList(),
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
