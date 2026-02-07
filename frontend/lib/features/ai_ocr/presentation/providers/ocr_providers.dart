import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_client_provider.dart';
import '../../data/datasources/ocr_remote_datasource.dart';
import '../../data/repositories/ocr_repository_impl.dart';
import '../../domain/entities/ocr_entity.dart';
import '../../domain/repositories/ocr_repository.dart';

part 'ocr_providers.g.dart';

/// Provider for OCRRepository
@riverpod
OCRRepository ocrRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  final dataSource = OCRRemoteDataSource(dio);
  return OCRRepositoryImpl(dataSource);
}

/// Provider to process document with OCR
@riverpod
class ProcessDocument extends _$ProcessDocument {
  @override
  FutureOr<OCRResultEntity?> build() => null;

  Future<void> process({
    required String filePath,
    String? documentHint,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(ocrRepositoryProvider);
    final result = await repository.processDocument(
      filePath: filePath,
      documentHint: documentHint,
    );
    state = result.fold(
      (failure) => AsyncError(Exception(failure.message), StackTrace.current),
      (ocrResult) => AsyncData(ocrResult),
    );
  }

  void clearResult() {
    state = const AsyncData(null);
  }
}

/// Provider to confirm OCR assets
@riverpod
class ConfirmOCRAssets extends _$ConfirmOCRAssets {
  @override
  FutureOr<OCRConfirmationEntity?> build() => null;

  Future<void> confirm({
    required List<ExtractedAssetEntity> assets,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(ocrRepositoryProvider);
    final result = await repository.confirmAssets(assets: assets);
    state = result.fold(
      (failure) => AsyncError(Exception(failure.message), StackTrace.current),
      (confirmation) => AsyncData(confirmation),
    );
  }
}
