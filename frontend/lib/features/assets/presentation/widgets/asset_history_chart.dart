import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';

class AssetHistoryChart extends StatefulWidget {
  final List<double> prices;
  final List<DateTime> dates;
  final bool isPositive;

  const AssetHistoryChart({
    super.key,
    required this.prices,
    required this.dates,
    required this.isPositive,
  });

  @override
  State<AssetHistoryChart> createState() => _AssetHistoryChartState();
}

class _AssetHistoryChartState extends State<AssetHistoryChart> {
  String _selectedFilter = '1W';
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.prices.isEmpty) {
      return const SizedBox(
        height: 250,
        child: Center(child: Text('No chart data available')),
      );
    }

    final lineColor = widget.isPositive ? AppTheme.emeraldAccent : AppTheme.alertRed;

    return Column(
      children: [
        // Filter Buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['1D', '1W', '1M', '1Y', 'ALL'].map((filter) {
              final isSelected = _selectedFilter == filter;
              return GestureDetector(
                onTap: () => setState(() => _selectedFilter = filter),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected 
                        ? Border.all(color: Colors.white.withOpacity(0.1))
                        : null,
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),

        // Chart
        SizedBox(
          height: 250,
          width: double.infinity,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => AppTheme.cardGrey,
                  tooltipBorder: BorderSide(color: Colors.white.withOpacity(0.1)),
                  getTooltipItems: (touchedSpots) {
                     return touchedSpots.map((spot) {
                      final date = widget.dates[spot.spotIndex];
                      final price = widget.prices[spot.spotIndex];
                      return LineTooltipItem(
                        '\$${price.toStringAsFixed(2)}\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: DateFormat('MMM d, HH:mm').format(date),
                            style: TextStyle(
                              color: AppTheme.textGrey,
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
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
                        color: Colors.white.withOpacity(0.2),
                        strokeWidth: 1,
                        dashArray: [4, 4],
                      ),
                      FlDotData(
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 6,
                            color: lineColor,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                    );
                  }).toList();
                },
                touchCallback: (event, response) {
                   if (response?.lineBarSpots != null && response!.lineBarSpots!.isNotEmpty) {
                    setState(() {
                      _touchedIndex = response.lineBarSpots!.first.spotIndex;
                    });
                  } else {
                    setState(() {
                      _touchedIndex = null;
                    });
                  }
                },
                handleBuiltInTouches: true,
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: _getSpots(),
                  isCurved: true,
                  curveSmoothness: 0.2,
                  color: lineColor,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        lineColor.withOpacity(0.2),
                        lineColor.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<FlSpot> _getSpots() {
    // Determine how many points to show based on filter (mock logic)
    // Real implementation would filter widget.prices/dates based on _selectedFilter
    List<double> data = widget.prices;
    
    return data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();
  }
}
