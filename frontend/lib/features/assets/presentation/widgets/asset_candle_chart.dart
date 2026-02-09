import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';

class AssetCandleChart extends StatefulWidget {
  final String period;
  final Function(double?)? onCrosshairMoved;

  const AssetCandleChart({
    super.key, 
    required this.period,
    this.onCrosshairMoved,
  });

  @override
  State<AssetCandleChart> createState() => _AssetCandleChartState();
}

class _AssetCandleChartState extends State<AssetCandleChart> {
  double? _touchY;

  @override
  Widget build(BuildContext context) {
    // Simulate data based on period
    final candles = _getDataForPeriod(widget.period);
    
    return Container(
      height: 300,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
      child: BarChart(
        BarChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1000,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.white.withOpacity(0.05),
              strokeWidth: 1,
            ),
          ),
          extraLinesData: ExtraLinesData(
            horizontalLines: _touchY == null ? [] : [
              HorizontalLine(
                y: _touchY!,
                color: Colors.white.withOpacity(0.8),
                strokeWidth: 1,
                dashArray: [5, 5],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.centerRight,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                  labelResolver: (line) => '\$${line.y.toStringAsFixed(0)}',
                ),
              ),
            ],
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      _formatYLabel(value),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                interval: 3, // Increased interval for more "air"
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  // Safety check
                  if (index < 0 || index >= candles.length) return const SizedBox();
                  
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _getXLabel(index, widget.period),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: candles,
          barTouchData: BarTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            touchCallback: (FlTouchEvent event, barTouchResponse) {
              if (!event.isInterestedForInteractions ||
                  barTouchResponse == null ||
                  barTouchResponse.spot == null) {
                if (_touchY != null) {
                  setState(() {
                    _touchY = null;
                  });
                }
                return;
              }
              
              final spot = barTouchResponse.spot!;
              final touchedRod = spot.touchedRodData;
              setState(() {
                _touchY = touchedRod.toY; // Snap to top of body (Close/High)
              });
            },
            touchTooltipData: BarTouchTooltipData(
               getTooltipItem: (group, groupIndex, rod, rodIndex) {
                 return BarTooltipItem(
                   '\$${rod.toY.toStringAsFixed(0)}',
                   const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                 );
               }
            )
          ),
        ),
      ),
    );
  }

  String _formatYLabel(double value) {
    if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(0)}k';
    }
    return '\$${value.toStringAsFixed(0)}';
  }

  String _getXLabel(int index, String period) {
    switch (period) {
      case '1D':
        // 12 candles, roughly every 2 hours starting from 6 AM?
        final hour = 8 + (index * 2); 
        return '$hour:00';
      case '1W':
        // 7 candles, days of week
        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return days[index % 7];
      case '1M':
        // 10 candles, every ~3 days
        final day = 1 + (index * 3);
        return 'Day $day';
      case '1Y':
        // 12 candles, months
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        return months[index % 12];
      case 'ALL':
        // Years
        final year = 2020 + index;
        return '$year';
      default:
        return '$index';
    }
  }

  List<BarChartGroupData> _getDataForPeriod(String period) {
    // Consistent candle counts (~7-12) as requested
    int candleCount = 7;
    double startPrice = 45000;
    double volatility = 500;
    
    switch (period) {
      case '1D':
        candleCount = 12; // 2-hour intervals
        startPrice = 46200;
        volatility = 150;
        break;
      case '1W':
        candleCount = 7; // Daily
        startPrice = 45000;
        volatility = 800;
        break;
      case '1M':
        candleCount = 10; // ~3-day intervals
        startPrice = 42000;
        volatility = 700;
        break;
      case '1Y':
        candleCount = 12; // Monthly
        startPrice = 30000;
        volatility = 2500;
        break;
      case 'ALL':
        candleCount = 8; // Yearly
        startPrice = 10000;
        volatility = 8000;
        break;
    }

    final List<BarChartGroupData> candles = [];
    double currentOpen = startPrice;

    for (int i = 0; i < candleCount; i++) {
      // Random-ish walk simulation
      final move = (i % 2 == 0 ? 1 : -1) * (volatility * 0.5) + (i * volatility * 0.1); 
      final noise = (i * 1337 % 100) / 100 * volatility;
      
      final close = currentOpen + move + noise;
      final high = (currentOpen > close ? currentOpen : close) + (volatility * 0.3);
      final low = (currentOpen < close ? currentOpen : close) - (volatility * 0.3);

      candles.add(_makeCandle(i, currentOpen, high, low, close));
      
      currentOpen = close;
    }
    
    return candles;
  }

  BarChartGroupData _makeCandle(int x, double open, double high, double low, double close) {
    final isUp = close >= open;
    final color = isUp ? AppTheme.neonGreen : AppTheme.errorRed;
    final glowColor = color.withOpacity(0.5);

    return BarChartGroupData(
      x: x,
      barRods: [
        // Wick
        BarChartRodData(
          fromY: low,
          toY: high,
          color: glowColor,
          width: 2,
          borderRadius: BorderRadius.circular(2),
        ),
        // Body
        BarChartRodData(
          fromY: open,
          toY: close,
          gradient: LinearGradient(
              colors: [color, color.withOpacity(0.8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
          ),
          width: 12,
          borderRadius: BorderRadius.circular(2),
        ),
      ],
      showingTooltipIndicators: [],
    );
  }
}
