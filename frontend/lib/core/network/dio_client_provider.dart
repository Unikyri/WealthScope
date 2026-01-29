import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/core/network/dio_client.dart';

part 'dio_client_provider.g.dart';

/// Dio Client Provider
/// Provides the configured Dio instance for API calls
@riverpod
Dio dioClient(DioClientRef ref) {
  return DioClient.instance;
}
