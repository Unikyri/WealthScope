# Quick Reference - Error and Empty State Widgets

## 🎯 Purpose
Provide consistent, polished error and empty states across the app with relevant icons, messages, and actions.

---

## 📦 EmptyState Widget

### Import
```dart
import 'package:wealthscope_app/shared/widgets/empty_state.dart';
```

### Available Types

#### 1. Portfolio (No Assets)
```dart
EmptyState.portfolio(
  onAddAsset: () => context.go('/assets/select-type'),
)
```
**Shows:** Wallet icon, "Start Building Your Portfolio", [Add First Asset] button

---

#### 2. Assets List (Empty)
```dart
EmptyState.assets(
  onAddAsset: () => context.push('/assets/select-type'),
)
```
**Shows:** Inventory icon, "No Assets Yet", [Add Asset] button

---

#### 3. Notifications (All Caught Up)
```dart
const EmptyState.notifications()
```
**Shows:** Bell icon, "All Caught Up!", no action button

---

#### 4. Search Results (None Found)
```dart
EmptyState.searchResults(
  searchTerm: query,  // Optional
)
```
**Shows:** Search-off icon, "No Results Found", no action button

---

#### 5. News (No Articles)
```dart
const EmptyState.news()
```
**Shows:** Article icon, "No News Available", no action button

---

#### 6. Generic (Custom)
```dart
EmptyState.generic(
  title: 'No Data Available',
  message: 'Please check back later',
  icon: Icons.data_usage,  // Optional
  actionLabel: 'Refresh',  // Optional
  onAction: () => refresh(),  // Optional
)
```
**Shows:** Custom icon, title, message, and optional action

---

## 📦 ErrorState Widget

### Import
```dart
import 'package:wealthscope_app/shared/widgets/error_state.dart';
```

### Available Types

#### 1. Network Error
```dart
ErrorState.network(
  onRetry: () => ref.invalidate(myProvider),
)
```
**Shows:** WiFi-off icon, "No Internet Connection", [Retry] button

---

#### 2. Server Error
```dart
ErrorState.server(
  errorDetails: 'Custom error message',  // Optional
  onRetry: () => retry(),
)
```
**Shows:** Cloud-off icon, "Server Error", [Try Again] button

---

#### 3. Not Found (404)
```dart
ErrorState.notFound(
  resourceName: 'Asset',  // Optional
)
```
**Shows:** Search-off icon, "Not Found", no action button

---

#### 4. Unauthorized (401/403)
```dart
ErrorState.unauthorized(
  onRetry: () => context.go('/login'),
)
```
**Shows:** Lock icon, "Access Denied", [Sign In] button

---

#### 5. Generic Error
```dart
ErrorState.generic(
  message: error.toString(),
  title: 'Custom Title',  // Optional
  onRetry: () => retry(),  // Optional
  icon: Icons.warning,  // Optional
)
```
**Shows:** Custom icon, title, message, and optional retry

---

## 🎨 Common Usage Patterns

### With AsyncValue (Riverpod)

```dart
final dataAsync = ref.watch(myProvider);

return dataAsync.when(
  data: (data) {
    if (data.isEmpty) {
      return EmptyState.assets(
        onAddAsset: () => addAsset(),
      );
    }
    return ListView.builder(...);
  },
  loading: () => const SkeletonLoader(),
  error: (error, stack) => ErrorState.generic(
    message: error.toString(),
    onRetry: () => ref.invalidate(myProvider),
  ),
);
```

---

### With Try-Catch

```dart
try {
  final data = await fetchData();
  if (data.isEmpty) {
    return const EmptyState.searchResults();
  }
  return DataWidget(data);
} on SocketException {
  return ErrorState.network(
    onRetry: () => fetchData(),
  );
} on DioException catch (e) {
  if (e.response?.statusCode == 500) {
    return ErrorState.server(onRetry: retry);
  } else if (e.response?.statusCode == 404) {
    return const ErrorState.notFound();
  }
  return ErrorState.generic(
    message: e.message ?? 'Unknown error',
    onRetry: retry,
  );
} catch (e) {
  return ErrorState.generic(
    message: e.toString(),
    onRetry: retry,
  );
}
```

---

