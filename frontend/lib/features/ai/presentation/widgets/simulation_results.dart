import 'package:flutter/material.dart';
import 'package:wealthscope_app/features/ai/domain/entities/scenario_result.dart';
import 'package:wealthscope_app/features/ai/presentation/widgets/simulation_chart.dart';

/// Portfolio state snapshot for comparison
class PortfolioState {
  final double totalValue;
  final double gainLossPercent;
  final int assetCount;
  final List<AllocationItem> allocation;

  const PortfolioState({
    required this.totalValue,
    required this.gainLossPercent,
    required this.assetCount,
    required this.allocation,
  });
}

/// Detail of a change in the simulation
class ChangeDetail {
  final String type; // 'increase' or 'decrease'
  final String description;
  final double difference;

  const ChangeDetail({
    required this.type,
    required this.description,
    required this.difference,
  });
}

/// Comprehensive simulation results widget
class SimulationResults extends StatelessWidget {
  final ScenarioResult result;
  final PortfolioState? currentState;
  final PortfolioState? projectedState;
  final List<ChangeDetail>? changes;
  final List<String>? warnings;

  const SimulationResults({
    super.key,
    required this.result,
    this.currentState,
    this.projectedState,
    this.changes,
    this.warnings,
  });

  @override
  Widget build(BuildContext context) {
    // Build default states from result if not provided
    final current = currentState ?? _buildDefaultCurrentState();
    final projected = projectedState ?? _buildDefaultProjectedState();
    final changesList = changes ?? _buildDefaultChanges();
    final warningsList = warnings ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Simulation Results',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),

        // Impact summary
        ImpactIndicator(
          currentValue: current.totalValue,
          projectedValue: projected.totalValue,
        ),
        const SizedBox(height: 24),

        // Side by side comparison cards
        Row(
          children: [
            Expanded(
              child: _StateCard(
                title: 'Current',
                state: current,
                isPrimary: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StateCard(
                title: 'Projected',
                state: projected,
                isPrimary: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Charts
        SimulationComparisonChart(
          currentValue: current.totalValue,
          projectedValue: projected.totalValue,
          currentAllocation: current.allocation,
          projectedAllocation: projected.allocation,
        ),
        const SizedBox(height: 24),

        // Changes list
        if (changesList.isNotEmpty) ...[
          _ChangesSection(changes: changesList),
          const SizedBox(height: 24),
        ],

        // AI Analysis
        if (result.aiAnalysis != null && result.aiAnalysis!.isNotEmpty)
          _AIAnalysisCard(analysis: result.aiAnalysis!),

        // Warnings
        if (warningsList.isNotEmpty) ...[
          const SizedBox(height: 16),
          _WarningsSection(warnings: warningsList),
        ],
      ],
    );
  }

  PortfolioState _buildDefaultCurrentState() {
    return PortfolioState(
      totalValue: result.currentValue,
      gainLossPercent: 0.0,
      assetCount: 1,
      allocation: [
        AllocationItem(name: 'Current Portfolio', percent: 100, value: result.currentValue),
      ],
    );
  }

  PortfolioState _buildDefaultProjectedState() {
    return PortfolioState(
      totalValue: result.projectedValue,
      gainLossPercent: result.percentChange,
      assetCount: 1,
      allocation: [
        AllocationItem(name: 'Projected Portfolio', percent: 100, value: result.projectedValue),
      ],
    );
  }

  List<ChangeDetail> _buildDefaultChanges() {
    if (result.valueChange == 0) return [];

    return [
      ChangeDetail(
        type: result.valueChange >= 0 ? 'increase' : 'decrease',
        description: 'Portfolio Value Change',
        difference: result.valueChange.abs(),
      ),
    ];
  }
}

/// Card showing portfolio state snapshot
class _StateCard extends StatelessWidget {
  final String title;
  final PortfolioState state;
  final bool isPrimary;

  const _StateCard({
    required this.title,
    required this.state,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = state.gainLossPercent >= 0;

    return Card(
      color: isPrimary
          ? theme.colorScheme.primaryContainer.withOpacity(0.3)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${state.totalValue.toStringAsFixed(2)}',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                  color: isPositive ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  '${isPositive ? '+' : ''}${state.gainLossPercent.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${state.assetCount} asset${state.assetCount != 1 ? 's' : ''}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// Section showing list of changes
class _ChangesSection extends StatelessWidget {
  final List<ChangeDetail> changes;

  const _ChangesSection({required this.changes});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Changes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),
            ...changes.map((change) => _ChangeItem(change: change)),
          ],
        ),
      ),
    );
  }
}

/// Individual change item
class _ChangeItem extends StatelessWidget {
  final ChangeDetail change;

  const _ChangeItem({required this.change});

  @override
  Widget build(BuildContext context) {
    final isIncrease = change.type == 'increase';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            isIncrease ? Icons.add_circle : Icons.remove_circle,
            color: isIncrease ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  change.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '${isIncrease ? '+' : '-'}\$${change.difference.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isIncrease ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
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

/// AI analysis display card
class _AIAnalysisCard extends StatelessWidget {
  final String analysis;

  const _AIAnalysisCard({required this.analysis});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.smart_toy,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'AI Analysis',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              analysis,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// Warnings section
class _WarningsSection extends StatelessWidget {
  final List<String> warnings;

  const _WarningsSection({required this.warnings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: Colors.orange.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Warnings',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...warnings.map(
              (w) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '• $w',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
