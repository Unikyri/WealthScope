import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/features/ai/domain/entities/scenario_result.dart';

part 'simulator_provider.g.dart';

/// Simulator Provider
/// Manages What-If scenario simulations
@riverpod
class Simulator extends _$Simulator {
  @override
  AsyncValue<ScenarioResult?> build() {
    return const AsyncValue.data(null);
  }

  /// Run a What-If scenario simulation
  Future<ScenarioResult> runSimulation({
    required String type,
    required Map<String, dynamic> parameters,
    bool includeAIAnalysis = false,
  }) async {
    state = const AsyncValue.loading();

    try {
      // TODO: Integrate with actual backend API
      // Simulate processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Check if provider is still mounted after async gap
      if (!ref.mounted) throw Exception('Provider disposed');

      // Mock result for now
      final result = _generateMockResult(type, parameters, includeAIAnalysis);

      state = AsyncValue.data(result);
      return result;
    } catch (e, stack) {
      if (!ref.mounted) rethrow;
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// Generate mock simulation result
  ScenarioResult _generateMockResult(
    String type,
    Map<String, dynamic> parameters,
    bool includeAIAnalysis,
  ) {
    const currentValue = 50000.0;
    double projectedValue;
    String? aiAnalysis;

    switch (type) {
      case 'marketMove':
        final changePercent = parameters['change_percent'] as double;
        projectedValue = currentValue * (1 + changePercent / 100);

        if (includeAIAnalysis) {
          if (changePercent < 0) {
            aiAnalysis =
                'A ${changePercent.abs()}% market decline would significantly impact your portfolio. '
                'Consider diversifying into defensive assets or reviewing stop-loss strategies. '
                'This scenario suggests maintaining a cash reserve for potential buying opportunities.';
          } else {
            aiAnalysis =
                'A ${changePercent}% market gain would boost your portfolio value. '
                'Consider taking profits on high-performing assets or rebalancing to maintain '
                'your target allocation. Review tax implications before making major changes.';
          }
        }
        break;

      case 'buyAsset':
      case 'sellAsset':
        final quantity = parameters['quantity'] as double;
        final price = parameters['price'] as double;
        final transactionValue = quantity * price;

        if (type == 'buyAsset') {
          // Assume 5% growth on new investment
          projectedValue = currentValue - transactionValue + (transactionValue * 1.05);

          if (includeAIAnalysis) {
            aiAnalysis =
                'Adding \$${transactionValue.toStringAsFixed(2)} to your portfolio increases exposure. '
                'This purchase aligns with a growth strategy. Monitor position size to maintain '
                'proper diversification. Consider dollar-cost averaging if entering a volatile position.';
          }
        } else {
          // Selling reduces portfolio
          projectedValue = currentValue - transactionValue;

          if (includeAIAnalysis) {
            aiAnalysis =
                'Selling \$${transactionValue.toStringAsFixed(2)} will reduce portfolio value but may '
                'improve liquidity or reduce risk. Ensure you\'re aware of tax implications. '
                'Consider reinvestment opportunities if this is part of a rebalancing strategy.';
          }
        }
        break;

      default:
        projectedValue = currentValue;
        if (includeAIAnalysis) {
          aiAnalysis = 'This scenario type is not yet fully implemented. '
              'Results shown are estimates and should be reviewed carefully.';
        }
    }

    final valueChange = projectedValue - currentValue;
    final percentChange = (valueChange / currentValue) * 100;

    // Calculate risk score based on change magnitude
    final riskScore = _calculateRiskScore(percentChange);

    return ScenarioResult(
      scenarioType: type,
      currentValue: currentValue,
      projectedValue: projectedValue,
      valueChange: valueChange,
      percentChange: percentChange,
      aiAnalysis: aiAnalysis,
      riskScore: riskScore,
      additionalData: parameters,
    );
  }

  /// Calculate risk score based on percent change
  double _calculateRiskScore(double percentChange) {
    // Higher absolute changes = higher risk
    final absChange = percentChange.abs();

    if (absChange < 5) return 20;
    if (absChange < 10) return 35;
    if (absChange < 20) return 55;
    if (absChange < 30) return 75;
    return 90;
  }

  /// Clear current simulation result
  void clearResult() {
    state = const AsyncValue.data(null);
  }
}
