/// Domain Entity for Extracted Asset from OCR
class ExtractedAssetEntity {
  final String name;
  final String? symbol;
  final String type;
  final double quantity;
  final double purchasePrice;
  final String currency;
  final double? totalValue;
  final double confidence; // 0.0 to 1.0

  const ExtractedAssetEntity({
    required this.name,
    this.symbol,
    required this.type,
    required this.quantity,
    required this.purchasePrice,
    required this.currency,
    this.totalValue,
    required this.confidence,
  });
}

/// Domain Entity for OCR Result
class OCRResultEntity {
  final String documentType;
  final List<ExtractedAssetEntity> assets;
  final List<String> warnings;

  const OCRResultEntity({
    required this.documentType,
    required this.assets,
    required this.warnings,
  });
}

/// Domain Entity for OCR Confirmation Result
class OCRConfirmationEntity {
  final List<String> assetIds;
  final int createdCount;

  const OCRConfirmationEntity({
    required this.assetIds,
    required this.createdCount,
  });
}
