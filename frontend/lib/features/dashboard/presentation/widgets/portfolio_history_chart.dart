import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

/// Data model for portfolio history points
class PortfolioHistoryPoint {
  final DateTime date;
  final double value;

  const PortfolioHistoryPoint({
    required this.date,
    required this.value,
  });
}

/// Chart widget displaying portfolio value over time
class PortfolioHistoryChart extends StatelessWidget {
  final List<PortfolioHistoryPoint> data;
  final String period;
  final ValueChanged<String>? onPeriodChanged;

  const PortfolioHistoryChart({
    super.key,
    required this.data,
    this.period = '1M',
    this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (data.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Text(
            'No historical data available',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final isPositive = data.last.value >= data.first.value;
    final lineColor = isPositive 
        ? const Color(0xFF00BFA5) 
        : const Color(0xFFFF5252);
    final change = data.last.value - data.first.value;
    final changePercent = (change / data.first.value) * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stats row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Portfolio Value',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${data.last.value.toStringAsFixed(2)}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: lineColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: lineColor.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    color: lineColor,
                    size: 18,
                    weight: 700,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${isPositive ? '+' : ''}${changePercent.toStringAsFixed(2)}%',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: lineColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Period selector
        _PeriodSelector(
          selected: period,
          onChanged: onPeriodChanged ?? (_) {},
        ),
        const SizedBox(height: 16),

        // Chart
        SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: _getInterval(),
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: colorScheme.outlineVariant.withOpacity(0.1),
                    strokeWidth: 0.5,
                    dashArray: [5, 5],
                  );
                },
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    interval: _getBottomInterval(),
                    getTitlesWidget: (value, meta) => _getBottomTitles(
                      value,
                      meta,
                      theme,
                    ),
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: data.asMap().entries.map((e) {
                    return FlSpot(e.key.toDouble(), e.value.value);
                  }).toList(),
                  isCurved: true,
                  curveSmoothness: 0.35,
                  color: lineColor,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        lineColor.withOpacity(0.15),
                        lineColor.withOpacity(0.0),
                      ],
                    ),
                  ),
                  shadow: Shadow(
                    color: lineColor.withOpacity(0.3),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: colorScheme.surfaceContainerHighest,
                  tooltipBorder: BorderSide(
                    color: lineColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                  tooltipRoundedRadius: 12,
                  tooltipPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  getTooltipItems: (spots) {
                    return spots.map((spot) {
                      if (spot.spotIndex >= data.length) return null;
                      final point = data[spot.spotIndex];
                      return LineTooltipItem(
                        '\$${point.value.toStringAsFixed(2)}\n',
                        theme.textTheme.titleMedium!.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: _formatDate(point.date),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  },
                ),
                getTouchedSpotIndicator: (barData, spotIndexes) {
                  return spotIndexes.map((index) {
                    return TouchedSpotIndicatorData(
                      FlLine(
                        color: lineColor.withOpacity(0.5),
                        strokeWidth: 2,
                        dashArray: [3, 3],
                      ),
                      FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 6,
                            color: colorScheme.surface,
                            strokeWidth: 3,
                            strokeColor: lineColor,
                          );
                        },
                      ),
                    );
                  }).toList();
                },
                handleBuiltInTouches: true,
              ),
              minY: _getMinY(),
              maxY: _getMaxY(),
            ),
          ),
        ),
      ],
    );
  }

  /// Calculate horizontal grid interval
  double _getInterval() {
    if (data.isEmpty) return 1000;
    
    final values = data.map((p) => p.value).toList();
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final range = max - min;
    
    if (range == 0) return 1000;
    return range / 4;
  }

  /// Calculate bottom axis interval
  double _getBottomInterval() {
    if (data.length <= 5) return 1;
    return (data.length / 4).floorToDouble();
  }

  /// Get minimum Y value with padding
  double _getMinY() {
    if (data.isEmpty) return 0;
    final min = data.map((p) => p.value).reduce((a, b) => a < b ? a : b);
    return min * 0.95;
  }

  /// Get maximum Y value with padding
  double _getMaxY() {
    if (data.isEmpty) return 100000;
    final max = data.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    return max * 1.05;
  }

  /// Format bottom axis labels (dates)
  Widget _getBottomTitles(double value, TitleMeta meta, ThemeData theme) {
    if (value.toInt() < 0 || value.toInt() >= data.length) {
      return const SizedBox.shrink();
    }

    final point = data[value.toInt()];
    final dateFormat = _getDateFormat();
    
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        dateFormat.format(point.date),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Get date format based on period
  DateFormat _getDateFormat() {
    switch (period) {
      case '1W':
        return DateFormat('EEE'); // Mon, Tue, etc.
      case '1M':
        return DateFormat('d'); // 1, 2, 3, etc.
      case '3M':
      case '6M':
        return DateFormat('MMM d'); // Jan 1, etc.
      case '1Y':
        return DateFormat('MMM'); // Jan, Feb, etc.
      case 'ALL':
        return DateFormat('yyyy'); // 2024, 2025, etc.
      default:
        return DateFormat('MMM d');
    }
  }

  /// Format date for tooltip
  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  /// Format value with K/M suffix
  String _formatValue(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(0)}K';
    } else {
      return '\$${value.toStringAsFixed(0)}';
    }
  }
}

/// Period selector widget
class _PeriodSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _PeriodSelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const periods = ['1W', '1M', '3M', '6M', '1Y', 'ALL'];

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: periods.map((period) {
          final isSelected = period == selected;
          return GestureDetector(
            onTap: () => onChanged(period),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Text(
                period,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
