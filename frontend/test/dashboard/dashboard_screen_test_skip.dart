import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';
import 'package:wealthscope_app/features/dashboard/presentation/providers/dashboard_providers.dart';

import 'package:wealthscope_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/dashboard_skeleton.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/empty_dashboard.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/error_view.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/portfolio_summary_card.dart';
import 'package:wealthscope_app/shared/providers/auth_state_provider.dart';
import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/assets/data/providers/asset_repository_provider.dart';
import 'package:wealthscope_app/features/assets/domain/entities/currency.dart';
import 'package:wealthscope_app/features/assets/domain/repositories/asset_repository.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_risk.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/personalized_news_item.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/revenuecat_service.dart';
import 'package:wealthscope_app/features/subscriptions/domain/services/feature_gate_service.dart';

import 'package:wealthscope_app/features/subscriptions/data/services/usage_tracker.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mock AssetRepository for testing
class MockAssetRepository implements AssetRepository {
  final List<StockAsset> assets;
  MockAssetRepository(this.assets);
  
  @override
  Future<List<StockAsset>> getAssets() async => assets;
  
  @override
  Future<StockAsset> addAsset(StockAsset asset) async => asset;
  
  @override
  Future<void> deleteAsset(String id) async {}
  
  @override
  Future<StockAsset?> getAssetById(String id) async => assets.firstWhere((a) => a.id == id, orElse: () => throw Exception('Not found'));
  
  @override
  Future<List<StockAsset>> getAssetsByType(String type) async => assets.where((a) => a.type.name == type).toList();
  
  @override
  Future<List<StockAsset>> searchAssets(String query) async => [];
  
  @override
  Future<StockAsset> updateAsset(StockAsset asset) async => asset;
}

/// Helper to create a mock Supabase User
supabase.User createMockUser({
  required String id,
  required String email,
  String? fullName,
}) {
  return supabase.User(
    id: id,
    appMetadata: {},
    userMetadata: {'full_name': fullName},
    aud: 'authenticated',
    createdAt: DateTime.now().toIso8601String(),
    email: email,
  );
}

createTestOverrides({
  required Future<PortfolioSummary> summaryFuture,
  List<StockAsset> assets = const [],
  String userId = '123',
  String email = 'test@example.com',
  String? fullName,
}) {
  return [
    dashboardPortfolioSummaryProvider.overrideWith((ref) => summaryFuture),
    assetRepositoryProvider.overrideWith((ref) => MockAssetRepository(assets)),
    currentUserProvider.overrideWith((ref) => createMockUser(
      id: userId,
      email: email,
      fullName: fullName,
    )),
    dashboardPortfolioRiskProvider.overrideWith((ref) => Future.value(const PortfolioRisk(
      riskScore: 50,
      diversificationLevel: 'Balanced',
      alerts: [],
    ))),
    dashboardPersonalizedNewsProvider.overrideWith((ref) => Future.value([])),
    featureGateProvider.overrideWith((ref) => FeatureGateService(
      isPremium: true, 
      usage: const UsageState(aiQueriesUsedToday: 0, ocrScansUsedThisMonth: 0),
    )),
  ];
}

