import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/ocr_entity.dart';
import '../../domain/repositories/ocr_repository.dart';
import '../datasources/ocr_remote_datasource.dart';
import '../models/ocr_dto.dart';

/// Implementation of OCRRepository
class OCRRepositoryImpl implements OCRRepository {
  final OCRRemoteDataSource _remoteDataSource;

  OCRRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, OCRResultEntity>> processDocument({
    required String filePath,
    String? documentHint,
  }) async {
    try {
      final dto = await _remoteDataSource.processDocument(
        filePath: filePath,
        documentHint: documentHint,
      );
      return Right(dto.toDomain());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OCRConfirmationEntity>> confirmAssets({
    required List<ExtractedAssetEntity> assets,
  }) async {
    try {
      final assetDtos = assets
          .map(
            (asset) => ConfirmAssetDto(
              name: asset.name,
              symbol: asset.symbol,
              type: asset.type,
              quantity: asset.quantity,
              purchasePrice: asset.purchasePrice,
              currency: asset.currency,
            ),
          )
          .toList();

      final dto = await _remoteDataSource.confirmAssets(assets: assetDtos);
      return Right(dto.toDomain());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
