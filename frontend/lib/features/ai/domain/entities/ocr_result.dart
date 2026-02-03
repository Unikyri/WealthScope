/// OCR Result Entity
/// Represents the result of document processing via OCR
class OcrResult {
  final String documentType;
  final List<ExtractedAsset> extractedAssets;
  final Map<String, dynamic>? rawData;

  const OcrResult({
    required this.documentType,
    required this.extractedAssets,
    this.rawData,
  });
}

/// Extracted Asset from OCR
/// Represents an asset that was extracted from a document
class ExtractedAsset {
  final String name;
  final String? symbol;
  final double? quantity;
  final double? value;
  final String? assetType;
  final double confidence;

  const ExtractedAsset({
    required this.name,
    this.symbol,
    this.quantity,
    this.value,
    this.assetType,
    this.confidence = 1.0,
  });
}
