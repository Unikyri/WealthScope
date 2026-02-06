# API Integration - AI Features Complete

## ✅ Integration Status

All AI-related API endpoints have been integrated following Scream Architecture.

---

## 📦 Features Integrated

### 1. AI Insights (`/features/ai_insights`)

**Endpoints:**
- `GET /api/v1/ai/insights` - List insights with filters
- `GET /api/v1/ai/insights/daily` - Get daily briefing
- `GET /api/v1/ai/insights/{id}` - Get insight by ID
- `PUT /api/v1/ai/insights/{id}/read` - Mark as read
- `GET /api/v1/ai/insights/unread/count` - Get unread count
- `POST /api/v1/ai/insights/generate` - Force generate insights

**Structure:**
```
lib/features/ai_insights/
├── domain/
│   ├── entities/insight_entity.dart
│   └── repositories/insights_repository.dart
├── data/
│   ├── models/insight_dto.dart (freezed)
│   ├── datasources/insights_remote_datasource.dart
│   └── repositories/insights_repository_impl.dart
└── presentation/
    └── providers/insights_providers.dart (@riverpod)
```

**Usage Example:**
```dart
// List insights
final insights = ref.watch(insightsListProvider(
  type: 'daily_briefing',
  priority: 'high',
));

// Get daily briefing
final briefing = ref.watch(dailyBriefingProvider);

// Mark as read
await ref.read(markInsightAsReadProvider.notifier).call(insightId);

// Get unread count
final count = ref.watch(unreadInsightsCountProvider);
```

---

### 2. AI OCR (`/features/ai_ocr`)

**Endpoints:**
- `POST /api/v1/ai/ocr` - Process document (multipart/form-data)
- `POST /api/v1/ai/ocr/confirm` - Confirm extracted assets

**Structure:**
```
lib/features/ai_ocr/
├── domain/
│   ├── entities/ocr_entity.dart
│   └── repositories/ocr_repository.dart
├── data/
│   ├── models/ocr_dto.dart (freezed)
│   ├── datasources/ocr_remote_datasource.dart
│   └── repositories/ocr_repository_impl.dart
└── presentation/
    └── providers/ocr_providers.dart (@riverpod)
```

**Usage Example:**
```dart
// Process document
await ref.read(processDocumentProvider.notifier).process(
  filePath: '/path/to/document.pdf',
  documentHint: 'bank_statement',
);

// Get result
final result = ref.watch(processDocumentProvider);
result.when(
  data: (ocrResult) {
    if (ocrResult != null) {
      // Show extracted assets
      print(ocrResult.assets);
    }
  },
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);

// Confirm assets
await ref.read(confirmOCRAssetsProvider.notifier).confirm(
  assets: extractedAssets,
);
```

---

### 3. Scenarios (`/features/scenarios`)

**Endpoints:**
- `POST /api/v1/ai/simulate` - Run what-if simulation
- `GET /api/v1/ai/scenarios/historical` - Get historical stats
- `GET /api/v1/ai/scenarios/templates` - Get scenario templates

**Structure:**
```
lib/features/scenarios/
├── domain/
│   ├── entities/scenario_entity.dart
│   └── repositories/scenarios_repository.dart
├── data/
│   ├── models/scenario_dto.dart (freezed)
│   ├── datasources/scenarios_remote_datasource.dart
│   └── repositories/scenarios_repository_impl.dart
└── presentation/
    └── providers/scenarios_providers.dart (@riverpod)
```

**Usage Example:**
```dart
// Get templates
final templates = ref.watch(scenarioTemplatesProvider);

// Get historical stats
final stats = ref.watch(historicalStatsProvider(
  symbol: 'AAPL',
  period: '1Y',
));

// Run simulation
await ref.read(runSimulationProvider.notifier).simulate(
  type: 'buy_asset',
  parameters: {
    'asset_id': 'xxx',
    'quantity': 10,
    'price': 150.0,
  },
);

// Get result
final result = ref.watch(runSimulationProvider);
result.when(
  data: (simulation) {
    if (simulation != null) {
      print('Projected Value: ${simulation.projectedState.totalValue}');
      print('AI Analysis: ${simulation.aiAnalysis}');
    }
  },
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```

