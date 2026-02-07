import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/core/network/dio_client.dart';
import 'package:wealthscope_app/features/assets/data/datasources/asset_remote_data_source.dart';
import 'package:wealthscope_app/features/assets/data/repositories/asset_repository_impl.dart';
import 'package:wealthscope_app/features/assets/domain/repositories/asset_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'asset_repository_provider.g.dart';

/// Provider for Asset Remote Data Source
@riverpod
AssetRemoteDataSource assetRemoteDataSource(Ref ref) {
  return AssetRemoteDataSource(DioClient.instance);
}

/// Provider for Asset Repository
@riverpod
AssetRepository assetRepository(Ref ref) {
  final remoteDataSource = ref.watch(assetRemoteDataSourceProvider);
  return AssetRepositoryImpl(remoteDataSource);
}
