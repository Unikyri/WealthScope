import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/features/ai/domain/entities/ocr_result.dart';

part 'ocr_provider.g.dart';

/// OCR Provider
/// Manages document processing and OCR operations
@riverpod
class Ocr extends _$Ocr {
  @override
  AsyncValue<OcrResult?> build() {
    return const AsyncValue.data(null);
  }

  /// Process a document and extract assets
  Future<OcrResult> processDocument(File document) async {
    state = const AsyncValue.loading();

    try {
      // TODO: Integrate with actual OCR backend API
      // Simulate processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock result for now
      final result = OcrResult(
        documentType: 'bank_statement',
        extractedAssets: [
          const ExtractedAsset(
            name: 'Apple Inc.',
            symbol: 'AAPL',
            quantity: 10,
            value: 1750.50,
            assetType: 'stock',
            confidence: 0.95,
          ),
          const ExtractedAsset(
            name: 'Microsoft Corporation',
            symbol: 'MSFT',
            quantity: 5,
            value: 1850.25,
            assetType: 'stock',
            confidence: 0.92,
          ),
        ],
        rawData: {
          'filename': document.path.split('/').last,
          'processed_at': DateTime.now().toIso8601String(),
        },
      );

      state = AsyncValue.data(result);
      return result;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// Clear the current result
  void clear() {
    state = const AsyncValue.data(null);
  }

  /// Confirm and create assets from extracted data
  Future<void> confirmAssets(List<ExtractedAsset> assets) async {
    try {
      // TODO: Integrate with actual asset creation API
      // For now, simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // This would normally call a repository to create the assets
      // Example: await ref.read(assetRepositoryProvider).createAssets(assets);

      // Clear the OCR state after successful creation
      clear();
    } catch (e) {
      rethrow;
    }
  }
}
