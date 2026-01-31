import 'package:flutter/material.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/allocation_legend.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/allocation_pie_chart.dart';

/// Enhanced Allocation Section Widget
/// Displays asset allocation using an interactive pie chart with legend
/// Supports selection synchronization between chart and legend
class EnhancedAllocationSection extends StatefulWidget {
  final List<AssetTypeBreakdown> allocations;

  const EnhancedAllocationSection({
    super.key,
    required this.allocations,
  });

  @override
  State<EnhancedAllocationSection> createState() =>
      _EnhancedAllocationSectionState();
}

class _EnhancedAllocationSectionState extends State<EnhancedAllocationSection> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.allocations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Asset Allocation',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.pie_chart,
                        size: 16,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.allocations.length} types',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Pie Chart with bidirectional sync
            AllocationPieChart(
              allocations: widget.allocations,
              selectedIndex: selectedIndex,
              onSectionTouched: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            // Legend with bidirectional sync
            AllocationLegend(
              allocations: widget.allocations,
              selectedIndex: selectedIndex,
              onTap: (index) {
                setState(() {
                  // Toggle selection: deselect if already selected
                  selectedIndex = selectedIndex == index ? null : index;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
