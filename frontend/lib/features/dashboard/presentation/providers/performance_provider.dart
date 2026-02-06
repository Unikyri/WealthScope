import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_performance.dart';

part 'performance_provider.g.dart';

/// Provider for portfolio performance metrics
@riverpod
class Performance extends _$Performance {
  @override
  FutureOr<PortfolioPerformance> build() async {
    // TODO: Replace with actual API call
    return _generateMockPerformance();
  }

  /// Generate mock performance data
  PortfolioPerformance _generateMockPerformance() {
    // Simulate realistic performance metrics
    return const PortfolioPerformance(
      todayChange: 1250.50,
      todayChangePercent: 1.92,
      weekChange: 3420.75,
      weekChangePercent: 5.48,
      monthChange: -850.25,
      monthChangePercent: -1.31,
      ytdChange: 8750.00,
      ytdChangePercent: 15.62,
    );
  }

  /// Refresh performance data
  void refresh() {
    ref.invalidateSelf();
  }
}
