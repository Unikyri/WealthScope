# Quick Reference - Asset Creation API

## API Endpoints

### Create Asset
```
POST /api/v1/assets
```

**Required Fields:**
- `type`: stock | etf | bond | crypto | real_estate | gold | cash | other
- `name`: Asset name
- `quantity`: Quantity purchased
- `purchase_price`: Purchase price per unit

**Optional Fields:**
- `symbol`: Stock/crypto symbol
- `currency`: Currency code (USD, EUR, etc.)
- `current_price`: Current market price
- `purchase_date`: ISO 8601 date string
- `metadata`: Additional metadata object
- `notes`: User notes

## Code Examples

### Create Stock
```dart
final asset = StockAsset(
  userId: userId,
  type: AssetType.stock,
  name: 'Apple Inc.',
  symbol: 'AAPL',
  quantity: 10,
  purchasePrice: 150.00,
  currentPrice: 175.50,
  currency: Currency.usd,
  purchaseDate: DateTime(2024, 1, 15),
  notes: 'Long term investment',
);

await ref.read(stockFormProvider.notifier).submitForm(asset);
```

### Create Real Estate
```dart
final asset = StockAsset(
  userId: userId,
  type: AssetType.realEstate,
  name: 'Downtown Apartment',
  quantity: 1,
  purchasePrice: 250000.00,
  currency: Currency.usd,
  purchaseDate: DateTime(2023, 6, 1),
  metadata: {
    'address': '123 Main St',
    'sqft': 1200,
  },
);

await ref.read(stockFormProvider.notifier).submitForm(asset);
```

### Create Cryptocurrency
```dart
final asset = StockAsset(
  userId: userId,
  type: AssetType.crypto,
  name: 'Bitcoin',
  symbol: 'BTC',
  quantity: 0.5,
  purchasePrice: 45000.00,
  currentPrice: 52000.00,
  currency: Currency.usd,
);

await ref.read(stockFormProvider.notifier).submitForm(asset);
```

## Navigation

### From Dashboard
```dart
// Dashboard FAB
FloatingActionButton.extended(
  onPressed: () => context.go('/assets/select-type'),
  icon: const Icon(Icons.add),
  label: const Text('Add Asset'),
)
```

### Asset Type Selection
```dart
// Stock/ETF
context.push('/assets/add-stock?type=stock');

// Other types
context.push('/assets/add?type=real_estate');
context.push('/assets/add?type=gold');
context.push('/assets/add?type=crypto');
context.push('/assets/add?type=bond');
context.push('/assets/add?type=cash');
context.push('/assets/add?type=other');
```

## Asset Types & Icons

| Type | API String | Icon |
|------|-----------|------|
| Stock | `stock` | `Icons.trending_up` |
| ETF | `etf` | `Icons.pie_chart` |
| Bond | `bond` | `Icons.account_balance` |
| Crypto | `crypto` | `Icons.currency_bitcoin` |
| Real Estate | `real_estate` | `Icons.home` |
| Gold | `gold` | `Icons.diamond` |
| Cash | `cash` | `Icons.account_balance_wallet` |
| Other | `other` | `Icons.category` |

## Validation

All validation in `lib/core/utils/asset_validators.dart`:

```dart
AssetValidators.validateName(value)
AssetValidators.validateSymbol(value)
AssetValidators.validateQuantity(value)
AssetValidators.validatePrice(value)
```

## Error Handling

```dart
final state = ref.watch(stockFormProvider);

if (state.error != null) {
  SnackbarUtils.showError(context, state.error!);
}

if (state.savedAsset != null) {
  SnackbarUtils.showSuccess(context, 'Asset added successfully');
  context.pop();
}
```

## Loading State

```dart
final formState = ref.watch(stockFormProvider);

FilledButton(
  onPressed: formState.isLoading ? null : _handleSubmit,
  child: formState.isLoading
      ? const CircularProgressIndicator()
      : const Text('Add Asset'),
)
```

## Currency Support

```dart
final selectedCurrency = ref.watch(selectedCurrencyProvider);

// Change currency
ref.read(selectedCurrencyProvider.notifier).state = Currency.eur;

// Available currencies
Currency.usd // $ USD
Currency.eur // € EUR
Currency.gbp // £ GBP
Currency.jpy // ¥ JPY
```

## Field Labels by Type

### Real Estate
- Name: "Property Name"
- Quantity: "Property Units"
- Price: "Purchase Price per Unit"

### Gold
- Name: "Gold Product Name"
- Quantity: "Weight (oz)"
- Price: "Price per Ounce"

### Crypto
- Name: "Cryptocurrency Name"
- Symbol: e.g., BTC

### Cash
- Name: "Account Name"
- Quantity: "Amount"
- Price: "Initial Amount (use 1 for quantity)"

### Bond
- Name: "Bond Name"
- Symbol: e.g., ISIN code

## Testing

```bash
# Run build_runner after changes
dart run build_runner build --delete-conflicting-outputs

# Check for errors
flutter analyze lib/features/assets

# Run tests
flutter test test/assets/
```
