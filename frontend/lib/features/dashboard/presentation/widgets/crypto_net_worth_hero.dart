import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/core/theme/custom_icons.dart';
import 'package:wealthscope_app/core/currency/currency_extensions.dart';

/// Crypto Net Worth Hero Section
/// Displays Total Net Worth with a Sparkline background
class CryptoNetWorthHero extends ConsumerWidget {
  final double totalValue;
  final double change;
  final double changePercent;
  final List<double> historyData; // Simple list of values for sparkline

  const CryptoNetWorthHero({
    super.key,
    required this.totalValue,
    required this.change,
    required this.changePercent,
    this.historyData = const [10, 15, 13, 20, 18, 25, 22, 30, 28, 35], // Fake data default
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isPositive = change >= 0;
    final changeColor = isPositive ? AppTheme.emeraldAccent : AppTheme.alertRed;

    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.cardGrey,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          // Subtle neon glow border effect
          BoxShadow(
            color: AppTheme.electricBlue.withOpacity(0.15),
            blurRadius: 15,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Gradient Blob
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.electricBlue.withOpacity(0.2),
              ),
            ).animate().scale(
              duration: 2.seconds, 
              curve: Curves.easeInOut,
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.2, 1.2),
            ).then().scale(
              duration: 2.seconds,
              begin: const Offset(1.2, 1.2),
              end: const Offset(0.8, 0.8),
            ), // Requires flutter_animate import but not added yet, manual blur for now
          ),
          
          // Sparkline Chart (Background)
          Positioned.fill(
            top: 80, // Push chart down
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: _SimpleSparkline(data: historyData),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Net Worth',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.textGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: changeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isPositive ? CustomIcons.trendingUp : CustomIcons.trendingDown,
                            color: changeColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${isPositive ? "+" : ""}${changePercent.toStringAsFixed(1)}% (24h)',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: changeColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),

                // Value
                Text(
                  _formatCurrency(totalValue, ref),
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.0,
                    fontFamily: 'Manrope', // Fallback to theme default if not loaded
                  ),
                ),
              ],
            ),
          ),
          
          // Floating Point Marker (Visual flair)
          Positioned(
            right: 40,
            bottom: 60,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppTheme.electricBlue,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.cardGrey, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.electricBlue.withOpacity(0.8),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value, WidgetRef ref) {
    // Simple formatting for now
    return '\$${value.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }
}

class _SimpleSparkline extends StatelessWidget {
  final List<double> data;

  const _SimpleSparkline({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: data.length.toDouble() - 1,
        minY: data.reduce((a, b) => a < b ? a : b) * 0.9,
        maxY: data.reduce((a, b) => a > b ? a : b) * 1.1,
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
            isCurved: true,
            color: AppTheme.electricBlue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppTheme.electricBlue.withOpacity(0.3),
                  AppTheme.electricBlue.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: const LineTouchData(enabled: false), // Static background
      ),
    );
  }
}
