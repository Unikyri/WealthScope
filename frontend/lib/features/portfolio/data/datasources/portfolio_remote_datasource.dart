import 'package:dio/dio.dart';
import '../models/portfolio_dto.dart';

/// Remote Data Source for Portfolio
class PortfolioRemoteDataSource {
  final Dio _dio;

  PortfolioRemoteDataSource(this._dio);

  /// GET /api/v1/portfolio/summary
  Future<PortfolioSummaryDto> getSummary() async {
    final response = await _dio.get('/portfolio/summary');
    return PortfolioSummaryDto.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  /// GET /api/v1/portfolio/risk
  Future<PortfolioRiskAnalysisDto> getRiskAnalysis() async {
    final response = await _dio.get('/portfolio/risk');
    return PortfolioRiskAnalysisDto.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }
}
