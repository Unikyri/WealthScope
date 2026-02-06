import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Data model for allocation items used in pie charts
class AllocationItem {
  final String name;
  final double percent;
  final double value;

  const AllocationItem({
    required this.name,
    required this.percent,
    required this.value,
  });
}

/// Main chart widget comparing current portfolio vs projected simulation
class SimulationComparisonChart extends StatelessWidget {
  final double currentValue;
  final double projectedValue;
  final List<AllocationItem> currentAllocation;
  final List<AllocationItem> projectedAllocation;

  const SimulationComparisonChart({
    super.key,
    required this.currentValue,
    required this.projectedValue,
    required this.currentAllocation,
    required this.projectedAllocation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Bar chart comparison
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: [currentValue, projectedValue].reduce((a, b) => a > b ? a : b) * 1.2,
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: currentValue,
                      color: Theme.of(context).colorScheme.primary,
                      width: 40,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      toY: projectedValue,
                      color: projectedValue >= currentValue
                          ? Colors.green
                          : Colors.red,
                      width: 40,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                ),
              ],
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          value == 0 ? 'Current' : 'Projected',
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 60,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '\$${(value / 1000).toStringAsFixed(0)}K',
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Allocation comparison (side by side pie charts)
        Row(
          children: [
            Expanded(
              child: _AllocationPieChart(
                title: 'Current',
                allocation: currentAllocation,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _AllocationPieChart(
                title: 'Projected',
                allocation: projectedAllocation,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Private widget for displaying allocation as a pie chart
class _AllocationPieChart extends StatelessWidget {
  final String title;
  final List<AllocationItem> allocation;

  const _AllocationPieChart({
    required this.title,
    required this.allocation,
  });

  @override
  Widget build(BuildContext context) {
    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];

    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: PieChart(
            PieChartData(
              sections: allocation.asMap().entries.map((entry) {
                return PieChartSectionData(
                  value: entry.value.percent,
                  color: colors[entry.key % colors.length],
                  title: '${entry.value.percent.toStringAsFixed(0)}%',
                  radius: 50,
                  titleStyle: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 20,
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget showing the financial impact of the simulation
class ImpactIndicator extends StatelessWidget {
  final double currentValue;
  final double projectedValue;

  const ImpactIndicator({
    super.key,
    required this.currentValue,
    required this.projectedValue,
  });

  @override
  Widget build(BuildContext context) {
    final difference = projectedValue - currentValue;
    final percentChange = currentValue > 0
        ? (difference / currentValue) * 100
        : 0.0;
    final isPositive = difference >= 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPositive
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPositive ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            color: isPositive ? Colors.green : Colors.red,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Projected Impact',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  '${isPositive ? '+' : ''}\$${difference.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                ),
                Text(
                  '${isPositive ? '+' : ''}${percentChange.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
