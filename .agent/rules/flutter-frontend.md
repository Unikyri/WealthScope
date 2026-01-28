---
description: Flutter frontend development rules for WealthScope. Apply when working on frontend/ directory, Dart files, or mobile UI components.
globs:
  - "frontend/**/*.dart"
  - "**/pubspec.yaml"
alwaysApply: false
---

# Flutter Frontend Rules - WealthScope

## Architecture

Feature-first organization with clean separation:

```
lib/
├── main.dart
├── app/
│   ├── app.dart          # MaterialApp configuration
│   └── router.dart       # GoRouter configuration
├── core/
│   ├── constants/        # App-wide constants
│   ├── theme/           # ThemeData, colors, typography
│   ├── network/         # API client, interceptors
│   └── utils/           # Helper functions
├── features/
│   └── [feature]/
│       ├── data/        # Repositories, models, DTOs
│       ├── domain/      # Entities, use cases
│       └── presentation/ # Screens, widgets, providers
└── shared/
    ├── widgets/         # Reusable widgets
    └── providers/       # Global providers
```

## State Management

Use Riverpod 2.x exclusively:

```dart
// Prefer FutureProvider for async data
final assetsProvider = FutureProvider.autoDispose<List<Asset>>((ref) async {
  final repo = ref.watch(assetRepositoryProvider);
  return repo.getAll();
});

// Use StateNotifier for complex state
class AssetFormNotifier extends StateNotifier<AssetFormState> {
  AssetFormNotifier() : super(AssetFormState.initial());
  
  void updateType(AssetType type) => state = state.copyWith(type: type);
}

// Always use autoDispose unless state must persist
final formProvider = StateNotifierProvider.autoDispose<AssetFormNotifier, AssetFormState>(
  (ref) => AssetFormNotifier(),
);
```

## Code Standards

### Naming

```dart
// Files: snake_case.dart
// Classes: PascalCase
// Variables, functions: camelCase
// Constants: camelCase or SCREAMING_SNAKE_CASE
// Private: prefix with _

// Widgets: suffix with Screen, Widget, Card, etc.
class DashboardScreen extends ConsumerWidget { }
class AssetCard extends StatelessWidget { }
```

### Widgets

```dart
// Prefer StatelessWidget/ConsumerWidget over StatefulWidget
// Use const constructors when possible
class AssetCard extends StatelessWidget {
  const AssetCard({required this.asset, super.key});
  
  final Asset asset;
  
  @override
  Widget build(BuildContext context) {
    // ...
  }
}

// Extract widgets when build method exceeds ~50 lines
// Name extracted widgets clearly
Widget _buildHeader() { }  // Good for private methods
class _AssetHeader extends StatelessWidget { }  // Better for reusable
```

### Navigation

```dart
// Use GoRouter with typed routes
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/assets/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AssetDetailScreen(assetId: id);
      },
    ),
  ],
);

// Navigate with context.go() or context.push()
context.push('/assets/$assetId');
```

### API Integration

```dart
// Use Dio with interceptors
class ApiClient {
  final Dio _dio;
  
  ApiClient(this._dio) {
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(LoggingInterceptor());
  }
  
  Future<Response<T>> get<T>(String path) => _dio.get(path);
}

// Handle errors gracefully
try {
  final response = await api.get('/assets');
  return Asset.fromJsonList(response.data['data']);
} on DioException catch (e) {
  throw ApiException.fromDio(e);
}
```

## UI Guidelines

### Theme

```dart
// Use theme colors, never hardcode
Text('Title', style: Theme.of(context).textTheme.headlineMedium);
Container(color: Theme.of(context).colorScheme.primary);

// Support dark mode
ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
);
```

### Responsiveness

```dart
// Use MediaQuery for screen-dependent layouts
final width = MediaQuery.of(context).size.width;
final isTablet = width > 600;

// Prefer LayoutBuilder for container-dependent sizing
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return _buildTabletLayout();
    }
    return _buildMobileLayout();
  },
);
```

### Loading & Errors

```dart
// Always show loading states
ref.watch(assetsProvider).when(
  data: (assets) => AssetList(assets: assets),
  loading: () => const AssetListSkeleton(),
  error: (error, stack) => ErrorWidget(error: error, onRetry: () => ref.refresh(assetsProvider)),
);

// Provide meaningful error messages
class ErrorWidget extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(error.toUserMessage()),
        ElevatedButton(onPressed: onRetry, child: Text('Try Again')),
      ],
    );
  }
}
```

### Animations

```dart
// Use Hero for shared element transitions
Hero(
  tag: 'asset-${asset.id}',
  child: AssetCard(asset: asset),
);

// Prefer implicit animations for simple cases
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  // ...
);

// Use Lottie for complex animations
Lottie.asset('assets/animations/loading.json');
```

## Testing

```dart
// Widget tests for UI components
testWidgets('DashboardScreen shows portfolio value', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        portfolioProvider.overrideWith((ref) => mockPortfolio),
      ],
      child: const MaterialApp(home: DashboardScreen()),
    ),
  );
  
  expect(find.text('\$125,000'), findsOneWidget);
});

// Unit tests for providers
test('assetsProvider fetches assets', () async {
  final container = ProviderContainer(
    overrides: [
      assetRepositoryProvider.overrideWithValue(MockAssetRepository()),
    ],
  );
  
  final assets = await container.read(assetsProvider.future);
  expect(assets.length, 5);
});
```

## Performance

```dart
// Use const wherever possible
const SizedBox(height: 16);
const EdgeInsets.all(16);

// Cache images
CachedNetworkImage(imageUrl: url);

// Lazy load lists
ListView.builder(
  itemCount: assets.length,
  itemBuilder: (context, index) => AssetCard(asset: assets[index]),
);

// Avoid rebuilding entire trees
// Use Selector or ref.select to watch specific properties
final totalValue = ref.watch(portfolioProvider.select((p) => p.totalValue));
```

## RevenueCat Integration

```dart
// Check subscription status before Pro features
Future<void> accessProFeature(BuildContext context) async {
  final isPro = await ref.read(revenueCatProvider).isProSubscriber();
  if (!isPro) {
    await showPaywall(context);
    return;
  }
  // Continue with feature
}
```

## Accessibility

```dart
// Add semantic labels
Semantics(
  label: 'Portfolio value: \$125,000',
  child: Text('\$125,000'),
);

// Ensure touch targets are at least 48x48
SizedBox(
  width: 48,
  height: 48,
  child: IconButton(icon: Icon(Icons.add), onPressed: () {}),
);

// Test with screen readers
```
