import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:intl/intl.dart';

/// Interactive Pie Chart Widget for Portfolio Distribution
/// Displays asset allocation by type with touch interactions and animations
class AllocationPieChart extends StatefulWidget {
  final List<AssetTypeBreakdown> allocations;
  final int? selectedIndex;
  final Function(int?)? onSectionTouched;

  const AllocationPieChart({
    super.key,
    required this.allocations,
    this.selectedIndex,
    this.onSectionTouched,
  });

  @override
  State<AllocationPieChart> createState() => _AllocationPieChartState();
}

class _AllocationPieChartState extends State<AllocationPieChart> {
  @override
  Widget build(BuildContext context) {
    if (widget.allocations.isEmpty) {
      return const SizedBox.shrink();
    }

    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                // Deselect when touching outside
                if (widget.onSectionTouched != null &&
                    event is FlTapUpEvent) {
                  widget.onSectionTouched!(null);
                }
                return;
              }
              // Notify parent of selection
              final touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
              if (widget.onSectionTouched != null) {
                // Toggle: if already selected, deselect
                if (widget.selectedIndex == touchedIndex) {
                  widget.onSectionTouched!(null);
                } else {
                  widget.onSectionTouched!(touchedIndex);
                }
              }
            },
          ),
          borderData: FlBorderData(show: false),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: _buildSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    return widget.allocations.asMap().entries.map((entry) {
      final index = entry.key;
      final allocation = entry.value;
      final isSelected = index == widget.selectedIndex;
      final radius = isSelected ? 65.0 : 50.0;
      final fontSize = isSelected ? 16.0 : 12.0;
      final borderWidth = isSelected ? 3.0 : 0.0;
      
      return PieChartSectionData(
        color: _getTypeColor(allocation.type),
        value: allocation.percent,
        title: isSelected
            ? '${_getTypeLabel(allocation.type)}\n${allocation.percent.toStringAsFixed(1)}%'
            : '${allocation.percent.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: isSelected
              ? [
                  const Shadow(
                    color: Colors.black26,
                    offset: Offset(1, 1),
                    blurRadius: 2,
                  ),
                ]
              : null,
        ),
        borderSide: BorderSide(
          color: Colors.white,
          width: borderWidth,
        ),
        badgeWidget: isSelected ? _buildBadge(allocation) : null,
        badgePositionPercentageOffset: 1.5,
      );
    }).toList();
  }

  /// Build badge widget to show exact value on selected section
  Widget _buildBadge(AssetTypeBreakdown allocation) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        NumberFormat.currency(symbol: '\$', decimalDigits: 0)
            .format(allocation.value),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  /// Get localized label for asset type
  String _getTypeLabel(String typeString) {
    final type = _parseAssetType(typeString);

    switch (type) {
      case AssetType.stock:
        return 'Stocks';
      case AssetType.etf:
        return 'ETFs';
      case AssetType.bond:
        return 'Bonds';
      case AssetType.crypto:
        return 'Crypto';
      case AssetType.realEstate:
        return 'Real Estate';
      case AssetType.gold:
        return 'Gold';
      case AssetType.cash:
        return 'Cash';
      case AssetType.other:
        return 'Other';
    }
  }

  /// Get color for asset type with consistent mapping
  Color _getTypeColor(String typeString) {
    // Parse string to AssetType enum
    final type = _parseAssetType(typeString);
    
    switch (type) {
      case AssetType.stock:
        return Colors.blue;
      case AssetType.etf:
        return Colors.indigo;
      case AssetType.bond:
        return Colors.purple;
      case AssetType.crypto:
        return Colors.orange;
      case AssetType.realEstate:
        return Colors.green;
      case AssetType.gold:
        return Colors.amber;
      case AssetType.cash:
        return Colors.cyan;
      case AssetType.other:
        return Colors.grey;
    }
  }

  /// Parse type string to AssetType enum
  AssetType _parseAssetType(String typeString) {
    try {
      return AssetType.fromString(typeString);
    } catch (e) {
      return AssetType.other;
    }
  }
}
