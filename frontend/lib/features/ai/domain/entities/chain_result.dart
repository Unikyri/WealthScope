/// Domain entity representing a chain scenario simulation result.
class ChainResult {
  final List<ChainStep> steps;
  final PortfolioImpact cumulativeImpact;
  final String aiExplanation;
  final RiskAssessment riskAssessment;
  final DateTime simulatedAt;

  const ChainResult({
    required this.steps,
    required this.cumulativeImpact,
    required this.aiExplanation,
    required this.riskAssessment,
    required this.simulatedAt,
  });

  factory ChainResult.fromJson(Map<String, dynamic> json) {
    return ChainResult(
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => ChainStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      cumulativeImpact: PortfolioImpact.fromJson(
          json['cumulative_impact'] as Map<String, dynamic>? ?? {}),
      aiExplanation: json['ai_explanation'] as String? ?? '',
      riskAssessment: RiskAssessment.fromJson(
          json['risk_assessment'] as Map<String, dynamic>? ?? {}),
      simulatedAt:
          DateTime.tryParse(json['simulated_at'] as String? ?? '') ??
              DateTime.now(),
    );
  }
}

/// A single step in a chain simulation.
class ChainStep {
  final int order;
  final String scenarioType;
  final Map<String, dynamic> parameters;
  final PortfolioImpact impact;
  final String description;

  const ChainStep({
    required this.order,
    required this.scenarioType,
    required this.parameters,
    required this.impact,
    required this.description,
  });

  factory ChainStep.fromJson(Map<String, dynamic> json) {
    return ChainStep(
      order: json['order'] as int? ?? 0,
      scenarioType: json['scenario_type'] as String? ?? '',
      parameters: json['parameters'] as Map<String, dynamic>? ?? {},
      impact: PortfolioImpact.fromJson(
          json['impact'] as Map<String, dynamic>? ?? {}),
      description: json['description'] as String? ?? '',
    );
  }
}

/// Impact on portfolio for a scenario step.
class PortfolioImpact {
  final double valueBefore;
  final double valueAfter;
  final double absoluteChange;
  final double percentChange;

  const PortfolioImpact({
    required this.valueBefore,
    required this.valueAfter,
    required this.absoluteChange,
    required this.percentChange,
  });

  factory PortfolioImpact.fromJson(Map<String, dynamic> json) {
    return PortfolioImpact(
      valueBefore: (json['value_before'] as num?)?.toDouble() ?? 0.0,
      valueAfter: (json['value_after'] as num?)?.toDouble() ?? 0.0,
      absoluteChange: (json['absolute_change'] as num?)?.toDouble() ?? 0.0,
      percentChange: (json['percent_change'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// AI-generated risk assessment for a chain scenario.
class RiskAssessment {
  final String level;
  final int score;
  final String summary;
  final List<String> warnings;
  final List<String> recommendations;

  const RiskAssessment({
    required this.level,
    required this.score,
    required this.summary,
    required this.warnings,
    required this.recommendations,
  });

  factory RiskAssessment.fromJson(Map<String, dynamic> json) {
    return RiskAssessment(
      level: json['level'] as String? ?? 'medium',
      score: json['score'] as int? ?? 50,
      summary: json['summary'] as String? ?? '',
      warnings: (json['warnings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}
