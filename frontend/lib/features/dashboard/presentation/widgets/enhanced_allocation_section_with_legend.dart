import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
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
  @override
  Widget build(BuildContext context) {
    // Process allocations: group small segments into "Other"
    final data = _processAllocations(widget.allocations);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.cardGrey,
            AppTheme.cardGrey.withOpacity(0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
          BoxShadow(
            color: AppTheme.electricBlue.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 15),
            spreadRadius: -10,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.electricBlue.withOpacity(0.2),
                          AppTheme.electricBlue.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.pie_chart_rounded,
                      color: AppTheme.electricBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Asset Allocation',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.electricBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.electricBlue.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  'View Details',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.electricBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Content Row
          Row(
            children: [
              // 1. Donut Chart (Left)
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            enabled: false,
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 3,
                          centerSpaceRadius: 58,
                          sections: _buildSections(data),
                        ),
                      ),
                      // Center Text
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppTheme.cardGrey,
                                AppTheme.cardGrey.withOpacity(0.8),
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Total',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: AppTheme.textGrey,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatCompactCurrency(widget.totalValue),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                              ),
                            ],
                          ),
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
                  children: data.take(4).map((item) {
                    final index = data.indexOf(item);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          // Dot
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                                color: _getTypeColor(item.type),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: _getTypeColor(item.type)
                                        .withOpacity(0.5),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ]),
                          ),
                          const SizedBox(width: 12),
                          // Name
                          Text(
                            _getTypeLabel(item.type),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppTheme.textGrey,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                          const Spacer(),
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
                  }).toList(),
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
      final color = _getTypeColor(item.type);

      return PieChartSectionData(
        color: color,
        value: item.percent,
        title: '', // No title on chart
        radius: 30.0,
        badgeWidget: null,
        gradient: LinearGradient(
          colors: [
            color,
            color.withOpacity(0.7),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderSide: BorderSide(
          color: AppTheme.cardGrey,
          width: 3,
        ),
      );
    }).toList();
  }

  // Helper Methods for Colors and Labels
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
      case AssetType.gold:
        return Colors.orange;
      case AssetType.bond:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _getTypeLabel(String typeString) {
    final type = _parseAssetType(typeString);
    switch (type) {
      case AssetType.realEstate:
        return 'Real Est.';
      case AssetType.etf:
        return 'ETF';
      default:
        return typeString[0].toUpperCase() + typeString.substring(1);
    }
  }

  AssetType _parseAssetType(String typeString) {
    try {
      return AssetType.fromString(typeString);
    } catch (e) {
      return AssetType.other;
    }
  }

  String _formatCompactCurrency(double value) {
    if (value >= 1000000000)
      return '\$${(value / 1000000000).toStringAsFixed(1)}B';
    if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}K';
    return '\$${value.toStringAsFixed(0)}';
  }
}
