import 'package:dio/dio.dart';
import 'package:wealthscope_app/core/errors/failures.dart';
import 'package:wealthscope_app/core/network/api_error.dart';

/// Error Interceptor for Dio
/// Converts API errors to application Failure objects
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = _handleError(err);
    
    // Attach the failure to the error for easy access
    err = err.copyWith(error: failure);
    
    handler.next(err);
  }

  Failure _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Connection timeout. Please check your internet connection.');

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.cancel:
        return const UnexpectedFailure('Request was cancelled');

      case DioExceptionType.connectionError:
        return const NetworkFailure('No internet connection');

      default:
        return UnexpectedFailure('Unexpected error: ${error.message}');
    }
  }

  Failure _handleResponseError(Response? response) {
    if (response == null) {
      return const ServerFailure('No response from server');
    }

    // Try to parse standard API error response
    try {
      final errorResponse = ApiErrorResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
      
      final apiError = errorResponse.error;
      
      // Map error codes to specific failures
      switch (apiError.code) {
        case ApiErrorCode.validationError:
          return ValidationFailure(apiError.message);
        
        case ApiErrorCode.authenticationRequired:
          return AuthFailure(apiError.message);
        
        case ApiErrorCode.permissionDenied:
          return AuthFailure(apiError.message);
        
        case ApiErrorCode.notFound:
          return NotFoundFailure(apiError.message);
        
        case ApiErrorCode.rateLimitExceeded:
          return ServerFailure('Rate limit exceeded. Please try again later.');
        
        case ApiErrorCode.internalServerError:
          return ServerFailure(apiError.message);
        
        case ApiErrorCode.serviceUnavailable:
          return const ServerFailure('Service temporarily unavailable');
        
        default:
          return ServerFailure(apiError.message);
      }
    } catch (e) {
      // Fallback to status code based error handling
      return _handleStatusCode(response.statusCode);
    }
  }

  Failure _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return const ValidationFailure('Invalid request data');
      case 401:
        return const AuthFailure('Authentication required');
      case 403:
        return const AuthFailure('Permission denied');
      case 404:
        return const NotFoundFailure('Resource not found');
      case 422:
        return const ValidationFailure('Business logic error');
      case 429:
        return const ServerFailure('Too many requests');
      case 500:
        return const ServerFailure('Internal server error');
      case 503:
        return const ServerFailure('Service unavailable');
      default:
        return ServerFailure('Server error: $statusCode');
    }
  }
}
