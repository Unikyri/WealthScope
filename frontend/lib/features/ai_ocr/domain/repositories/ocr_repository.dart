import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/ocr_entity.dart';

/// Abstract Repository for AI OCR
abstract class OCRRepository {
  /// Process document with OCR to extract assets
  Future<Either<Failure, OCRResultEntity>> processDocument({
    required String filePath,
    String? documentHint,
  });

  /// Confirm and create assets from OCR results
  Future<Either<Failure, OCRConfirmationEntity>> confirmAssets({
    required List<ExtractedAssetEntity> assets,
  });
}
