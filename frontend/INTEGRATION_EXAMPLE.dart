/// INTEGRATION EXAMPLE
/// This file shows how to integrate the new AllocationPieChart widget
/// into the existing dashboard. You can apply these changes to dashboard_screen.dart

// STEP 1: Add import at the top of dashboard_screen.dart
import 'package:wealthscope_app/features/dashboard/presentation/widgets/enhanced_allocation_section.dart';

// STEP 2: Replace the old AllocationSection with EnhancedAllocationSection
// 
// OLD CODE (around line 90 in dashboard_screen.dart):
// AllocationSection(
//   allocations: summary.allocations,
// ),
//
// NEW CODE:
EnhancedAllocationSection(
  allocations: summary.allocations,
),

// OR, if you only want the interactive pie chart without the full section:
import 'package:wealthscope_app/features/dashboard/presentation/widgets/allocation_pie_chart.dart';

// Use just the pie chart:
AllocationPieChart(
  allocations: summary.allocations,
),

/* 
 * COMPLETE EXAMPLE - Modified _buildDashboardContent method:
 */

Widget _buildDashboardContent(PortfolioSummary summary) {
  return ListView(
    padding: const EdgeInsets.all(16),
    children: [
      // Summary Card
      PortfolioSummaryCard(summary: summary),
      const SizedBox(height: 16),
      
      // NEW: Interactive Allocation Chart
      EnhancedAllocationSection(
        allocations: summary.allocations,
      ),
      const SizedBox(height: 16),
      
      // Risk Alerts
      RiskAlertsSection(alerts: summary.alerts),
      const SizedBox(height: 16),
      
      // Top Assets
      TopAssetsSection(topAssets: summary.topAssets),
      const SizedBox(height: 16),
      
      // Last Updated
      LastUpdatedIndicator(lastUpdated: summary.lastUpdated),
    ],
  );
}

/*
 * TESTING THE WIDGET
 * 
 * Run the app and navigate to the dashboard:
 * 1. You should see the pie chart rendering with smooth animations
 * 2. Tap on any section - it should expand slightly
 * 3. Release - it should return to normal size
 * 4. Each asset type should have a distinct color
 * 5. Percentages should be visible on each section
 * 
 * If you encounter issues:
 * - Ensure fl_chart is in pubspec.yaml
 * - Run: flutter pub get
 * - Check that allocations list is not empty
 * - Verify asset types match the enum in asset_type.dart
 */

/*
 * ALTERNATIVE: Side-by-Side Comparison
 * 
 * If you want to keep the old chart for comparison:
 */

Widget _buildComparisonView(PortfolioSummary summary) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Original Chart'),
      AllocationSection(allocations: summary.allocations),
      
      SizedBox(height: 24),
      
      Text('New Interactive Chart'),
      EnhancedAllocationSection(allocations: summary.allocations),
    ],
  );
}
