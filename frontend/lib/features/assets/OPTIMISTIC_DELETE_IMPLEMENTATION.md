# Optimistic Delete Implementation

## Overview
Implemented optimistic UI updates for asset deletion to provide instant feedback without waiting for backend response.

## Implementation Strategy

### Option 2: Optimistic Update (Implemented) ✅

Benefits:
- **Instant UI feedback** - Item disappears immediately
- **Better UX** - No loading delay
- **Graceful error handling** - Reverts on failure

### Architecture Changes

#### 1. Provider Update
**File:** [lib/features/assets/presentation/providers/assets_provider.dart](lib/features/assets/presentation/providers/assets_provider.dart)

Changed `allAssetsProvider` from `FutureProvider` to `AsyncNotifierProvider`:

```dart
@riverpod
class AllAssets extends _$AllAssets {
  @override
  Future<List<StockAsset>> build() async {
    final repository = ref.watch(assetRepositoryProvider);
    return await repository.getAssets();
  }

  /// Optimistically remove an asset from the list
  void removeAsset(String assetId) {
    state = state.whenData((assets) {
      return assets.where((asset) => asset.id != assetId).toList();
    });
  }

  /// Refresh the asset list from the backend
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(assetRepositoryProvider);
      return await repository.getAssets();
    });
  }
}
```

**Key Methods:**
- `removeAsset(String assetId)` - Optimistically removes asset from state
- `refresh()` - Manually refreshes from backend (used for error recovery)

#### 2. Assets List Screen Update
**File:** [lib/features/assets/presentation/screens/assets_list_screen.dart](lib/features/assets/presentation/screens/assets_list_screen.dart)

Updated `Dismissible.onDismissed` handler:

```dart
onDismissed: (direction) async {
  // 1. Optimistically update UI immediately
  ref.read(allAssetsProvider.notifier).removeAsset(asset.id!);

  try {
    // 2. Delete asset from backend
    await ref.read(assetRepositoryProvider).deleteAsset(asset.id!);

    // 3. Show success message
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${asset.name} deleted')),
      );
    }
  } catch (e) {
    // 4. Revert optimistic update by refreshing from backend
    await ref.read(allAssetsProvider.notifier).refresh();
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete: $e'),
          backgroundColor: theme.colorScheme.error,
        ),
      );
    }
  }
}
```

**Flow:**
1. **Immediate UI Update** - Asset removed from list instantly
2. **Backend Call** - Async deletion request
3. **Success** - Show confirmation snackbar
4. **Error** - Refresh list to restore item + show error message

#### 3. Asset Detail Screen
**File:** [lib/features/assets/presentation/screens/asset_detail_screen.dart](lib/features/assets/presentation/screens/asset_detail_screen.dart)

No changes needed - still uses `ref.invalidate(allAssetsProvider)` which works correctly:

```dart
try {
  final repository = ref.read(assetRepositoryProvider);
  await repository.deleteAsset(assetId);
  
  // Invalidate the assets list to refresh
  ref.invalidate(allAssetsProvider);
  
  if (context.mounted) {
    context.go('/assets');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Asset deleted successfully')),
    );
  }
} catch (e) { ... }
```

## Acceptance Criteria ✅

- [x] **List updates after deletion** - Optimistic update provides instant feedback
- [x] **No manual pull-to-refresh needed** - Automatic state management
- [x] **Smooth deletion animation** - Dismissible widget handles animation
- [x] **Works from detail screen** - Invalidation triggers list refresh
- [x] **Works from list screen** - Optimistic update with error recovery

## User Experience Flow

### Success Case (List Screen)
1. User swipes to delete → Confirmation dialog
2. User confirms → **Item disappears immediately** ⚡
3. Backend processes deletion
4. Snackbar shows success message

### Error Case (List Screen)
1. User swipes to delete → Confirmation dialog
2. User confirms → **Item disappears immediately** ⚡
3. Backend call fails
4. **Item reappears** with error message

### From Detail Screen
1. User taps delete → Confirmation dialog
2. User confirms → Loading indicator
3. Backend processes deletion
4. Navigate to list + refresh
5. Show success message

## Technical Notes

### State Management
- **AsyncNotifier** allows mutable state with loading/error handling
- **state.whenData()** preserves AsyncValue structure during updates
- **AsyncValue.guard()** automatically catches errors during refresh

### Error Recovery
- **List Screen**: Optimistic → Revert on error
- **Detail Screen**: Traditional → Wait for confirmation

### Performance
- **No unnecessary API calls** on success
- **Single refresh** on error to restore consistency
- **Provider invalidation** works seamlessly with new notifier structure

## Testing Recommendations

1. **Happy Path**: Delete asset → Verify instant removal → Check backend
2. **Error Path**: Simulate network error → Verify item restoration
3. **Navigation**: Delete from detail → Verify list refresh
4. **Animation**: Verify smooth swipe-to-delete animation
5. **Race Conditions**: Rapid deletes → Verify queue handling

## Future Enhancements

- [ ] **Undo functionality** - Restore deleted asset within timeframe
- [ ] **Batch deletion** - Select multiple assets for deletion
- [ ] **Offline support** - Queue deletions for later sync
- [ ] **Confirmation preferences** - Remember "Don't ask again" setting

## Related Files

- [assets_provider.dart](lib/features/assets/presentation/providers/assets_provider.dart) - State management
- [assets_list_screen.dart](lib/features/assets/presentation/screens/assets_list_screen.dart) - List UI with dismissible
- [asset_detail_screen.dart](lib/features/assets/presentation/screens/asset_detail_screen.dart) - Detail view delete
- [delete_asset_dialog.dart](lib/features/assets/presentation/widgets/delete_asset_dialog.dart) - Confirmation dialog
- [asset_repository.dart](lib/features/assets/domain/repositories/asset_repository.dart) - Delete interface
- [asset_repository_impl.dart](lib/features/assets/data/repositories/asset_repository_impl.dart) - Delete implementation

---

**Estimated Time:** 1 hour  
**Status:** ✅ Complete  
**Issue:** #88 (Part of US-3.5 #87)