/// Widget tests for DashboardScreen
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});


  setUp(() {
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
    FlutterError.onError = FlutterError.presentError;
  });

  group('DashboardScreen - Data Rendering', () {
    testWidgets('renders portfolio summary card with data', (tester) async {
      final mockSummary = PortfolioSummary(
        totalValue: 125000.0,
        totalInvested: 100000.0,
        gainLoss: 25000.0,
        gainLossPercent: 25.0,
        assetCount: 10,
        breakdownByType: [
          const AssetTypeBreakdown(
            type: 'stocks',
            value: 75000.0,
            percent: 60.0,
            count: 6,
          ),
          const AssetTypeBreakdown(
            type: 'real_estate',
            value: 50000.0,
            percent: 40.0,
            count: 4,
          ),
        ],
        lastUpdated: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: createTestOverrides(
          summaryFuture: Future.value(mockSummary),
          email: 'john.doe@example.com',
          fullName: 'John Doe',
        ),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(800, 600),
                disableAnimations: true,
              ),
              child: const DashboardScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify PortfolioSummaryCard is displayed
      expect(find.byType(PortfolioSummaryCard), findsOneWidget);
      expect(find.text('\$125,000.00'), findsOneWidget);
      expect(find.text('+\$25,000.00'), findsOneWidget);
      expect(find.text('+25.0%'), findsOneWidget);
    });

    testWidgets('displays pie chart when allocations exist', (tester) async {
      final mockSummary = PortfolioSummary(
        totalValue: 100000.0,
        totalInvested: 90000.0,
        gainLoss: 10000.0,
        gainLossPercent: 10.0,
        assetCount: 5,
        breakdownByType: [
          const AssetTypeBreakdown(
            type: 'stocks',
            value: 60000.0,
            percent: 60.0,
            count: 3,
          ),
          const AssetTypeBreakdown(
            type: 'bonds',
            value: 40000.0,
            percent: 40.0,
            count: 2,
          ),
        ],
        lastUpdated: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: createTestOverrides(
          summaryFuture: Future.value(mockSummary),
          email: 'user@example.com',
        ),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(800, 600),
                disableAnimations: true,
              ),
              child: const DashboardScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify allocation section is displayed (contains pie chart)
      expect(find.text('Asset Allocation'), findsOneWidget);
      expect(find.text('60.0%'), findsOneWidget);
      expect(find.text('40.0%'), findsOneWidget);
    });

    testWidgets('displays user greeting with name from email', (tester) async {
      final mockSummary = PortfolioSummary(
        totalValue: 100000.0,
        totalInvested: 90000.0,
        gainLoss: 10000.0,
        gainLossPercent: 10.0,
        assetCount: 5,
        breakdownByType: [],
        lastUpdated: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: createTestOverrides(
          summaryFuture: Future.value(mockSummary),
          email: 'jane.smith@example.com',
        ),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(800, 600),
                disableAnimations: true,
              ),
              child: const DashboardScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify user greeting is displayed
      expect(find.text('Hello, Jane'), findsOneWidget);
      expect(find.text('Your Financial Summary'), findsOneWidget);
    });

    testWidgets('displays top assets when they exist', (tester) async {
      final mockSummary = PortfolioSummary(
        totalValue: 100000.0,
        totalInvested: 90000.0,
        gainLoss: 10000.0,
        gainLossPercent: 10.0,
        assetCount: 2,
        breakdownByType: [],
        lastUpdated: DateTime.now(),
      );

      final mockAssets = [
        StockAsset(
            id: '1',
            type: AssetType.stock,
            symbol: 'AAPL',
            name: 'Apple Inc.',
            quantity: 10,
            purchasePrice: 150,
            currency: Currency.usd,
            totalValue: 50000.0,
            gainLoss: 5000.0),
        StockAsset(
            id: '2',
            type: AssetType.stock,
            symbol: 'TSLA',
            name: 'Tesla Inc.',
            quantity: 5,
            purchasePrice: 200,
            currency: Currency.usd,
            totalValue: 30000.0,
            gainLoss: 3000.0),
      ];

      final container = ProviderContainer(
        overrides: createTestOverrides(
          summaryFuture: Future.value(mockSummary),
          assets: mockAssets,
          email: 'user@example.com',
        ),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(800, 600),
                disableAnimations: true,
              ),
              child: const DashboardScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify top assets section is displayed
      expect(find.text('Top Assets'), findsOneWidget);
      expect(find.text('Apple Inc.'), findsOneWidget);
      expect(find.text('Tesla Inc.'), findsOneWidget);
    });
  });

  group('DashboardScreen - States', () {
    testWidgets('shows loading skeleton initially', (tester) async {
      final container = ProviderContainer(
        overrides: createTestOverrides(
          summaryFuture: Future.delayed(
            const Duration(seconds: 10),
            () => PortfolioSummary(
              totalValue: 0,
              totalInvested: 0,
              gainLoss: 0,
              gainLossPercent: 0,
              assetCount: 0,
              breakdownByType: [],
              lastUpdated: DateTime(2024),
            ),
          ),
          email: 'user@example.com',
        ),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(800, 600),
                disableAnimations: true,
              ),
              child: const DashboardScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(DashboardSkeleton), findsOneWidget);
    });

    testWidgets('shows error view on failure', (tester) async {
      final container = ProviderContainer(
        overrides: createTestOverrides(
          summaryFuture: Future.error('Network connection failed'),
          email: 'user@example.com',
        ),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(800, 600),
                disableAnimations: true,
              ),
              child: const DashboardScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.text('Exception: Network connection failed'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('shows empty dashboard for new users', (tester) async {
      final mockSummary = PortfolioSummary(
        totalValue: 0.0,
        totalInvested: 0.0,
        gainLoss: 0.0,
        gainLossPercent: 0.0,
        assetCount: 0,
        breakdownByType: [],
        lastUpdated: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: createTestOverrides(
          summaryFuture: Future.value(mockSummary),
          email: 'user@example.com',
        ),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(800, 600),
                disableAnimations: true,
              ),
              child: const DashboardScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(EmptyDashboard), findsOneWidget);
      expect(find.text('Start Building Your Portfolio'), findsOneWidget);
    });
  });

  group('DashboardScreen - Interactions', () {
    testWidgets('pull to refresh triggers data refresh', (tester) async {
      var fetchCount = 0;
      final mockSummary = PortfolioSummary(
        totalValue: 100000.0,
        totalInvested: 90000.0,
        gainLoss: 10000.0,
        gainLossPercent: 10.0,
        assetCount: 5,
        breakdownByType: [],
        lastUpdated: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: [
          ...createTestOverrides(
            summaryFuture: Future.value(mockSummary),
            email: 'user@example.com',
          ),
          dashboardPortfolioSummaryProvider.overrideWith((ref) {
            fetchCount++;
            return Future.value(mockSummary);
          }),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(800, 600),
                disableAnimations: true,
              ),
              child: const DashboardScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(fetchCount, 1);

      await tester.fling(
        find.byType(RefreshIndicator),
        const Offset(0, 300),
        1000,
      );
      await tester.pumpAndSettle();

      expect(fetchCount, greaterThanOrEqualTo(2));
    });

void testWidgetsNoSemantics(
  String description,
  WidgetTesterCallback callback, {
  bool? skip,
  Timeout? timeout,
  TestVariant<Object?> variant = const DefaultTestVariant(),
  dynamic tags,
}) {
  testWidgets(
    description,
    callback,
    skip: skip,
    timeout: timeout,
    semanticsEnabled: false,
    variant: variant,
    tags: tags,
  );
}

    testWidgetsNoSemantics('notifications button is visible', (tester) async {
      final mockSummary = PortfolioSummary(
        totalValue: 100000.0,
        totalInvested: 90000.0,
        gainLoss: 10000.0,
        gainLossPercent: 10.0,
        assetCount: 5,
        breakdownByType: [],
        lastUpdated: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: createTestOverrides(
          summaryFuture: Future.value(mockSummary),
          email: 'user@example.com',
        ),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(800, 600),
                disableAnimations: true,
              ),
              child: const DashboardScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });
  });
}
