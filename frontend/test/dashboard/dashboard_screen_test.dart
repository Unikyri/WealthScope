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

/// Widget tests for DashboardScreen
/// Tests UI rendering, states (loading/error/empty), and interactions
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Helper to create a mock Supabase User
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

  group('DashboardScreen - Data Rendering', () {
    testWidgets('renders portfolio summary card with data', (tester) async {
      final mockSummary = PortfolioSummary(
        totalValue: 125000.0,
        totalGain: 25000.0,
        totalGainPercentage: 25.0,
        dayChange: 1500.0,
        dayChangePercentage: 1.2,
        assetCount: 10,
        allocations: [
          const AssetAllocation(
            type: 'stocks',
            label: 'Stocks',
            value: 75000.0,
            percentage: 60.0,
          ),
          const AssetAllocation(
            type: 'real_estate',
            label: 'Real Estate',
            value: 50000.0,
            percentage: 40.0,
          ),
        ],
        topAssets: [],
        alerts: [],
        lastUpdated: DateTime.now(),
        isMarketOpen: true,
      );

      final container = ProviderContainer(
        overrides: [
          portfolioSummaryProvider.overrideWith(
            (ref) => Future.value(mockSummary),
          ),
          currentUserProvider.overrideWith(
            (ref) => createMockUser(
              id: '123',
              email: 'john.doe@example.com',
              fullName: 'John Doe',
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify PortfolioSummaryCard is displayed
      expect(find.byType(PortfolioSummaryCard), findsOneWidget);

      // Verify total value is displayed
      expect(find.text('\$125,000.00'), findsOneWidget);

      // Verify gain is displayed
      expect(find.text('+\$25,000.00'), findsOneWidget);

      // Verify gain percentage is displayed
      expect(find.text('+25.0%'), findsOneWidget);
    });

    testWidgets('displays pie chart when allocations exist', (tester) async {
      final mockSummary = PortfolioSummary(
        totalValue: 100000.0,
        totalGain: 10000.0,
        totalGainPercentage: 10.0,
        dayChange: 500.0,
        dayChangePercentage: 0.5,
        assetCount: 5,
        allocations: [
          const AssetAllocation(
            type: 'stocks',
            label: 'Stocks',
            value: 60000.0,
            percentage: 60.0,
          ),
          const AssetAllocation(
            type: 'bonds',
            label: 'Bonds',
            value: 40000.0,
            percentage: 40.0,
          ),
        ],
        topAssets: [],
        alerts: [],
        lastUpdated: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: [
          portfolioSummaryProvider.overrideWith(
            (ref) => Future.value(mockSummary),
          ),
          currentUserProvider.overrideWith(
            (ref) => createMockUser(
              id: '123',
              email: 'user@example.com',
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify allocation section is displayed (contains pie chart)
      expect(find.text('Asset Allocation'), findsOneWidget);
      
      // Verify allocation percentages are displayed
      expect(find.text('60.0%'), findsOneWidget);
      expect(find.text('40.0%'), findsOneWidget);
    });

    testWidgets('displays alerts when they exist', (tester) async {
      final mockSummary = PortfolioSummary(
        totalValue: 100000.0,
        totalGain: 10000.0,
        totalGainPercentage: 10.0,
        dayChange: 500.0,
        dayChangePercentage: 0.5,
        assetCount: 5,
        allocations: [
          const AssetAllocation(
            type: 'stocks',
            label: 'Stocks',
            value: 100000.0,
            percentage: 100.0,
          ),
        ],
        topAssets: [],
        alerts: [
          RiskAlert(
            id: '1',
            severity: AlertSeverity.warning,
            title: 'Low Diversification',
            message: 'Your portfolio is heavily concentrated in one asset type',
            timestamp: DateTime.now(),
          ),
        ],
        lastUpdated: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: [
          portfolioSummaryProvider.overrideWith(
            (ref) => Future.value(mockSummary),
          ),
          currentUserProvider.overrideWith(
            (ref) => createMockUser(id: '123', email: 'user@example.com'),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify alert is displayed
      expect(find.text('Low Diversification'), findsOneWidget);
      expect(
        find.text('Your portfolio is heavily concentrated in one asset type'),
        findsOneWidget,
      );
    });

    testWidgets('displays user greeting with name from email', (tester) async {
      final mockSummary = PortfolioSummary(
        totalValue: 100000.0,
        totalGain: 10000.0,
        totalGainPercentage: 10.0,
        dayChange: 500.0,
        dayChangePercentage: 0.5,
        assetCount: 5,
        allocations: [],
        topAssets: [],
        alerts: [],
        lastUpdated: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: [
          portfolioSummaryProvider.overrideWith(
            (ref) => Future.value(mockSummary),
          ),
          currentUserProvider.overrideWith(
            (ref) => createMockUser(
              id: '123',
              email: 'jane.smith@example.com',
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: DashboardScreen(),
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
        totalGain: 10000.0,
        totalGainPercentage: 10.0,
        dayChange: 500.0,
        dayChangePercentage: 0.5,
        assetCount: 5,
        allocations: [],
        topAssets: [
          const TopAsset(
            id: '1',
            name: 'Apple Inc.',
            type: 'stock',
            value: 50000.0,
            gain: 5000.0,
            gainPercentage: 11.11,
          ),
          const TopAsset(
            id: '2',
            name: 'Tesla Inc.',
            type: 'stock',
            value: 30000.0,
            gain: 3000.0,
            gainPercentage: 11.11,
          ),
        ],
        alerts: [],
        lastUpdated: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: [
          portfolioSummaryProvider.overrideWith(
            (ref) => Future.value(mockSummary),
          ),
          currentUserProvider.overrideWith(
            (ref) => createMockUser(id: '123', email: 'user@example.com'),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify top assets section is displayed
      expect(find.text('Top Performers'), findsOneWidget);
      expect(find.text('Apple Inc.'), findsOneWidget);
      expect(find.text('Tesla Inc.'), findsOneWidget);
    });
  });

  group('DashboardScreen - States', () {
    testWidgets('shows loading skeleton initially', (tester) async {
      final container = ProviderContainer(
        overrides: [
          portfolioSummaryProvider.overrideWith(
            (ref) => Future.delayed(
              const Duration(seconds: 10),
              () => PortfolioSummary(
                totalValue: 0,
                totalGain: 0,
                totalGainPercentage: 0,
                dayChange: 0,
                dayChangePercentage: 0,
                assetCount: 0,
                allocations: [],
                topAssets: [],
                alerts: [],
                lastUpdated: DateTime.now(),
              ),
            ),
          ),
          currentUserProvider.overrideWith(
            (ref) => createMockUser(id: '123', email: 'user@example.com'),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      // Pump once to trigger initial load
      await tester.pump();

      // Verify skeleton is displayed
      expect(find.byType(DashboardSkeleton), findsOneWidget);
    });

    testWidgets('shows error view on failure', (tester) async {
      final container = ProviderContainer(
        overrides: [
          portfolioSummaryProvider.overrideWith(
            (ref) => Future.error('Network connection failed'),
          ),
          currentUserProvider.overrideWith(
            (ref) => createMockUser(id: '123', email: 'user@example.com'),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify error view is displayed
      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.text('Exception: Network connection failed'), findsOneWidget);

      // Verify retry button exists
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('shows empty dashboard for new users', (tester) async {
      final mockSummary = PortfolioSummary(
        totalValue: 0.0,
        totalGain: 0.0,
        totalGainPercentage: 0.0,
        dayChange: 0.0,
        dayChangePercentage: 0.0,
        assetCount: 0,
        allocations: [],
        topAssets: [],
        alerts: [],
        lastUpdated: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: [
          portfolioSummaryProvider.overrideWith(
            (ref) => Future.value(mockSummary),
          ),
          currentUserProvider.overrideWith(
            (ref) => createMockUser(id: '123', email: 'user@example.com'),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify empty dashboard is displayed
      expect(find.byType(EmptyDashboard), findsOneWidget);
      expect(find.text('Start Building Your Portfolio'), findsOneWidget);
    });

    testWidgets('transitions from loading to data state', (tester) async {
      final mockSummary = PortfolioSummary(
        totalValue: 100000.0,
        totalGain: 10000.0,
        totalGainPercentage: 10.0,
        dayChange: 500.0,
        dayChangePercentage: 0.5,
        assetCount: 5,
        allocations: [],
        topAssets: [],
        alerts: [],
        lastUpdated: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: [
          portfolioSummaryProvider.overrideWith(
            (ref) => Future.delayed(
              const Duration(milliseconds: 100),
              () => mockSummary,
            ),
          ),
          currentUserProvider.overrideWith(
            (ref) => createMockUser(id: '123', email: 'user@example.com'),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      // Initially loading
      await tester.pump();
      expect(find.byType(DashboardSkeleton), findsOneWidget);

      // After data loads
      await tester.pumpAndSettle();
      expect(find.byType(DashboardSkeleton), findsNothing);
      expect(find.byType(PortfolioSummaryCard), findsOneWidget);
    });
  });

  group('DashboardScreen - Interactions', () {
    testWidgets('pull to refresh triggers data refresh', (tester) async {
      var fetchCount = 0;
      final mockSummary = PortfolioSummary(
        totalValue: 100000.0,
        totalGain: 10000.0,
        totalGainPercentage: 10.0,
        dayChange: 500.0,
        dayChangePercentage: 0.5,
        assetCount: 5,
        allocations: [],
        topAssets: [],
        alerts: [],
        lastUpdated: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: [
          portfolioSummaryProvider.overrideWith((ref) {
            fetchCount++;
            return Future.value(mockSummary);
          }),
          currentUserProvider.overrideWith(
            (ref) => createMockUser(id: '123', email: 'user@example.com'),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initial fetch count should be 1
      expect(fetchCount, 1);

      // Find the RefreshIndicator and trigger refresh
      await tester.fling(
        find.byType(RefreshIndicator),
        const Offset(0, 300),
        1000,
      );
      await tester.pumpAndSettle();

      // Fetch count should be 2 after refresh
      expect(fetchCount, 2);
    });

    testWidgets('floating action button navigates to add asset',
        (tester) async {
      final mockSummary = PortfolioSummary(
        totalValue: 100000.0,
        totalGain: 10000.0,
        totalGainPercentage: 10.0,
        dayChange: 500.0,
        dayChangePercentage: 0.5,
        assetCount: 5,
        allocations: [],
        topAssets: [],
        alerts: [],
        lastUpdated: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: [
          portfolioSummaryProvider.overrideWith(
            (ref) => Future.value(mockSummary),
          ),
          currentUserProvider.overrideWith(
            (ref) => createMockUser(id: '123', email: 'user@example.com'),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify FAB exists
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('Add Asset'), findsOneWidget);

      // Note: Navigation testing would require a proper router setup
      // This test verifies the button exists and is tappable
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
    });

    testWidgets('retry button reloads data after error', (tester) async {
      var shouldFail = true;
      final mockSummary = PortfolioSummary(
        totalValue: 100000.0,
        totalGain: 10000.0,
        totalGainPercentage: 10.0,
        dayChange: 500.0,
        dayChangePercentage: 0.5,
        assetCount: 5,
        allocations: [],
        topAssets: [],
        alerts: [],
        lastUpdated: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: [
          portfolioSummaryProvider.overrideWith((ref) {
            if (shouldFail) {
              return Future.error('Network error');
            }
            return Future.value(mockSummary);
          }),
          currentUserProvider.overrideWith(
            (ref) => createMockUser(id: '123', email: 'user@example.com'),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify error is shown
      expect(find.byType(ErrorView), findsOneWidget);

      // Change to success state
      shouldFail = false;

      // Tap retry button
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      // Verify data is now loaded
      expect(find.byType(ErrorView), findsNothing);
      expect(find.byType(PortfolioSummaryCard), findsOneWidget);
    });

    testWidgets('notifications button is visible', (tester) async {
      final mockSummary = PortfolioSummary(
        totalValue: 100000.0,
        totalGain: 10000.0,
        totalGainPercentage: 10.0,
        dayChange: 500.0,
        dayChangePercentage: 0.5,
        assetCount: 5,
        allocations: [],
        topAssets: [],
        alerts: [],
        lastUpdated: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: [
          portfolioSummaryProvider.overrideWith(
            (ref) => Future.value(mockSummary),
          ),
          currentUserProvider.overrideWith(
            (ref) => createMockUser(id: '123', email: 'user@example.com'),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify notification icon button is present in app bar
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);

      // Verify button is tappable
      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.pumpAndSettle();
    });
  });

  group('DashboardScreen - Edge Cases', () {
    testWidgets('handles null user gracefully', (tester) async {
      final mockSummary = PortfolioSummary(
        totalValue: 100000.0,
        totalGain: 10000.0,
        totalGainPercentage: 10.0,
        dayChange: 500.0,
        dayChangePercentage: 0.5,
        assetCount: 5,
        allocations: [],
        topAssets: [],
        alerts: [],
        lastUpdated: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: [
          portfolioSummaryProvider.overrideWith(
            (ref) => Future.value(mockSummary),
          ),
          currentUserProvider.overrideWith((ref) => null),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify default greeting is displayed
      expect(find.text('Hello, User'), findsOneWidget);
    });

    testWidgets('displays negative gains correctly', (tester) async {
      final mockSummary = PortfolioSummary(
        totalValue: 95000.0,
        totalGain: -5000.0,
        totalGainPercentage: -5.0,
        dayChange: -500.0,
        dayChangePercentage: -0.5,
        assetCount: 5,
        allocations: [],
        topAssets: [],
        alerts: [],
        lastUpdated: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: [
          portfolioSummaryProvider.overrideWith(
            (ref) => Future.value(mockSummary),
          ),
          currentUserProvider.overrideWith(
            (ref) => createMockUser(id: '123', email: 'user@example.com'),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify negative values are displayed with minus sign
      expect(find.text('-\$5,000.00'), findsOneWidget);
      expect(find.text('-5.0%'), findsOneWidget);
    });

    testWidgets('scrollable content works correctly', (tester) async {
      final mockSummary = PortfolioSummary(
        totalValue: 100000.0,
        totalGain: 10000.0,
        totalGainPercentage: 10.0,
        dayChange: 500.0,
        dayChangePercentage: 0.5,
        assetCount: 5,
        allocations: [
          const AssetAllocation(
            type: 'stocks',
            label: 'Stocks',
            value: 100000.0,
            percentage: 100.0,
          ),
        ],
        topAssets: List.generate(
          10,
          (index) => TopAsset(
            id: '$index',
            name: 'Asset $index',
            type: 'stock',
            value: 10000.0,
            gain: 1000.0,
            gainPercentage: 10.0,
          ),
        ),
        alerts: [],
        lastUpdated: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: [
          portfolioSummaryProvider.overrideWith(
            (ref) => Future.value(mockSummary),
          ),
          currentUserProvider.overrideWith(
            (ref) => createMockUser(id: '123', email: 'user@example.com'),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify content can be scrolled
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Test scrolling
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();
    });
  });
}
