# Asset List Screen - Quick Reference

## Screen Preview
```
┌─────────────────────────────────────┐
│ My Assets                      [+]  │ <- AppBar
├─────────────────────────────────────┤
│ [All] [Stocks] [ETFs] [Real Estate] │ <- Filter Chips (horizontal scroll)
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ [📈] AAPL                  $150 │ │
│ │      Apple Inc.          +2.5% │ │ <- AssetCard
│ │      10 Stocks               › │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ [📊] VOOG                  $250 │ │
│ │      Vanguard S&P 500     +1.8% │ │
│ │      5 ETFs                   › │ │
│ └─────────────────────────────────┘ │
│                                     │
│                [+] Add Asset        │ <- FAB
└─────────────────────────────────────┘
```

## Data Flow
```
User Action
    ↓
AssetsListScreen (ConsumerWidget)
    ↓
ref.watch(searchedAssetsProvider) ← AsyncValue<List<StockAsset>>
    ↓
    ├─ Loading → AssetListSkeleton (shimmer)
    ├─ Empty   → EmptyAssetsView (illustration + CTA)
    ├─ Error   → ErrorView (message + retry)
    └─ Data    → ListView.builder(AssetCard)
```

## Provider Chain
```
selectedAssetTypeProvider (StateProvider)
    ↓
allAssetsProvider (FutureProvider)
    ↓
filteredAssetsProvider (FutureProvider) ← filters by type
    ↓
assetSearchProvider (StateProvider)
    ↓
searchedAssetsProvider (FutureProvider) ← filters by search
    ↓
AssetsListScreen
```

## Key Interactions

### 1. Filter Asset Type
```dart
// User taps a filter chip
AssetTypeFilterChips(
  selected: selectedType,
  onSelected: (type) => ref.read(selectedAssetTypeProvider.notifier).select(type),
)
```

### 2. Navigate to Add Asset
```dart
// User taps FAB or AppBar add button
onPressed: () => context.push('/assets/add')
```

### 3. Navigate to Asset Detail
```dart
// User taps an AssetCard
AssetCard(
  asset: asset,
  onTap: () => context.push('/assets/${asset.id}')
)
```

### 4. Pull to Refresh
```dart
RefreshIndicator(
  onRefresh: () async {
    ref.invalidate(allAssetsProvider);
  },
  child: ListView.builder(...)
)
```

### 5. Retry on Error
```dart
ErrorView(
  message: error.toString(),
  onRetry: () => ref.invalidate(allAssetsProvider),
)
```

## Theme Usage (No Hardcoded Colors!)
```dart
// Primary color
theme.colorScheme.primary

// Background
theme.colorScheme.primaryContainer

// Text
theme.textTheme.titleLarge
theme.textTheme.bodyMedium

// Opacity
theme.colorScheme.onSurface.withOpacity(0.6)
```

## Widget Breakdown

### AssetCard
- Icon based on asset type
- Symbol + Name + Quantity
- Current value
- Gain/Loss badge (green/red)
- Chevron icon
- Tap → navigate to detail

### AssetTypeFilterChips
- Horizontal scrollable
- "All" + all AssetType enum values
- Selected state with primary color
- Checkmark on selected

### EmptyAssetsView
- Large wallet icon
- "No Assets Yet" title
- Description text
- "Add First Asset" button

### ErrorView
- Error icon
- "Oops! Something Went Wrong" title
- Error message
- "Try Again" button

### AssetListSkeleton
- 5 shimmer cards
- Matches AssetCard layout
- Animated loading effect
