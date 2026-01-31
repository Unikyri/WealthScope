import 'package:wealthscope_app/core/errors/failures.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';
import 'package:fpdart/fpdart.dart';

/// Dashboard Repository Interface
/// Defines contract for fetching dashboard data
abstract class DashboardRepository {
  /// Fetch portfolio summary for the current user
  Future<Either<Failure, PortfolioSummary>> getPortfolioSummary();
}
