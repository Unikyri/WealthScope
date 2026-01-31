import 'package:freezed_annotation/freezed_annotation.dart';

part 'portfolio_summary.freezed.dart';

/// Portfolio Summary Entity
/// Represents the aggregated financial summary of a user's portfolio
@freezed
class PortfolioSummary with _$PortfolioSummary {
  const factory PortfolioSummary({
    required double totalValue,
    required double totalInvested,
    required double gainLoss,
    required double gainLossPercent,
    @Default(0) int assetCount,
    @Default([]) List<AssetTypeBreakdown> breakdownByType,
    required DateTime lastUpdated,
  }) = _PortfolioSummary;
}

/// Asset Type Breakdown
@freezed
class AssetTypeBreakdown with _$AssetTypeBreakdown {
  const factory AssetTypeBreakdown({
    required String type,
    required double value,
    required double percent,
    required int count,
  }) = _AssetTypeBreakdown;
}

/// Risk Alert Entity (from separate /api/v1/portfolio/risk endpoint)
@freezed
class RiskAlert with _$RiskAlert {
  const factory RiskAlert({
    required String type,
    required String title,
    required String message,
    required AlertSeverity severity,
    required double value,
    required double threshold,
  }) = _RiskAlert;
}

/// Alert Severity Level
enum AlertSeverity {
  info,
  warning,
  critical,
}
