import 'package:flutter/material.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/allocation_legend.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/allocation_pie_chart.dart';

/// Enhanced Allocation Section Widget
/// Displays asset allocation using an interactive pie chart with legend
/// Supports selection synchronization between chart and legend
class EnhancedAllocationSection extends StatefulWidget {
  final List<AssetAllocation> allocations;

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
