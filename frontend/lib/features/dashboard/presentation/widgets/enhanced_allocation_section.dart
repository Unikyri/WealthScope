import 'package:flutter/material.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/allocation_pie_chart.dart';
import 'package:intl/intl.dart';

/// Enhanced Allocation Section with Interactive Pie Chart
/// Demonstrates usage of AllocationPieChart widget
class EnhancedAllocationSection extends StatelessWidget {
  final List<AssetTypeBreakdown> allocations;

  const EnhancedAllocationSection({
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
      elevation: 2,
      shadowColor: theme.colorScheme.primary.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Asset Distribution',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap on sections to highlight',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            // Interactive Pie Chart
            AllocationPieChart(allocations: allocations),
            const SizedBox(height: 24),
            // Legend with values
            _AllocationLegend(allocations: allocations),
          ],
        ),
      ),
    );
  }
}

/// Legend showing asset type breakdown with colors and values
class _AllocationLegend extends StatelessWidget {
  final List<AssetTypeBreakdown> allocations;

  const _AllocationLegend({required this.allocations});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Column(
      children: allocations.map((allocation) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              // Color indicator
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: _getLegendColor(allocation.type),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              // Asset type label
              Expanded(
                child: Text(
                  _formatTypeName(allocation.type),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Percentage
              Text(
                '${allocation.percent.toStringAsFixed(1)}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              // Value
              Text(
                numberFormat.format(allocation.value),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Get matching color for legend (matches pie chart colors)
  Color _getLegendColor(String type) {
    switch (type.toLowerCase()) {
      case 'stock':
      case 'stocks':
        return Colors.blue;
      case 'etf':
      case 'etfs':
        return Colors.indigo;
      case 'real estate':
      case 'realestate':
        return Colors.green;
      case 'gold':
        return Colors.amber;
      case 'crypto':
      case 'cryptocurrency':
        return Colors.orange;
      case 'bond':
      case 'bonds':
        return Colors.purple;
      default:
        return Colors.grey;
    }
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
