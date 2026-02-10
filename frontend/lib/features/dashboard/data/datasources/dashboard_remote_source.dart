import 'package:dio/dio.dart';
import 'package:wealthscope_app/core/network/api_response.dart';
import 'package:wealthscope_app/features/dashboard/data/models/portfolio_summary_dto.dart';
import 'package:wealthscope_app/features/dashboard/data/models/portfolio_risk_dto.dart';

/// Dashboard Remote Data Source
/// Handles API calls for dashboard data
class DashboardRemoteDataSource {
  final Dio _dio;

  DashboardRemoteDataSource(this._dio);

  /// Fetch portfolio summary from API
  /// GET /api/v1/portfolio/summary
  Future<PortfolioSummaryDto> getPortfolioSummary() async {
    try {
      final response = await _dio.get('/portfolio/summary');
      
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      return PortfolioSummaryDto.fromJson(apiResponse.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Fetch portfolio risk alerts
  /// GET /api/v1/portfolio/risk
  Future<PortfolioRiskDto> getPortfolioRisk() async {
    try {
      final response = await _dio.get('/portfolio/risk');
      
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      return PortfolioRiskDto.fromJson(apiResponse.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please check your internet.');
      case DioExceptionType.badResponse:
        return Exception(
          e.response?.data['message'] ?? 'Server error occurred',
        );
      default:
        return Exception('Network error. Please try again.');
    }
  }
}
