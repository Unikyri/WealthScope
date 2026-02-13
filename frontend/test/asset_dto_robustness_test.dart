import 'package:flutter_test/flutter_test.dart';
import 'package:wealthscope_app/features/assets/data/models/asset_dto.dart';
import 'package:wealthscope_app/features/assets/data/models/create_asset_request.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';

void main() {
  group('AssetDto Robustness', () {
    test('should handle null core_data and extended_data without crashing', () {
      final json = {
        'id': '123',
        'user_id': 'user1',
        'type': 'stock',
        'name': 'Apple',
        'core_data': null,
        'extended_data': null,
        'created_at': '2023-01-01T00:00:00Z',
        'updated_at': '2023-01-01T00:00:00Z',
      };

      final dto = AssetDto.fromJson(json);
      expect(dto.coreData, isNull);
      expect(dto.extendedData, isEmpty);

      // Verify toDomain doesn't crash
      final asset = dto.toDomain();
      expect(asset.name, 'Apple');
      expect(asset.symbol, ''); // Fallback
    });

    test('should find symbol in fallback fields', () {
      final json = {
        'id': '123',
        'user_id': 'user1',
        'type': 'stock',
        'name': 'Apple',
        'core_data': {'ticker': 'AAPL'},
        'created_at': '2023-01-01T00:00:00Z',
        'updated_at': '2023-01-01T00:00:00Z',
      };

      final dto = AssetDto.fromJson(json);
      expect(dto.symbol, 'AAPL');
      
      final asset = dto.toDomain();
      expect(asset.symbol, 'AAPL');
    });

    test('should handle completely empty core_data', () {
       final json = {
        'id': '123',
        'user_id': 'user1',
        'type': 'real_estate', // Type that might not have a symbol
        'name': 'My House',
        'core_data': <String, dynamic>{},
        'created_at': '2023-01-01T00:00:00Z',
        'updated_at': '2023-01-01T00:00:00Z',
      };

      final dto = AssetDto.fromJson(json);
      final asset = dto.toDomain();
      expect(asset.name, 'My House');
      expect(asset.quantity, 1.0); // Default for Real Estate is 1.0
    });
  });

  group('CreateAssetRequest', () {
    test('should include quantity: 1.0 for Real Estate', () {
      const request = CreateAssetRequest(
        type: 'real_estate',
        name: 'My House',
        quantity: 0.0, // Required by constructor, overridden in toJson
        purchasePrice: 500000,
      );

      final json = request.toJson();
      final coreData = json['core_data'] as Map<String, dynamic>;
      
      expect(coreData['quantity'], 1.0);
      expect(coreData['purchase_price'], 500000);
    });
  });
}
