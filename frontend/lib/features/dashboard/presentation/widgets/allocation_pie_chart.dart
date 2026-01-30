import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';

/// Interactive Pie Chart Widget for Portfolio Distribution
/// Displays asset allocation by type with touch interactions and animations
class AllocationPieChart extends StatefulWidget {
  final List<AssetAllocation> allocations;

  const AllocationPieChart({
    super.key,
    required this.allocations,
  });

  @override
  State<AllocationPieChart> createState() => _AllocationPieChartState();
}

class _AllocationPieChartState extends State<AllocationPieChart> {
  int touchedIndex = -1;

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
      final isTouched = index == touchedIndex;
      final radius = isTouched ? 60.0 : 50.0;
      final fontSize = isTouched ? 16.0 : 12.0;
      
      return PieChartSectionData(
        color: _getTypeColor(allocation.type),
        value: allocation.percentage,
        title: '${allocation.percentage.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
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
      case AssetType.realEstate:
        return Colors.green;
      case AssetType.gold:
        return Colors.amber;
      case AssetType.crypto:
        return Colors.orange;
      case AssetType.bond:
        return Colors.purple;
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
