import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/core/utils/asset_type_utils.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';

/// Enhanced Allocation Section - Crypto Blue Style
/// Matches specific user request: Donut with Total in center, side-by-side legend.
class EnhancedAllocationSection extends StatefulWidget {
  final List<AssetTypeBreakdown> allocations;
  final double totalValue; // Added to display in center

  const EnhancedAllocationSection({
    super.key,
    required this.allocations,
    required this.totalValue, // Required now
  });

  @override
  State<EnhancedAllocationSection> createState() =>
      _EnhancedAllocationSectionState();
}

class _EnhancedAllocationSectionState extends State<EnhancedAllocationSection> {
  int touchedIndex = -1;

  /// Processes allocations: groups segments <= 1% into an "Other" category
  /// so the donut always sums to 100% without losing small holdings.
  List<AssetTypeBreakdown> _processAllocations(
      List<AssetTypeBreakdown> allocations) {
    final significant = allocations.where((e) => e.percent > 1).toList();
    final small = allocations.where((e) => e.percent <= 1).toList();

    significant.sort((a, b) => b.percent.compareTo(a.percent));

    if (small.isNotEmpty) {
      final otherValue = small.fold(0.0, (sum, e) => sum + e.value);
      final otherPercent = small.fold(0.0, (sum, e) => sum + e.percent);
      if (otherPercent > 0) {
        significant.add(AssetTypeBreakdown(
          type: 'other',
          value: otherValue,
          percent: otherPercent,
          count: small.fold(0, (sum, e) => sum + e.count),
        ));
      }
    }
    return significant;
  }

  @override
  Widget build(BuildContext context) {
    // Process allocations: group small segments into "Other"
    final data = _processAllocations(widget.allocations);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardGrey,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.02)),
         boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Asset Allocation',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'View Details',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.electricBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Content Row
          Row(
            children: [
              // 1. Donut Chart (Left)
              Expanded(
                flex: 4,
                child: SizedBox(
                  height: 160,
                  child: Stack(
                    children: [
                      PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 2, // Native gap between sections
                          centerSpaceRadius: 50, // Balanced center hole
                          sections: _buildSections(data),
                        ),
                      ),
                      // Center Text
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Total',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppTheme.textGrey,
                              ),
                            ),
                            Text(
                              _formatCompactCurrency(widget.totalValue),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(width: 24),

              // 2. Legend List (Right)
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Show up to 6 legend items
                    ...data.take(6).map((item) {
                      final index = data.indexOf(item);
                      final isTouched = index == touchedIndex;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          children: [
                            // Type icon (replaces dot for better clarity)
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: _getTypeColor(item.type).withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _getTypeIcon(item.type),
                                size: 12,
                                color: _getTypeColor(item.type),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Name
                            Expanded(
                              child: Text(
                                _getTypeLabel(item.type),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: isTouched
                                          ? Colors.white
                                          : AppTheme.textGrey,
                                      fontWeight: isTouched
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Percent
                            Text(
                              '${item.percent.toStringAsFixed(0)}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      );
                    }),
                    // Overflow indicator when more than 6 categories
                    if (data.length > 6)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          '+${data.length - 6} more',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textGrey,
                                    fontStyle: FontStyle.italic,
                                  ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(List<AssetTypeBreakdown> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isTouched = index == touchedIndex;
      final radius = isTouched ? 28.0 : 22.0; // Slightly thicker donut
      final color = _getTypeColor(item.type);

      return PieChartSectionData(
        color: color,
        value: item.percent,
        title: '', // No title on chart
        radius: radius,
        badgeWidget: isTouched ? _buildBadge(item.percent) : null,
        badgePositionPercentageOffset: 1.3,
      );
    }).toList();
  }
  
  Widget _buildBadge(double percent) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${percent.toStringAsFixed(0)}%',
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  // Helper Methods for Colors, Icons, and Labels
  // Icons from AssetTypeUtils; colors kept distinct for pie chart contrast
  IconData _getTypeIcon(String typeString) {
    return AssetTypeUtils.getTypeIcon(_parseAssetType(typeString));
  }

  Color _getTypeColor(String typeString) {
    final type = _parseAssetType(typeString);
    switch (type) {
      case AssetType.crypto:
        return AppTheme.electricBlue;
      case AssetType.stock:
        return AppTheme.emeraldAccent;
      case AssetType.realEstate:
        return Colors.purpleAccent;
      case AssetType.cash:
        return AppTheme.textGrey;
      case AssetType.etf:
        return Colors.amber;
      case AssetType.bond:
        return Colors.teal;
      case AssetType.liability:
        return AppTheme.alertRed;
      case AssetType.custom:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getTypeLabel(String typeString) {
    final type = _parseAssetType(typeString);
    switch (type) {
      case AssetType.realEstate: return 'Real Est.';
      case AssetType.etf: return 'ETF';
      case AssetType.liability: return 'Liability';
      case AssetType.custom:
        // If the original string was 'other' (from aggregation), show 'Others'
        if (typeString == 'other') return 'Others';
        return 'Custom';
      default: return typeString[0].toUpperCase() + typeString.substring(1);
    }
  }

  AssetType _parseAssetType(String typeString) {
    try {
      return AssetType.fromString(typeString);
    } catch (e) {
      return AssetType.custom;
    }
  }

  String _formatCompactCurrency(double value) {
    if (value >= 1000000000) return '\$${(value / 1000000000).toStringAsFixed(1)}B';
    if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}K';
    return '\$${value.toStringAsFixed(0)}';
  }
}