### In Screen Builds

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final itemsAsync = ref.watch(itemsProvider);

  return Scaffold(
    appBar: AppBar(title: const Text('My Screen')),
    body: itemsAsync.when(
      data: (items) {
        // Empty state
        if (items.isEmpty) {
          return EmptyState.generic(
            title: 'No Items Yet',
            message: 'Add your first item to get started',
            actionLabel: 'Add Item',
            onAction: () => addItem(),
          );
        }
        
        // Content
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => ItemCard(items[index]),
        );
      },
      loading: () => const LoadingSkeleton(),
      error: (error, _) => ErrorState.generic(
        message: error.toString(),
        onRetry: () => ref.invalidate(itemsProvider),
      ),
    ),
  );
}
```

---

## 🎨 Customization Options

### EmptyState Custom Options

```dart
EmptyState.generic(
  title: 'Custom Title',           // Required
  message: 'Custom message',        // Optional, defaults to generic message
  icon: Icons.custom_icon,          // Optional, defaults to inbox icon
  actionLabel: 'Custom Action',     // Optional, no button if omitted
  onAction: () => doSomething(),    // Optional, no button if omitted
)
```

### ErrorState Custom Options

```dart
ErrorState.generic(
  message: 'Error description',     // Required
  title: 'Custom Error Title',      // Optional, defaults to "Something Went Wrong"
  icon: Icons.custom_icon,          // Optional, defaults to error_outline
  onRetry: () => retry(),           // Optional, no button if omitted
)
```

---

## 🚫 Common Mistakes

### ❌ DON'T: Create custom widgets for standard states
```dart
// BAD
Widget _buildEmptyState() {
  return Center(
    child: Column(
      children: [
        Icon(Icons.inbox),
        Text('No items'),
      ],
    ),
  );
}
```

### ✅ DO: Use EmptyState widget
```dart
// GOOD
return const EmptyState.generic(
  title: 'No Items',
  message: 'Add your first item to get started',
);
```

---

### ❌ DON'T: Show generic error for specific cases
```dart
// BAD
ErrorState.generic(
  message: 'No internet connection',  // Use ErrorState.network instead
  onRetry: retry,
)
```

### ✅ DO: Use specific error types
```dart
// GOOD
ErrorState.network(
  onRetry: retry,
)
```

---

### ❌ DON'T: Forget retry actions for recoverable errors
```dart
// BAD
ErrorState.network()  // No retry action
```

### ✅ DO: Provide retry actions
```dart
// GOOD
ErrorState.network(
  onRetry: () => ref.invalidate(provider),
)
```

---

## 📋 When to Use Each Widget

### EmptyState

| Scenario | Type |
|----------|------|
| No assets in portfolio | `EmptyState.portfolio` |
| Empty asset list | `EmptyState.assets` |
| No notifications | `EmptyState.notifications` |
| Search returned nothing | `EmptyState.searchResults` |
| No news articles | `EmptyState.news` |
| Other empty state | `EmptyState.generic` |

### ErrorState

| Scenario | Type |
|----------|------|
| Network unavailable | `ErrorState.network` |
| Server error (5xx) | `ErrorState.server` |
| Resource not found (404) | `ErrorState.notFound` |
| Unauthorized (401/403) | `ErrorState.unauthorized` |
| Other error | `ErrorState.generic` |

---

## 🎯 Icon Reference

### EmptyState Icons

| Type | Icon |
|------|------|
| Portfolio | `account_balance_wallet_outlined` |
| Assets | `inventory_2_outlined` |
| Notifications | `notifications_none_outlined` |
| Search Results | `search_off` |
| News | `article_outlined` |
| Generic | `inbox_outlined` |

### ErrorState Icons

| Type | Icon |
|------|------|
| Network | `wifi_off_rounded` |
| Server | `cloud_off_rounded` |
| Not Found | `search_off` |
| Unauthorized | `lock_outline` |
| Generic | `error_outline` |

---

## 💡 Pro Tips

### 1. Always Provide Context
```dart
// Instead of
EmptyState.generic(title: 'Empty')

// Do
EmptyState.generic(
  title: 'No Transactions',
  message: 'Your transaction history will appear here',
)
```

### 2. Make Retry Actions Meaningful
```dart
// Retry should actually retry the failed operation
ErrorState.network(
  onRetry: () => ref.invalidate(dataProvider),  // ✅ Retries data fetch
)

// Not just navigate away
ErrorState.network(
  onRetry: () => context.go('/'),  // ❌ Doesn't retry
)
```

### 3. Use Appropriate Types
```dart
// For search results
if (query.isNotEmpty && results.isEmpty) {
  return EmptyState.searchResults(searchTerm: query);  // ✅ Clear context
}

// Not generic
if (results.isEmpty) {
  return const EmptyState.generic(title: 'No results');  // ❌ Less clear
}
```

### 4. Combine with Loading States
```dart
dataAsync.when(
  data: (data) => data.isEmpty ? EmptyState() : Content(data),
  loading: () => Skeleton(),  // ✅ Show skeleton while loading
  error: (err, _) => ErrorState(),
)
```

---

## 🔧 Troubleshooting

### EmptyState not showing?
1. Check if data is actually empty
2. Verify the widget is in the correct place in the widget tree
3. Ensure proper import statement

### ErrorState not showing retry button?
1. Make sure `onRetry` callback is provided
2. Check error type - some types don't show retry by default

### Icons look wrong?
1. All icons use theme colors automatically
2. Test in both light and dark mode
3. Icons are sized at 100px for EmptyState, 64px for ErrorState

### Spacing issues?
1. Both widgets have 32px padding by default
2. Buttons have 28px horizontal and 14px vertical padding
3. Don't wrap in additional padding containers

---

## 📖 Related Files

- [ERROR_EMPTY_STATES_COMPLETE.md](ERROR_EMPTY_STATES_COMPLETE.md) - Full implementation guide
- [empty_state.dart](lib/shared/widgets/empty_state.dart) - EmptyState implementation
- [error_state.dart](lib/shared/widgets/error_state.dart) - ErrorState implementation
- [RULES.md](RULES.md) - UI styling rules
