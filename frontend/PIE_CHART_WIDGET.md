# Allocation Pie Chart Widget - Implementation Guide

## Overview
Interactive pie chart widget for displaying portfolio asset distribution by type. Built with `fl_chart` package with touch interactions and smooth animations.

## Location
```
lib/features/dashboard/presentation/widgets/
├── allocation_pie_chart.dart          # Core interactive pie chart widget
└── enhanced_allocation_section.dart   # Complete section with legend (example)
```

## Core Widget: AllocationPieChart

### Features
✅ Interactive touch feedback - sections expand on tap  
✅ Smooth animations when interacting  
✅ Consistent color mapping by asset type  
✅ Responsive aspect ratio (1.3:1)  
✅ Percentage labels visible on each section  
✅ Empty state handling  

### Usage Example

```dart
import 'package:wealthscope_app/features/dashboard/presentation/widgets/allocation_pie_chart.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';

class MyDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final allocations = [
      AssetAllocation(
        type: 'stock',
        label: 'Stocks',
        value: 50000,
        percentage: 50.0,
      ),
      AssetAllocation(
        type: 'crypto',
        label: 'Cryptocurrency',
        value: 30000,
        percentage: 30.0,
      ),
      AssetAllocation(
        type: 'gold',
        label: 'Gold',
        value: 20000,
        percentage: 20.0,
      ),
    ];

    return AllocationPieChart(allocations: allocations);
  }
}
```

### Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `allocations` | `List<AssetAllocation>` | Yes | List of asset allocations to display |

### Asset Type Color Mapping

The widget uses consistent colors for each asset type:

| Asset Type | Color | Hex |
|------------|-------|-----|
| Stock | Blue | `Colors.blue` |
| ETF | Indigo | `Colors.indigo` |
| Real Estate | Green | `Colors.green` |
| Gold | Amber | `Colors.amber` |
| Crypto | Orange | `Colors.orange` |
| Bond | Purple | `Colors.purple` |
| Other | Grey | `Colors.grey` |

## Complete Implementation: EnhancedAllocationSection

### Features
✅ Interactive pie chart with legend  
✅ Asset type labels with color indicators  
✅ Percentage and currency value display  
✅ Card-based layout with proper spacing  
✅ Instruction text for user guidance  

### Usage Example

```dart
import 'package:wealthscope_app/features/dashboard/presentation/widgets/enhanced_allocation_section.dart';

class DashboardScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(portfolioSummaryProvider);

    return summary.when(
      data: (data) => Column(
        children: [
          // ... other widgets
          EnhancedAllocationSection(
            allocations: data.allocations,
          ),
        ],
      ),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => ErrorView(message: err.toString()),
    );
  }
}
```

## Integration Guide

### Step 1: Import the Widget

```dart
import 'package:wealthscope_app/features/dashboard/presentation/widgets/allocation_pie_chart.dart';
```

### Step 2: Use in Dashboard

Replace or supplement existing allocation visualization:

```dart
// Before (basic static chart)
AllocationSection(allocations: summary.allocations)

// After (interactive animated chart)
AllocationPieChart(allocations: summary.allocations)

// Or use complete section with legend
EnhancedAllocationSection(allocations: summary.allocations)
```

### Step 3: Ensure Data Structure

The widget expects `AssetAllocation` objects from portfolio summary:

```dart
@freezed
class AssetAllocation with _$AssetAllocation {
  const factory AssetAllocation({
    required String type,        // Asset type identifier
    required String label,       // Display label
    required double value,       // Monetary value
    required double percentage,  // Percentage of total (0-100)
  }) = _AssetAllocation;
}
```

## Customization Options

### Modify Touch Behavior

```dart
class _AllocationPieChartState extends State<AllocationPieChart> {
  // Change expansion size
  final radius = isTouched ? 70.0 : 50.0;  // Increase from 60 to 70
  
  // Change font size increase
  final fontSize = isTouched ? 18.0 : 12.0;  // Increase from 16 to 18
}
```

### Change Colors

