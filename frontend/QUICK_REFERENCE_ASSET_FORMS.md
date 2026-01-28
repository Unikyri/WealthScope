# Quick Reference - Asset Forms API Integration

## 📝 How to Submit a Form

### 1. Stock/ETF Form

```dart
// Get user ID
final userId = Supabase.instance.client.auth.currentUser?.id;

// Build asset
final asset = StockAsset(
  userId: userId!,
  symbol: 'AAPL',
  name: 'Apple Inc.',
  quantity: 10.0,
  purchasePrice: 150.00,
  currency: Currency.usd,
  type: AssetType.stock,
);

// Submit
await ref.read(stockFormProvider.notifier).submitForm(asset);

// Check result
final state = ref.read(stockFormProvider);
if (state.error != null) {
  SnackbarUtils.showError(context, state.error!);
} else {
  SnackbarUtils.showSuccess(context, 'Asset added');
  context.pop();
}
```

### 2. Gold Form

```dart
// Provider handles everything internally
final success = await ref.read(goldFormProvider.notifier).submit();

if (success) {
  SnackbarUtils.showSuccess(context, 'Gold asset added');
} else {
  final error = ref.read(assetFormSubmissionProvider).error;
  SnackbarUtils.showError(context, error ?? 'Failed to add asset');
}
```

### 3. Real Estate Form

```dart
// Provider handles everything internally
final success = await ref.read(realEstateFormProvider.notifier).submit();

if (success) {
  SnackbarUtils.showSuccess(context, 'Property added');
} else {
  final error = ref.read(assetFormSubmissionProvider).error;
  SnackbarUtils.showError(context, error ?? 'Failed to add property');
}
```

---

## 🎯 Direct API Submission (Alternative)

```dart
// Use AssetFormSubmissionProvider directly
await ref.read(assetFormSubmissionProvider.notifier).submitCreate(asset);

final state = ref.read(assetFormSubmissionProvider);

if (state.error != null) {
  // Error
} else if (state.savedAsset != null) {
  // Success - asset list auto-refreshed
}
```

---

## 🛠️ Error Messages

```dart
// User-friendly messages
'Session expired. Please log in again.'           // 401/403
'Connection error. Please check your internet.'   // Network
'Asset not found'                                 // 404
'<Backend error message>'                         // 400/422
'Unexpected error: <details>'                     // Other
```

---

## 📦 Required Imports

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wealthscope_app/core/utils/snackbar_utils.dart';
import 'package:wealthscope_app/features/assets/presentation/providers/asset_form_submission_provider.dart';
import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/assets/domain/entities/currency.dart';
```

---

## 🔄 Auto-Refresh

After successful submission, asset lists are automatically invalidated:

```dart
ref.invalidate(allAssetsProvider);
```

No manual refresh needed!

---

## ⚡ Loading State

```dart
final formState = ref.watch(stockFormProvider);

// Show spinner
if (formState.isLoading) {
  return const CircularProgressIndicator();
}

// Disable button
ElevatedButton(
  onPressed: formState.isLoading ? null : _handleSubmit,
  child: formState.isLoading 
    ? const CircularProgressIndicator()
    : const Text('Submit'),
);
```

---

## 🎨 Snackbar Utilities

```dart
// Success (green with checkmark)
SnackbarUtils.showSuccess(context, 'Operation successful');

// Error (red with dismiss button)
SnackbarUtils.showError(context, 'Something went wrong');

// Info (blue)
SnackbarUtils.showInfo(context, 'Informational message');
```

---

## 🧪 Testing

```bash
# Run code generation after changes
dart run build_runner build --delete-conflicting-outputs

# Check for errors
flutter analyze lib/features/assets
```

---

## 📚 See Also

- [ASSET_FORMS_API_INTEGRATION.md](./ASSET_FORMS_API_INTEGRATION.md) - Full implementation details
- [API_IMPLEMENTATION.md](./API_IMPLEMENTATION.md) - API structure
