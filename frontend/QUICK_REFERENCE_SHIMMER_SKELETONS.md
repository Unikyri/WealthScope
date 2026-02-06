# Quick Reference - Shimmer Skeleton Screens

## 🎯 Purpose
Replace plain loading indicators with professional shimmer skeleton screens that match content layout.

---

## 📦 Available Skeleton Widgets

### 1. Shared Components

#### ShimmerBox
```dart
import 'package:wealthscope_app/shared/widgets/shimmer_box.dart';

ShimmerBox(
  width: 120,           // Optional
  height: 20,           // Required
  borderRadius: BorderRadius.circular(8),  // Optional
)
```

#### ShimmerContainer
```dart
ShimmerContainer(
  child: Column(
    children: [
      Container(width: 100, height: 20, color: Colors.grey[300]),
      // ... more placeholders
    ],
  ),
)
```

---

### 2. Feature-Specific Skeletons

#### Dashboard
```dart
import 'package:wealthscope_app/features/dashboard/presentation/widgets/dashboard_skeleton.dart';

const DashboardSkeleton()
```

**Includes:**
- Portfolio summary card
- Quick stats row (3 cards)
- Performance metrics
- Portfolio history chart
- News section

---

#### Asset List
```dart
import 'package:wealthscope_app/features/assets/presentation/widgets/asset_list_skeleton.dart';

const AssetListSkeleton()  // Shows 5 cards
const AssetCardSkeleton()  // Individual card
```

**Includes:**
- Asset icon placeholder
- Asset name and quantity
- Value and percentage change

---

#### Asset Detail
```dart
import 'package:wealthscope_app/features/assets/presentation/widgets/asset_detail_skeleton.dart';

const AssetDetailSkeleton()
```

**Includes:**
- Large icon header
- Name, symbol, price
- Investment details (4 rows)
- Metadata section (3 rows)

---

#### News List
```dart
import 'package:wealthscope_app/features/news/presentation/widgets/news_list_skeleton.dart';

const NewsListSkeleton()   // Shows 6 cards
const NewsCardSkeleton()   // Individual card
```

**Includes:**
- Image placeholder (200px height)
- Title (2 lines)
- Description (3 lines)
- Source and date

---

#### Notifications
```dart
import 'package:wealthscope_app/features/notifications/presentation/widgets/notifications_list_skeleton.dart';

const NotificationsListSkeleton()  // Shows grouped layout
const NotificationCardSkeleton()   // Individual card
```

**Includes:**
- Section headers
- Icon placeholder
- Title with icon
- Message (2 lines)
- Timestamp

---

## 🎨 Theme Colors Used

All skeletons automatically adapt to theme:

```dart
final theme = Theme.of(context);
final isDark = theme.brightness == Brightness.dark;

// Base color - the shimmer background
final baseColor = theme.colorScheme.surfaceContainerHighest;

// Highlight color - the shimmer wave
final highlightColor = isDark
    ? theme.colorScheme.surfaceContainerLow
    : theme.colorScheme.surface;
```

---

## 💡 Usage Patterns

### With AsyncValue (Riverpod)
```dart
final dataAsync = ref.watch(myProvider);

return dataAsync.when(
  data: (data) => MyContentWidget(data),
  loading: () => const MySkeletonWidget(),  // ✅ Use skeleton here
  error: (error, stack) => ErrorView(error),
);
```

### With Boolean Loading State
```dart
if (isLoading) {
  return const MySkeletonWidget();  // ✅ Use skeleton here
}
return MyContentWidget();
```

### With Empty + Loading State
```dart
if (items.isEmpty && isLoading) {
  return const MySkeletonWidget();  // ✅ Use skeleton here
}
if (items.isEmpty) {
  return const EmptyView();
}
return ListView.builder(...);
```

---

## 🚫 Common Mistakes to Avoid

### ❌ DON'T: Use CircularProgressIndicator
```dart
// BAD
loading: () => const Center(
  child: CircularProgressIndicator(),
)
```