```dart
Color _getTypeColor(String typeString) {
  switch (type) {
    case AssetType.stock:
      return Colors.blueAccent;  // Custom color
    // ... other cases
  }
}
```

### Adjust Center Space

```dart
PieChartData(
  centerSpaceRadius: 50,  // Increase from 40 for larger donut hole
  // ... other properties
)
```

### Modify Section Spacing

```dart
PieChartData(
  sectionsSpace: 3,  // Increase from 2 for more gap between sections
  // ... other properties
)
```

## Architecture Compliance

### ✅ Feature-First Structure
- Located in `dashboard/presentation/widgets/`
- Follows Scream Architecture principles

### ✅ State Management
- Uses StatefulWidget for UI-only touch interaction (acceptable per RULES.md)
- No business logic in widget state
- Data comes from Riverpod providers upstream

### ✅ Styling Best Practices
- Uses theme colors where appropriate
- Responsive with AspectRatio
- Consistent spacing with SizedBox
- Follows Material Design principles

### ✅ Code Quality
- All imports are absolute
- Const constructors used where possible
- Proper null safety
- Clear documentation comments

## Testing Recommendations

### Widget Tests

```dart
testWidgets('AllocationPieChart renders correctly', (tester) async {
  final allocations = [
    AssetAllocation(type: 'stock', label: 'Stocks', value: 5000, percentage: 50),
    AssetAllocation(type: 'gold', label: 'Gold', value: 5000, percentage: 50),
  ];

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: AllocationPieChart(allocations: allocations),
      ),
    ),
  );

  expect(find.byType(PieChart), findsOneWidget);
});

testWidgets('Touch interaction expands section', (tester) async {
  // Test touch callback and radius change
  // ... test implementation
});
```

### Integration Tests

```dart
testWidgets('Pie chart displays portfolio allocations', (tester) async {
  // Mock portfolio data
  // Navigate to dashboard
  // Verify pie chart shows correct percentages
});
```

## Performance Considerations

- ✅ Efficient rebuilds with StatefulWidget
- ✅ AspectRatio prevents layout thrashing
- ✅ Minimal state changes (only touched index)
- ✅ No expensive computations in build method
- ✅ Color mapping uses switch (O(1) lookup)

## Acceptance Criteria Status

| Criterion | Status | Notes |
|-----------|--------|-------|
| ✅ Pie chart renders correctly | Complete | AspectRatio ensures proper sizing |
| ✅ Different colors per type | Complete | 7 asset types with distinct colors |
| ✅ Percentages visible on sections | Complete | Shows rounded percentage with % symbol |
| ✅ Animation on load | Complete | fl_chart provides implicit animations |
| ✅ Touch interaction | Complete | Sections expand on tap with smooth animation |

## Dependencies

```yaml
dependencies:
  fl_chart: ^0.66.0  # Already in pubspec.yaml
  flutter: sdk: flutter
  freezed_annotation: ^2.4.1
  intl: ^0.19.0
```

## Known Limitations

1. **setState Usage**: Uses StatefulWidget with setState for touch interaction. This is acceptable per RULES.md for simple UI interactions, but could be refactored to Riverpod if needed.

2. **Color Customization**: Colors are hardcoded. Consider moving to theme extension for better customization.

3. **Accessibility**: Could benefit from semantic labels for screen readers.

## Future Enhancements

- [ ] Add tooltip on hover/long press showing exact values
- [ ] Export chart as image
- [ ] Add animation duration customization
- [ ] Theme-aware color palette
- [ ] Accessibility improvements (semantic labels)
- [ ] Support for empty state with illustration
- [ ] Add drill-down navigation to asset details

## Related Files

- `lib/features/dashboard/domain/entities/portfolio_summary.dart` - Data models
- `lib/features/assets/domain/entities/asset_type.dart` - Asset type enum
- `lib/features/dashboard/presentation/widgets/allocation_section.dart` - Original implementation

## Questions or Issues?

For questions or issues related to this widget:
1. Check this documentation first
2. Review RULES.md and SKILLS.md
3. Check fl_chart documentation: https://pub.dev/packages/fl_chart
4. Refer to User Story #99 and Task #[task-number]
