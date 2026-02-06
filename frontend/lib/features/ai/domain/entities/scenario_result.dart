/// Scenario Result Entity
/// Represents the result of a What-If scenario simulation
class ScenarioResult {
  final String scenarioType;
  final double currentValue;
  final double projectedValue;
  final double valueChange;
  final double percentChange;
  final String? aiAnalysis;
  final double? riskScore; // 0-100
  final Map<String, dynamic>? additionalData;

  const ScenarioResult({
    required this.scenarioType,
    required this.currentValue,
    required this.projectedValue,
    required this.valueChange,
    required this.percentChange,
    this.aiAnalysis,
    this.riskScore,
    this.additionalData,
  });

  factory ScenarioResult.fromJson(Map<String, dynamic> json) {
    return ScenarioResult(
      scenarioType: json['scenario_type'] as String,
      currentValue: (json['current_value'] as num).toDouble(),
      projectedValue: (json['projected_value'] as num).toDouble(),
      valueChange: (json['value_change'] as num).toDouble(),
      percentChange: (json['percent_change'] as num).toDouble(),
      aiAnalysis: json['ai_analysis'] as String?,
      riskScore: json['risk_score'] != null
          ? (json['risk_score'] as num).toDouble()
          : null,
      additionalData: json['additional_data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scenario_type': scenarioType,
      'current_value': currentValue,
      'projected_value': projectedValue,
      'value_change': valueChange,
      'percent_change': percentChange,
      'ai_analysis': aiAnalysis,
      'risk_score': riskScore,
      'additional_data': additionalData,
    };
  }
}