### ✅ DO: Use Skeleton Widget
```dart
// GOOD
loading: () => const MySkeletonWidget()
```

---

### ❌ DON'T: Hardcode Colors
```dart
// BAD
Container(
  color: Color(0xFFE0E0E0),  // ❌ Hardcoded color
)
```

### ✅ DO: Use Theme Colors
```dart
// GOOD
Container(
  color: theme.colorScheme.surfaceContainerHighest,  // ✅ Theme-aware
)
```

---

### ❌ DON'T: Wrap in Center Without Need
```dart
// BAD - Skeleton should fill space
loading: () => const Center(
  child: AssetDetailSkeleton(),
)
```

### ✅ DO: Let Skeleton Control Layout
```dart
// GOOD
loading: () => const AssetDetailSkeleton()
```

---

## 🔧 Creating Custom Skeletons

### Template Pattern
```dart
import 'package:flutter/material.dart';
import 'package:wealthscope_app/shared/widgets/shimmer_box.dart';

class MyCustomSkeleton extends StatelessWidget {
  const MyCustomSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmerColor = theme.colorScheme.surfaceContainerHighest;

    return ShimmerContainer(
      child: Column(
        children: [
          // Header placeholder
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: shimmerColor,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 16),
          
          // Content placeholders
          _buildContentRows(shimmerColor),
        ],
      ),
    );
  }

  List<Widget> _buildContentRows(Color shimmerColor) {
    return List.generate(3, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 16,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Spacer(),
            Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      );
    });
  }
}
```

---

## 📏 Sizing Guidelines

| Element Type | Typical Height | Border Radius |
|-------------|----------------|---------------|
| Small text | 12-14px | 4px |
| Body text | 16px | 4px |
| Title text | 20-24px | 4px |
| Button | 40-48px | 8px |
| Icon | 24-48px | 12px (or circle) |
| Card | 100-200px | 12px |
| Image | 150-300px | 8-12px |
| Section | Variable | 12-16px |

---

## ✅ Checklist for New Skeletons

- [ ] Uses `ShimmerContainer` or individual shimmer widgets
- [ ] Theme colors only (no hardcoded colors)
- [ ] Matches actual content layout
- [ ] Border radius matches actual widgets
- [ ] Proper spacing between elements
- [ ] Documented with clear comments
- [ ] No linter errors
- [ ] Tested in light and dark mode
- [ ] File named `*_skeleton.dart`
- [ ] Located in correct feature folder

---

## 🎯 Performance Tips

1. **Use const constructors** where possible
2. **Avoid unnecessary rebuilds** - skeleton widgets should be stateless
3. **Keep shimmer count reasonable** - max 10-15 visible items
4. **Use proper keys** when in lists
5. **Don't animate on every frame** - shimmer package handles this

---

## 📚 Package Reference

**Shimmer Package:** `shimmer: ^3.0.0`

```yaml
# pubspec.yaml
dependencies:
  shimmer: ^3.0.0
```

**Documentation:** https://pub.dev/packages/shimmer

---

## 🔍 Debugging Tips

### Skeleton Not Showing?
1. Check if loading state is actually triggered
2. Verify `AsyncValue.when()` is used correctly
3. Ensure skeleton widget is imported

### Colors Look Wrong?
1. Verify theme colors are being used
2. Check brightness (light vs dark mode)
3. Test with different Material color schemes

### Shimmer Not Animating?
1. Check if `Shimmer.fromColors()` is wrapping correctly
2. Verify base and highlight colors are different enough
3. Ensure widget is visible (not hidden by parent)

### Layout Looks Different?
1. Compare with actual content widget
2. Match padding, margins, sizes
3. Use DevTools inspector to debug layout

---

## 📖 Related Files

- [SHIMMER_SKELETONS_COMPLETE.md](SHIMMER_SKELETONS_COMPLETE.md) - Full implementation guide
- [RULES.md](RULES.md) - UI styling rules
- [AGENTS.md](AGENTS.md) - Architecture overview
