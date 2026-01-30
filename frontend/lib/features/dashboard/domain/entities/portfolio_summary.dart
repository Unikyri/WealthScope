import 'package:freezed_annotation/freezed_annotation.dart';

part 'portfolio_summary.freezed.dart';

/// Portfolio Summary Entity
/// Represents the aggregated financial summary of a user's portfolio
@freezed
class PortfolioSummary with _$PortfolioSummary {
  const factory PortfolioSummary({
    required double totalValue,
    required double totalGain,
    required double totalGainPercentage,
    required double dayChange,
    required double dayChangePercentage,
    @Default(0) int assetCount,
    @Default([]) List<AssetAllocation> allocations,
    @Default([]) List<TopAsset> topAssets,
    @Default([]) List<RiskAlert> alerts,
    required DateTime lastUpdated,
  }) = _PortfolioSummary;
}

/// Asset Allocation by Type
@freezed
class AssetAllocation with _$AssetAllocation {
  const factory AssetAllocation({
    required String type,
    required String label,
    required double value,
    required double percentage,
  }) = _AssetAllocation;
}

/// Top Performing Asset
@freezed
class TopAsset with _$TopAsset {
  const factory TopAsset({
    required String id,
    required String name,
    required String type,
    required double value,
    required double gain,
    required double gainPercentage,
  }) = _TopAsset;
}

/// Risk Alert Entity
@freezed
class RiskAlert with _$RiskAlert {
  const factory RiskAlert({
    required String id,
    required String title,
    required String message,
    required AlertSeverity severity,
    required DateTime timestamp,
  }) = _RiskAlert;
}

/// Alert Severity Level
enum AlertSeverity {
  info,
  warning,
  critical,
}
