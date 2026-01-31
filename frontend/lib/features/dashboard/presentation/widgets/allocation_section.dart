import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';
import 'package:intl/intl.dart';

/// Allocation Section Widget
/// Displays asset allocation using a pie chart
class AllocationSection extends StatelessWidget {
  final List<AssetTypeBreakdown> allocations;

  const AllocationSection({
    super.key,
    required this.allocations,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (allocations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Asset Allocation',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: PieChart(
                      PieChartData(
                        sections: _generateSections(theme),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: _AllocationLegend(allocations: allocations),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _generateSections(ThemeData theme) {
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];

    return allocations.asMap().entries.map((entry) {
      final index = entry.key;
      final allocation = entry.value;
      final color = colors[index % colors.length];

      return PieChartSectionData(
        value: allocation.percent,
        title: '${allocation.percent.toStringAsFixed(0)}%',
        color: color,
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}

class _AllocationLegend extends StatelessWidget {
  final List<AssetTypeBreakdown> allocations;

  const _AllocationLegend({required this.allocations});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: allocations.asMap().entries.map((entry) {
        final index = entry.key;
        final allocation = entry.value;
        final color = colors[index % colors.length];

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatTypeName(allocation.type),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      numberFormat.format(allocation.value),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatTypeName(String type) {
    switch (type.toLowerCase()) {
      case 'stock':
        return 'Stocks';
      case 'etf':
        return 'ETFs';
      case 'crypto':
        return 'Cryptocurrency';
      case 'bond':
        return 'Bonds';
      case 'real_estate':
        return 'Real Estate';
      case 'gold':
        return 'Gold';
      case 'cash':
        return 'Cash';
      case 'other':
        return 'Other';
      default:
        return type.toUpperCase();
    }
  }
}
