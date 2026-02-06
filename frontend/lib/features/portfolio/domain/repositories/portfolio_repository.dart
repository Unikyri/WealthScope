import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../dashboard/domain/entities/portfolio_summary.dart';

/// Abstract Repository for Portfolio
abstract class PortfolioRepository {
  /// Get portfolio summary
  Future<Either<Failure, PortfolioSummary>> getSummary();

  /// Get portfolio risk alerts
  Future<Either<Failure, PortfolioRiskAnalysis>> getRiskAnalysis();
}

/// Portfolio Risk Analysis Entity
class PortfolioRiskAnalysis {
  final int riskScore; // 0-100
  final String diversificationLevel; // 'low', 'moderate', 'high'
  final List<RiskAlert> alerts;

  const PortfolioRiskAnalysis({
    required this.riskScore,
    required this.diversificationLevel,
    required this.alerts,
  });
}
