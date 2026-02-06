import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/portfolio_history_chart.dart';

part 'portfolio_history_provider.g.dart';

/// Provider for portfolio history data
@riverpod
class PortfolioHistory extends _$PortfolioHistory {
  @override
  FutureOr<List<PortfolioHistoryPoint>> build(String period) async {
    // TODO: Replace with actual API call
    return _generateMockData(period);
  }

  /// Generate mock data for demonstration
  List<PortfolioHistoryPoint> _generateMockData(String period) {
    final now = DateTime.now();
    final points = <PortfolioHistoryPoint>[];

    switch (period) {
      case '1W':
        // 7 days of data
        for (int i = 6; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          final value = 50000.0 + (i * 500.0) + ((i % 2) * 200.0);
          points.add(PortfolioHistoryPoint(date: date, value: value));
        }
        break;

      case '1M':
        // 30 days of data
        for (int i = 29; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          final value = 45000.0 + (i * 200.0) + ((i % 3) * 300.0);
          points.add(PortfolioHistoryPoint(date: date, value: value));
        }
        break;

      case '3M':
        // 90 days of data (every 3 days)
        for (int i = 90; i >= 0; i -= 3) {
          final date = now.subtract(Duration(days: i));
          final value = 40000.0 + (i * 100.0) + ((i % 5) * 400.0);
          points.add(PortfolioHistoryPoint(date: date, value: value));
        }
        break;

      case '6M':
        // 180 days of data (every 6 days)
        for (int i = 180; i >= 0; i -= 6) {
          final date = now.subtract(Duration(days: i));
          final value = 35000.0 + (i * 80.0) + ((i % 7) * 500.0);
          points.add(PortfolioHistoryPoint(date: date, value: value));
        }
        break;

      case '1Y':
        // 365 days of data (every 12 days)
        for (int i = 365; i >= 0; i -= 12) {
          final date = now.subtract(Duration(days: i));
          final value = 30000.0 + (i * 50.0) + ((i % 10) * 600.0);
          points.add(PortfolioHistoryPoint(date: date, value: value));
        }
        break;

      case 'ALL':
        // 2 years of data (every 30 days)
        for (int i = 730; i >= 0; i -= 30) {
          final date = now.subtract(Duration(days: i));
          final value = 25000.0 + (i * 30.0) + ((i % 15) * 700.0);
          points.add(PortfolioHistoryPoint(date: date, value: value));
        }
        break;

      default:
        return _generateMockData('1M');
    }

    return points;
  }

  /// Refresh data for current period
  void refresh() {
    ref.invalidateSelf();
  }
}

/// Provider for selected period
@riverpod
class SelectedPeriod extends _$SelectedPeriod {
  @override
  String build() => '1M';

  void setPeriod(String period) {
    state = period;
  }
}
