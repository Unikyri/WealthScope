import 'package:dio/dio.dart';
import 'package:wealthscope_app/features/dashboard/data/models/portfolio_summary_dto.dart';

/// Dashboard Remote Data Source
/// Handles API calls for dashboard data
class DashboardRemoteDataSource {
  final Dio _dio;

  DashboardRemoteDataSource(this._dio);

  /// Fetch portfolio summary from API
  Future<PortfolioSummaryDto> getPortfolioSummary() async {
    try {
      final response = await _dio.get('/portfolio/summary');
      return PortfolioSummaryDto.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Refresh portfolio data
  Future<void> refreshPortfolio() async {
    try {
      await _dio.post('/portfolio/refresh');
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
