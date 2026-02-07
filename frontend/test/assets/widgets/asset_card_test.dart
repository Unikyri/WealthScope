import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/assets/domain/entities/currency.dart';
import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/asset_card.dart';

/// Widget tests for AssetCard component
/// 
/// Tests:
/// - Basic rendering (name, icon, quantity, value)
/// - Different asset types (stock, ETF, real estate, gold, crypto, bond, other)
/// - States (with/without current price, positive/negative changes)
/// - Color coding (green for positive, red for negative)
void main() {
  // Suppress overflow errors in tests
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Suppress rendering overflow errors during tests
    FlutterError.onError = (FlutterErrorDetails details) {
      final exception = details.exception;
      final isOverflowError = exception is FlutterError &&
          exception.message.contains('overflowed by');

      if (!isOverflowError) {
        FlutterError.presentError(details);
      }
    };
  });

  tearDown(() {
    // Restore error handling
    FlutterError.onError = FlutterError.presentError;
  });

  group('AssetCard - Basic Rendering', () {
    testWidgets('renders asset name and total value', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.stock,
        name: 'Apple Inc.',
        symbol: 'AAPL',
        quantity: 10,
        purchasePrice: 150.0,
        currency: Currency.usd,
        currentPrice: 175.0,
        totalValue: 1750.0, // 10 * 175
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Verify asset name with symbol is displayed
      expect(find.text('Apple Inc. (AAPL)'), findsOneWidget);
      
      // Verify formatted value is displayed (1.8K - rounding)
      expect(find.text('\$1.8K'), findsOneWidget);
    });

    testWidgets('displays quantity with correct unit label', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.stock,
        name: 'Tesla',
        symbol: 'TSLA',
        quantity: 5,
        purchasePrice: 200.0,
        currency: Currency.usd,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Verify quantity with shares unit
      expect(find.text('5 shares'), findsOneWidget);
    });

    testWidgets('displays single share with singular unit', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.stock,
        name: 'Berkshire Hathaway',
        symbol: 'BRK.A',
        quantity: 1,
        purchasePrice: 500000.0,
        currency: Currency.usd,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Verify singular 'share' unit
      expect(find.text('1 share'), findsOneWidget);
    });

    testWidgets('displays current price when available', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.stock,
        name: 'Microsoft',
        symbol: 'MSFT',
        quantity: 10,
        purchasePrice: 300.0,
        currency: Currency.usd,
        currentPrice: 350.0,
        totalValue: 3500.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Verify current price is displayed
      expect(find.text('\$350.00'), findsOneWidget);
    });
  });

  group('AssetCard - Asset Types', () {
    testWidgets('shows correct icon for stock type', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.stock,
        name: 'Test Stock',
        symbol: 'TEST',
        quantity: 1,
        purchasePrice: 100.0,
        currency: Currency.usd,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Verify stock icon (show_chart)
      expect(find.byIcon(Icons.show_chart), findsOneWidget);
    });

    testWidgets('shows correct icon for ETF type', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.etf,
        name: 'Vanguard S&P 500',
        symbol: 'VOO',
        quantity: 10,
        purchasePrice: 400.0,
        currency: Currency.usd,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Verify ETF icon (pie_chart)
      expect(find.byIcon(Icons.pie_chart), findsOneWidget);
      
      // Verify ETF unit label
      expect(find.text('10 shares'), findsOneWidget);
    });

    testWidgets('shows correct icon for real estate type', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.realEstate,
        name: '123 Main St',
        symbol: '',
        quantity: 1,
        purchasePrice: 500000.0,
        currency: Currency.usd,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Verify real estate icon (home)
      expect(find.byIcon(Icons.home), findsOneWidget);
      
      // Verify real estate unit label
      expect(find.text('1 properties'), findsOneWidget);
      
      // Real estate should not show symbol in name
      expect(find.text('123 Main St'), findsOneWidget);
      expect(find.textContaining('()'), findsNothing);
    });

    testWidgets('shows correct icon and unit for gold type', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.gold,
        name: 'Gold Bullion',
        symbol: '',
        quantity: 10.5,
        purchasePrice: 1800.0,
        currency: Currency.usd,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Verify gold icon (diamond)
      expect(find.byIcon(Icons.diamond), findsOneWidget);
      
      // Verify gold unit label with 3 decimal places
      expect(find.text('10.500 oz'), findsOneWidget);
    });

    testWidgets('shows correct icon for crypto type', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.crypto,
        name: 'Bitcoin',
        symbol: 'BTC',
        quantity: 0.5,
        purchasePrice: 45000.0,
        currency: Currency.usd,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Verify crypto icon (currency_bitcoin)
      expect(find.byIcon(Icons.currency_bitcoin), findsOneWidget);
      
      // Verify crypto unit label with 8 decimal places
      expect(find.text('0.50000000 units'), findsOneWidget);
    });

    testWidgets('shows correct icon for bond type', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.bond,
        name: 'US Treasury Bond',
        symbol: 'USB',
        quantity: 5,
        purchasePrice: 1000.0,
        currency: Currency.usd,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Verify bond icon (receipt_long)
      expect(find.byIcon(Icons.receipt_long), findsOneWidget);
      
      // Verify bond unit label
      expect(find.text('5 bonds'), findsOneWidget);
    });

    testWidgets('shows correct icon for other type', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.other,
        name: 'Custom Asset',
        symbol: 'CUSTOM',
        quantity: 100,
        purchasePrice: 10.0,
        currency: Currency.usd,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Verify other icon (business)
      expect(find.byIcon(Icons.business), findsOneWidget);
      
      // Verify other unit label
      expect(find.text('100 units'), findsOneWidget);
    });
  });

  group('AssetCard - Gain/Loss Display', () {
    testWidgets('shows positive gain with green color and up arrow', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.stock,
        name: 'Profitable Stock',
        symbol: 'WIN',
        quantity: 10,
        purchasePrice: 100.0,
        currency: Currency.usd,
        currentPrice: 120.0,
        totalValue: 1200.0, // +20% gain
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Verify positive percentage is displayed
      expect(find.text('+20.0%'), findsOneWidget);
      
      // Verify up arrow icon is present
      expect(find.byIcon(Icons.arrow_drop_up), findsOneWidget);
      
      // Verify green color (tertiary color from theme)
      final percentText = find.text('+20.0%');
      final textWidget = tester.widget<Text>(percentText);
      final theme = Theme.of(tester.element(percentText));
      expect(textWidget.style?.color, theme.colorScheme.tertiary);
    });

    testWidgets('shows negative loss with red color and down arrow', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.stock,
        name: 'Loss Stock',
        symbol: 'LOSS',
        quantity: 10,
        purchasePrice: 150.0,
        currency: Currency.usd,
        currentPrice: 120.0,
        totalValue: 1200.0, // -20% loss
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Verify negative percentage is displayed
      expect(find.text('-20.0%'), findsOneWidget);
      
      // Verify down arrow icon is present
      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
      
      // Verify red color (error color from theme)
      final percentText = find.text('-20.0%');
      final textWidget = tester.widget<Text>(percentText);
      final theme = Theme.of(tester.element(percentText));
      expect(textWidget.style?.color, theme.colorScheme.error);
    });

    testWidgets('shows zero change with green color and up arrow', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.stock,
        name: 'Flat Stock',
        symbol: 'FLAT',
        quantity: 10,
        purchasePrice: 100.0,
        currency: Currency.usd,
        currentPrice: 100.0,
        totalValue: 1000.0, // 0% change
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Verify zero percentage is displayed with + sign (>= 0)
      expect(find.text('+0.0%'), findsOneWidget);
      
      // Verify up arrow (positive or zero treated as positive)
      expect(find.byIcon(Icons.arrow_drop_up), findsOneWidget);
    });

    testWidgets('does not show change when current price is null', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.stock,
        name: 'No Price Stock',
        symbol: 'NOPRICE',
        quantity: 10,
        purchasePrice: 100.0,
        currency: Currency.usd,
        currentPrice: null,
        totalValue: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Verify no percentage is displayed
      expect(find.textContaining('%'), findsNothing);
      
      // Verify no arrow icons
      expect(find.byIcon(Icons.arrow_drop_up), findsNothing);
      expect(find.byIcon(Icons.arrow_drop_down), findsNothing);
    });
  });

  group('AssetCard - Value Formatting', () {
    testWidgets('formats large values with K notation', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.stock,
        name: 'Large Value',
        symbol: 'LARGE',
        quantity: 100,
        purchasePrice: 50.0,
        currency: Currency.usd,
        currentPrice: 55.0,
        totalValue: 5500.0, // Should show as 5.5K
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Verify K notation
      expect(find.text('\$5.5K'), findsOneWidget);
    });

    testWidgets('formats very large values with M notation', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.stock,
        name: 'Million Value',
        symbol: 'MIL',
        quantity: 10000,
        purchasePrice: 100.0,
        currency: Currency.usd,
        currentPrice: 150.0,
        totalValue: 1500000.0, // Should show as 1.5M
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Verify M notation
      expect(find.text('\$1.5M'), findsOneWidget);
    });

    testWidgets('formats small values without notation', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.stock,
        name: 'Small Value',
        symbol: 'SMALL',
        quantity: 5,
        purchasePrice: 50.0,
        currency: Currency.usd,
        currentPrice: 60.0,
        totalValue: 300.0, // Should show as 300
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Verify plain number
      expect(find.text('\$300'), findsOneWidget);
    });
  });

  group('AssetCard - Currency Support', () {
    testWidgets('displays EUR currency symbol', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.stock,
        name: 'European Stock',
        symbol: 'EU',
        quantity: 10,
        purchasePrice: 100.0,
        currency: Currency.eur,
        currentPrice: 120.0,
        totalValue: 1200.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Verify EUR symbol
      expect(find.text('€120.00'), findsOneWidget);
      expect(find.textContaining('€1.2K'), findsOneWidget);
    });

    testWidgets('displays GBP currency symbol', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.stock,
        name: 'UK Stock',
        symbol: 'UK',
        quantity: 10,
        purchasePrice: 100.0,
        currency: Currency.gbp,
        currentPrice: 150.0,
        totalValue: 1500.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Verify GBP symbol
      expect(find.text('£150.00'), findsOneWidget);
      expect(find.textContaining('£1.5K'), findsOneWidget);
    });
  });

  group('AssetCard - Hero Animation', () {
    testWidgets('contains hero widget with correct tag', (tester) async {
      final asset = StockAsset(
        id: 'test-asset-123',
        userId: 'user-1',
        type: AssetType.stock,
        name: 'Test Asset',
        symbol: 'TEST',
        quantity: 1,
        purchasePrice: 100.0,
        currency: Currency.usd,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Verify Hero widget exists with correct tag
      final heroFinder = find.byType(Hero);
      expect(heroFinder, findsOneWidget);
      
      final hero = tester.widget<Hero>(heroFinder);
      expect(hero.tag, 'asset-icon-test-asset-123');
    });
  });

  group('AssetCard - Interactive Behavior', () {
    testWidgets('card is tappable', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.stock,
        name: 'Tappable Asset',
        symbol: 'TAP',
        quantity: 1,
        purchasePrice: 100.0,
        currency: Currency.usd,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Verify InkWell exists (makes card tappable)
      expect(find.byType(InkWell), findsOneWidget);
    });
  });

  group('AssetCard - Edge Cases', () {
    testWidgets('handles asset without symbol for real estate', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.realEstate,
        name: 'Investment Property',
        symbol: '',
        quantity: 1,
        purchasePrice: 500000.0,
        currency: Currency.usd,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Should display name without symbol parentheses
      expect(find.text('Investment Property'), findsOneWidget);
      expect(find.textContaining('()'), findsNothing);
    });

    testWidgets('handles fractional shares correctly', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.stock,
        name: 'Fractional',
        symbol: 'FRAC',
        quantity: 2.5,
        purchasePrice: 100.0,
        currency: Currency.usd,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Should display with 2 decimal places
      expect(find.text('2.50 shares'), findsOneWidget);
    });

    testWidgets('shows total invested when current value is null', (tester) async {
      final asset = StockAsset(
        id: 'test-id',
        userId: 'user-1',
        type: AssetType.stock,
        name: 'No Current Value',
        symbol: 'NOCV',
        quantity: 10,
        purchasePrice: 100.0,
        currency: Currency.usd,
        currentPrice: null,
        totalValue: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AssetCard(asset: asset),
          ),
        ),
      );

      // Should display total invested (1000)
      expect(find.text('\$1.0K'), findsOneWidget);
    });
  });
}