---

### 4. Portfolio (`/features/portfolio`)

**Endpoints:**
- `GET /api/v1/portfolio/summary` - Get portfolio summary
- `GET /api/v1/portfolio/risk` - Get risk analysis & alerts

**Structure:**
```
lib/features/portfolio/
├── domain/
│   └── repositories/portfolio_repository.dart
├── data/
│   ├── models/portfolio_dto.dart (freezed)
│   ├── datasources/portfolio_remote_datasource.dart
│   └── repositories/portfolio_repository_impl.dart
└── presentation/
    └── providers/portfolio_providers.dart (@riverpod)
```

**Usage Example:**
```dart
// Get portfolio summary
final summary = ref.watch(portfolioSummaryProvider);

// Get risk analysis
final riskAnalysis = ref.watch(portfolioRiskAnalysisProvider);
riskAnalysis.when(
  data: (analysis) {
    print('Risk Score: ${analysis.riskScore}');
    print('Diversification: ${analysis.diversificationLevel}');
    for (var alert in analysis.alerts) {
      print('${alert.severity}: ${alert.title}');
    }
  },
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```

---

## 🔧 Technical Details

### Code Generation Required

All new features use:
- **freezed** for immutable DTOs
- **json_serializable** for JSON parsing
- **riverpod_generator** for providers

Run after any changes:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Error Handling

All repositories use `Either<Failure, T>` from `dartz` package:
```dart
final result = await repository.someMethod();
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (data) => print('Success: $data'),
);
```

Providers automatically convert to AsyncValue for UI:
```dart
ref.watch(someProvider).when(
  data: (data) => SuccessWidget(data),
  loading: () => LoadingWidget(),
  error: (err, stack) => ErrorWidget(err),
);
```

---

## 🎯 Next Steps

### UI Implementation Needed

1. **Insights Screen** - Display daily briefings and alerts
2. **OCR Screen** - Document scanner + asset extraction
3. **Scenarios Screen** - What-if calculator
4. **Risk Dashboard** - Portfolio risk visualization

### Integration Points

These features integrate with existing:
- Dashboard (portfolio summary)
- Assets (OCR creates assets)
- AI Chat (insights can trigger conversations)

---

## 📋 API Response Structures

### Insight Entity
```dart
class InsightEntity {
  final String id;
  final String type; // daily_briefing, alert, recommendation
  final String category; // risk, performance, opportunity, general
  final String priority; // high, medium, low
  final String title;
  final String content;
  final List<String> actionItems;
  final List<String> relatedSymbols;
  final bool isRead;
  final DateTime createdAt;
}
```

### OCR Result Entity
```dart
class OCRResultEntity {
  final String documentType;
  final List<ExtractedAssetEntity> assets;
  final List<String> warnings;
}

class ExtractedAssetEntity {
  final String name;
  final String? symbol;
  final String type;
  final double quantity;
  final double purchasePrice;
  final String currency;
  final double? totalValue;
  final double confidence; // 0.0 to 1.0
}
```

### Simulation Result Entity
```dart
class SimulationResultEntity {
  final PortfolioStateEntity currentState;
  final PortfolioStateEntity projectedState;
  final List<ChangeDetailEntity> changes;
  final String aiAnalysis;
  final List<String> warnings;
}
```

### Portfolio Risk Analysis
```dart
class PortfolioRiskAnalysis {
  final int riskScore; // 0-100
  final String diversificationLevel; // low, moderate, high
  final List<RiskAlert> alerts;
}
```

---

## ✅ Checklist

- [x] AI Insights domain layer
- [x] AI Insights data layer
- [x] AI Insights providers
- [x] AI OCR domain layer
- [x] AI OCR data layer
- [x] AI OCR providers
- [x] Scenarios domain layer
- [x] Scenarios data layer
- [x] Scenarios providers
- [x] Portfolio domain layer
- [x] Portfolio data layer
- [x] Portfolio providers
- [x] Code generation successful
- [ ] UI Screens (pending)
- [ ] Integration tests (pending)

---

**Status:** ✅ Backend integration complete. Ready for UI implementation.
