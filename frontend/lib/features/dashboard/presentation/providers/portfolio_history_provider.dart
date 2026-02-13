import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/portfolio_history_chart.dart';

part 'portfolio_history_provider.g.dart';

/// Provider for portfolio history data
@riverpod
class PortfolioHistory extends _$PortfolioHistory {
  @override
  FutureOr<List<PortfolioHistoryPoint>> build(String period) async {
    // No backend endpoint for /portfolio/history yet. Return empty to avoid fake data.
    // See frontend/docs/MOCK_AUDIT_REPORT.md
    return [];
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
