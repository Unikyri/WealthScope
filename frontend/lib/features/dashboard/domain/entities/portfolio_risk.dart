import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';

part 'portfolio_risk.freezed.dart';

/// Portfolio Risk Analysis Entity
/// From GET /api/v1/portfolio/risk
@freezed
abstract class PortfolioRisk with _$PortfolioRisk {
  const factory PortfolioRisk({
    required int riskScore,
    required String diversificationLevel,
    @Default([]) List<RiskAlert> alerts,
  }) = _PortfolioRisk;
}
