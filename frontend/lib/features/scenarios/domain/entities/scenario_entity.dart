/// Domain Entity for Portfolio State
class PortfolioStateEntity {
  final double totalValue;
  final double totalInvested;
  final double gainLoss;
  final double gainLossPercent;
  final int assetCount;
  final List<AllocationItemEntity> allocation;

  const PortfolioStateEntity({
    required this.totalValue,
    required this.totalInvested,
    required this.gainLoss,
    required this.gainLossPercent,
    required this.assetCount,
    required this.allocation,
  });
}

/// Domain Entity for Allocation Item
class AllocationItemEntity {
  final String type;
  final double value;
  final double percent;

  const AllocationItemEntity({
    required this.type,
    required this.value,
    required this.percent,
  });
}

/// Domain Entity for Change Detail
class ChangeDetailEntity {
  final String type;
  final String description;
  final double oldValue;
  final double newValue;
  final double difference;

  const ChangeDetailEntity({
    required this.type,
    required this.description,
    required this.oldValue,
    required this.newValue,
    required this.difference,
  });
}

/// Domain Entity for Simulation Result
class SimulationResultEntity {
  final PortfolioStateEntity currentState;
  final PortfolioStateEntity projectedState;
  final List<ChangeDetailEntity> changes;
  final String aiAnalysis;
  final List<String> warnings;

  const SimulationResultEntity({
    required this.currentState,
    required this.projectedState,
    required this.changes,
    required this.aiAnalysis,
    required this.warnings,
  });
}

/// Domain Entity for Historical Statistics
class HistoricalStatsEntity {
  final String symbol;
  final String period;
  final double volatility;
  final double maxDrawdown;
  final double averageReturn;
  final double bestDay;
  final double worstDay;
  final int positiveDays;
  final int negativeDays;
  final int dataPoints;

  const HistoricalStatsEntity({
    required this.symbol,
    required this.period,
    required this.volatility,
    required this.maxDrawdown,
    required this.averageReturn,
    required this.bestDay,
    required this.worstDay,
    required this.positiveDays,
    required this.negativeDays,
    required this.dataPoints,
  });
}

/// Domain Entity for Scenario Template
class ScenarioTemplateEntity {
  final String id;
  final String name;
  final String description;
  final String type;
  final Map<String, dynamic> parameters;

  const ScenarioTemplateEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.parameters,
  });
}
