import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';

part 'portfolio_summary_dto.freezed.dart';
part 'portfolio_summary_dto.g.dart';

/// Portfolio Summary DTO
@freezed
class PortfolioSummaryDto with _$PortfolioSummaryDto {
  const factory PortfolioSummaryDto({
    @JsonKey(name: 'total_value') required double totalValue,
    @JsonKey(name: 'total_gain') required double totalGain,
    @JsonKey(name: 'total_gain_percentage') required double totalGainPercentage,
    @JsonKey(name: 'day_change') required double dayChange,
    @JsonKey(name: 'day_change_percentage') required double dayChangePercentage,
    @JsonKey(name: 'asset_count') @Default(0) int assetCount,
    @Default([]) List<AssetAllocationDto> allocations,
    @JsonKey(name: 'top_assets') @Default([]) List<TopAssetDto> topAssets,
    @Default([]) List<RiskAlertDto> alerts,
    @JsonKey(name: 'last_updated') required DateTime lastUpdated,
    @JsonKey(name: 'is_market_open') bool? isMarketOpen,
  }) = _PortfolioSummaryDto;

  const PortfolioSummaryDto._();

  factory PortfolioSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$PortfolioSummaryDtoFromJson(json);
}

/// Asset Allocation DTO
@freezed
class AssetAllocationDto with _$AssetAllocationDto {
  const factory AssetAllocationDto({
    required String type,
    required String label,
    required double value,
    required double percentage,
  }) = _AssetAllocationDto;

  const AssetAllocationDto._();

  factory AssetAllocationDto.fromJson(Map<String, dynamic> json) =>
      _$AssetAllocationDtoFromJson(json);
}

/// Top Asset DTO
@freezed
class TopAssetDto with _$TopAssetDto {
  const factory TopAssetDto({
    required String id,
    required String name,
    required String type,
    required double value,
    required double gain,
    @JsonKey(name: 'gain_percentage') required double gainPercentage,
  }) = _TopAssetDto;

  const TopAssetDto._();

  factory TopAssetDto.fromJson(Map<String, dynamic> json) =>
      _$TopAssetDtoFromJson(json);
}

/// Risk Alert DTO
@freezed
class RiskAlertDto with _$RiskAlertDto {
  const factory RiskAlertDto({
    required String id,
    required String title,
    required String message,
    required String severity,
    required DateTime timestamp,
  }) = _RiskAlertDto;

  const RiskAlertDto._();

  factory RiskAlertDto.fromJson(Map<String, dynamic> json) =>
      _$RiskAlertDtoFromJson(json);
}

/// Extension to convert DTO to Domain Entity
extension PortfolioSummaryDtoX on PortfolioSummaryDto {
  PortfolioSummary toDomain() {
    return PortfolioSummary(
      totalValue: totalValue,
      totalGain: totalGain,
      totalGainPercentage: totalGainPercentage,
      dayChange: dayChange,
      dayChangePercentage: dayChangePercentage,
      assetCount: assetCount,
      allocations: allocations.map((a) => a.toDomain()).toList(),
      topAssets: topAssets.map((a) => a.toDomain()).toList(),
      alerts: alerts.map((a) => a.toDomain()).toList(),
      lastUpdated: lastUpdated,
      isMarketOpen: isMarketOpen,
    );
  }
}

extension AssetAllocationDtoX on AssetAllocationDto {
  AssetAllocation toDomain() {
    return AssetAllocation(
      type: type,
      label: label,
      value: value,
      percentage: percentage,
    );
  }
}

extension TopAssetDtoX on TopAssetDto {
  TopAsset toDomain() {
    return TopAsset(
      id: id,
      name: name,
      type: type,
      value: value,
      gain: gain,
      gainPercentage: gainPercentage,
    );
  }
}

extension RiskAlertDtoX on RiskAlertDto {
  RiskAlert toDomain() {
    return RiskAlert(
      id: id,
      title: title,
      message: message,
      severity: _parseSeverity(severity),
      timestamp: timestamp,
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
