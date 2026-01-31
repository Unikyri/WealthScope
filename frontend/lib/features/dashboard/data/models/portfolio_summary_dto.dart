import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';

part 'portfolio_summary_dto.freezed.dart';
part 'portfolio_summary_dto.g.dart';

/// Portfolio Summary DTO
/// Matches GET /api/v1/portfolio/summary response
@freezed
class PortfolioSummaryDto with _$PortfolioSummaryDto {
  const factory PortfolioSummaryDto({
    @JsonKey(name: 'total_value') required double totalValue,
    @JsonKey(name: 'total_invested') required double totalInvested,
    @JsonKey(name: 'gain_loss') required double gainLoss,
    @JsonKey(name: 'gain_loss_percent') required double gainLossPercent,
    @JsonKey(name: 'asset_count') @Default(0) int assetCount,
    @JsonKey(name: 'breakdown_by_type') @Default([]) List<AssetTypeBreakdownDto> breakdownByType,
    @JsonKey(name: 'last_updated') String? lastUpdated,
  }) = _PortfolioSummaryDto;

  const PortfolioSummaryDto._();

  factory PortfolioSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$PortfolioSummaryDtoFromJson(json);
}

/// Asset Type Breakdown DTO
/// Matches breakdown_by_type array from API
@freezed
class AssetTypeBreakdownDto with _$AssetTypeBreakdownDto {
  const factory AssetTypeBreakdownDto({
    required String type,
    required double value,
    required double percent,
    required int count,
  }) = _AssetTypeBreakdownDto;

  const AssetTypeBreakdownDto._();

  factory AssetTypeBreakdownDto.fromJson(Map<String, dynamic> json) =>
      _$AssetTypeBreakdownDtoFromJson(json);
}



/// Extension to convert DTO to Domain Entity
extension PortfolioSummaryDtoX on PortfolioSummaryDto {
  PortfolioSummary toDomain() {
    return PortfolioSummary(
      totalValue: totalValue,
      totalInvested: totalInvested,
      gainLoss: gainLoss,
      gainLossPercent: gainLossPercent,
      assetCount: assetCount,
      breakdownByType: breakdownByType.map((a) => a.toDomain()).toList(),
      lastUpdated: lastUpdated != null 
          ? DateTime.parse(lastUpdated!) 
          : DateTime.now(),
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
