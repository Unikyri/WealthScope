import 'package:flutter_test/flutter_test.dart';
import 'package:wealthscope_app/features/assets/data/models/asset_dto.dart';
import 'package:wealthscope_app/features/assets/data/models/create_asset_request.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';

void main() {
  group('CreateAssetRequest Serialization', () {
    test('Stock asset serializes correctly', () {
      final request = CreateAssetRequest(
        type: 'stock',
        name: 'Apple Inc.',
        quantity: 10.0,
        purchasePrice: 150.0,
        symbol: 'AAPL',
        purchaseDate: '2023-01-01',
        currency: 'USD',
      );

      final json = request.toJson();
      
      expect(json['type'], 'stock');
      expect(json['name'], 'Apple Inc.');
      
      final coreData = json['core_data'] as Map<String, dynamic>;
      expect(coreData['ticker'], 'AAPL');
      expect(coreData['quantity'], 10.0);
      expect(coreData['purchase_price_per_share'], 150.0);
      expect(coreData['trade_date'], '2023-01-01');
      expect(coreData['currency'], 'USD');
    });

    test('Crypto asset serializes correctly', () {
      final request = CreateAssetRequest(
        type: 'crypto',
        name: 'Bitcoin',
        quantity: 0.5,
        purchasePrice: 30000.0,
        symbol: 'BTC',
        purchaseDate: '2023-02-01',
      );

      final json = request.toJson();
      
      final coreData = json['core_data'] as Map<String, dynamic>;
      expect(coreData['symbol'], 'BTC');
      expect(coreData['quantity'], 0.5);
      expect(coreData['purchase_price'], 30000.0);
      expect(coreData['purchase_date'], '2023-02-01');
    });

    test('Bond asset serializes correctly', () {
      final request = CreateAssetRequest(
        type: 'bond',
        name: 'US Treasury',
        quantity: 1000.0, // Face value
        purchasePrice: 98.5, // Percent
        symbol: 'US123456789', // CUSIP
      );

      final json = request.toJson();
      
      final coreData = json['core_data'] as Map<String, dynamic>;
      expect(coreData['cusip'], 'US123456789');
      expect(coreData['face_value'], 1000.0);
      expect(coreData['purchase_price_percent'], 98.5);
    });

    test('Real Estate asset serializes correctly', () {
      final request = CreateAssetRequest(
        type: 'real_estate',
        name: 'My House',
        quantity: 1.0, 
        purchasePrice: 500000.0,
        metadata: {'address': '123 Main St'},
      );

      final json = request.toJson();
      
      final coreData = json['core_data'] as Map<String, dynamic>;
      expect(coreData['purchase_price'], 500000.0);
      expect(coreData['address'], '123 Main St');
    });

    test('Cash asset serializes correctly', () {
      final request = CreateAssetRequest(
        type: 'cash',
        name: 'Chase Checking',
        quantity: 5000.0, // Balance
        purchasePrice: 1.0,
        currency: 'USD',
      );

      final json = request.toJson();
      
      final coreData = json['core_data'] as Map<String, dynamic>;
      expect(coreData['balance'], 5000.0);
      expect(coreData['bank_name'], 'Chase Checking');
      expect(coreData['currency'], 'USD');
    });
    
    test('Custom (Gold mapped) asset serializes correctly', () {
      // Logic from AssetRepositoryImpl injects category into metadata
      final request = CreateAssetRequest(
        type: 'custom',
        name: 'Gold Bar',
        quantity: 1.0,
        purchasePrice: 2000.0,
        symbol: 'GOLD',
        metadata: {'category': 'Gold', 'purity': 0.999},
      );

      final json = request.toJson();
      
      final coreData = json['core_data'] as Map<String, dynamic>;
      expect(coreData['symbol'], 'GOLD');
      expect(coreData['quantity'], 1.0);
      expect(coreData['category'], 'Gold');
      expect(coreData['purity'], 0.999);
    });
  });

  group('AssetDto Deserialization', () {
    test('Stock DTO converts to Domain correctly', () {
      const dto = AssetDto(
        id: '1',
        userId: 'u1',
        type: 'stock',
        name: 'Tesla',
        coreData: {
          'ticker': 'TSLA',
          'quantity': 100.0,
          'purchase_price_per_share': 200.0,
          'trade_date': '2023-01-01T00:00:00.000',
          'currency': 'USD',
        },
        extendedData: {
          'current_price': 250.0,
          'sector': 'Auto',
        },
      );

      final domain = dto.toDomain();
      
      expect(domain.symbol, 'TSLA');
      expect(domain.quantity, 100.0);
      expect(domain.purchasePrice, 200.0);
      expect(domain.currency.code, 'USD');
      expect(domain.currentPrice, 250.0);
      expect(domain.metadata['sector'], 'Auto');
    });

    test('Bond DTO converts to Domain correctly', () {
      const dto = AssetDto(
        id: '2',
        userId: 'u1',
        type: 'bond',
        name: 'US Treas',
        coreData: {
          'cusip': 'US123',
          'face_value': 1000.0,
          'purchase_price_percent': 99.0,
        },
      );

      final domain = dto.toDomain();
      
      expect(domain.symbol, 'US123');
      expect(domain.quantity, 1000.0);
      expect(domain.purchasePrice, 99.0);
    });

    test('Cash DTO converts to Domain correctly', () {
      const dto = AssetDto(
        id: '3',
        userId: 'u1',
        type: 'cash',
        name: 'Chase',
        coreData: {
          'balance': 500.0,
          'currency': 'EUR',
          'bank_name': 'Chase',
        },
      );

      final domain = dto.toDomain();
      
      expect(domain.symbol, 'EUR'); // Cash uses currency as symbol? Logic check: case AssetType.cash: symbol = getString('currency');
      expect(domain.quantity, 500.0);
      expect(domain.currency.code, 'EUR');
    });
    
    test('Custom DTO converts to Domain correctly', () {
      const dto = AssetDto(
        id: '4',
        userId: 'u1',
        type: 'custom',
        name: 'Rare Coin',
        coreData: {
          'symbol': 'COIN',
          'quantity': 1.0,
          'purchase_price': 1000.0,
          'category': 'Collectible'
        },
      );

      final domain = dto.toDomain();
      
      expect(domain.type, AssetType.custom);
      expect(domain.symbol, 'COIN');
      expect(domain.metadata['category'], 'Collectible');
    });
  });
}
