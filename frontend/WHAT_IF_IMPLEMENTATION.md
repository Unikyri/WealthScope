# What-If Simulator - Implementation Complete ✅

## Overview
The What-If Simulator screen has been successfully implemented, allowing users to simulate various portfolio scenarios with AI-powered analysis.

## Files Created

### 1. Screen
- **File**: [lib/features/ai/presentation/screens/what_if_screen.dart](lib/features/ai/presentation/screens/what_if_screen.dart)
- **Description**: Main What-If simulator screen with scenario selection and parameter inputs
- **Components**:
  - `WhatIfScreen`: Main screen with form and simulation logic
  - `_ScenarioTypeSelector`: Horizontal chip selector for scenario types
  - `_MarketMoveParams`: Market movement parameters with slider
  - `_BuySellParams`: Buy/sell asset parameters with validation
  - `_NewAssetParams`: Placeholder for new asset feature
  - `_RebalanceParams`: Placeholder for rebalancing feature
  - `_SimulationResults`: Results display with AI analysis
  - `_RiskScoreIndicator`: Visual risk score indicator

### 2. Domain Entity
- **File**: [lib/features/ai/domain/entities/scenario_result.dart](lib/features/ai/domain/entities/scenario_result.dart)
- **Description**: Entity representing simulation results
- **Properties**:
  - `scenarioType`: Type of scenario simulated
  - `currentValue`: Current portfolio value
  - `projectedValue`: Projected portfolio value
  - `valueChange`: Absolute change in value
  - `percentChange`: Percentage change
  - `aiAnalysis`: Optional AI-generated analysis
  - `riskScore`: Risk score (0-100)

### 3. Provider
- **File**: [lib/features/ai/presentation/providers/simulator_provider.dart](lib/features/ai/presentation/providers/simulator_provider.dart)
- **Description**: Riverpod provider managing simulation state
- **Methods**:
  - `runSimulation()`: Execute a What-If scenario
  - `clearResult()`: Clear current simulation result
- **Generated File**: `simulator_provider.g.dart` (auto-generated)

### 4. Router Update
- **File**: [lib/core/router/app_router.dart](lib/core/router/app_router.dart)
- **Route**: `/what-if` (name: `what-if`)

## Scenario Types Implemented

### 1. Market Movement ✅
- **Description**: Simulate market changes on portfolio
- **Parameters**:
  - Change percentage (-50% to +50%)
  - Quick preset buttons: -30%, -20%, -10%, +10%, +20%, +30%
- **Features**:
  - Interactive slider
  - Real-time percentage display
  - AI analysis of impact

### 2. Buy Asset ✅
- **Description**: Simulate buying an existing asset
- **Parameters**:
  - Asset selection (dropdown)
  - Quantity (with validation)
  - Price per unit
  - Total cost calculation
- **Validation**:
  - Required fields
  - Positive numbers only
  - Decimal precision (8 decimals for quantity, 2 for price)

### 3. Sell Asset ✅
- **Description**: Simulate selling an existing asset
- **Parameters**: Same as Buy Asset
- **Features**: Total value calculation

### 4. Add New Asset 🚧
- **Status**: Placeholder (Coming Soon)
- **Description**: Will allow simulating addition of new asset types

### 5. Rebalance Portfolio 🚧
- **Status**: Placeholder (Coming Soon)
- **Description**: Will allow simulating portfolio rebalancing

## Features Implemented

### ✅ Core Functionality
- Scenario type selection with chips
- Dynamic parameter forms based on scenario type
- Form validation
- Loading states during simulation
- Error handling with SnackBar notifications
- Mounted state checks for async operations

### ✅ Results Display
- Current vs projected portfolio value
- Value change (absolute and percentage)
- Color-coded changes (green for gains, red for losses)
- AI-powered analysis text
- Risk score indicator (0-100 with visual progress bar)
- Risk categories: Low (0-29), Medium (30-59), High (60-100)

### ✅ UI/UX
- Responsive layout with SingleChildScrollView
- Material Design 3 components
- Theme-aware colors (no hardcoded hex values)
- Proper spacing and padding
- Icon integration for visual clarity
- Disabled state for simulation button during loading

## Mock Implementation

Currently, the simulator uses mock data with realistic calculations:

### Market Move Logic
```dart
projectedValue = currentValue * (1 + changePercent / 100)
```

### Buy/Sell Logic
```dart
// Buy: Adds investment with 5% assumed growth
projectedValue = currentValue - cost + (cost * 1.05)

// Sell: Reduces portfolio by transaction value
projectedValue = currentValue - transactionValue
```

### Risk Score Calculation
- < 5% change: Low risk (20)
- 5-10% change: Low-medium risk (35)
- 10-20% change: Medium-high risk (55)
- 20-30% change: High risk (75)
- > 30% change: Very high risk (90)

## Integration Points (TODO)

To connect with backend API:

1. **Simulator Provider** (`simulator_provider.dart`):
   - Replace `_generateMockResult()` with actual API call
   - Use Dio client from `core/network/`
   - Handle API errors properly

2. **Asset Selection** (`what_if_screen.dart`):
   - Replace hardcoded dropdown items with actual portfolio assets
   - Fetch from portfolio provider or assets provider

3. **Backend Endpoint**:
   - POST `/api/simulations/run`
   - Request body:
     ```json
     {
       "type": "marketMove",
       "parameters": { "change_percent": -10 },
       "include_ai_analysis": true
     }
     ```
   - Response: `ScenarioResult` JSON

## Navigation

To navigate to the What-If screen from anywhere:

```dart
context.goNamed('what-if');
// or
context.go('/what-if');
```

## Usage Example

```dart
// From dashboard or AI chat
FilledButton(
  onPressed: () => context.goNamed('what-if'),
  child: const Text('Run What-If Simulation'),
)
```

## Architecture Compliance

✅ **Scream Architecture**: Feature-first structure  
✅ **Riverpod**: Using `@riverpod` generator syntax  
✅ **No setState abuse**: Only used for simple form state  
✅ **Theme-aware**: No hardcoded colors  
✅ **Form validation**: Proper validation with FormKey  
✅ **Error handling**: Try-catch with user feedback  
✅ **Async safety**: Mounted checks after async operations  
✅ **Const constructors**: Used where possible  

## Testing Checklist

- [ ] Navigate to What-If screen
- [ ] Select different scenario types
- [ ] Test Market Movement slider and presets
- [ ] Validate Buy/Sell form inputs
- [ ] Submit simulation and verify results display
- [ ] Check loading state
- [ ] Test error handling (when backend integrated)
- [ ] Verify AI analysis appears
- [ ] Check risk score calculation
- [ ] Test responsive behavior on different screens

## Next Steps

1. **Backend Integration**: Replace mock provider with real API calls
2. **Asset Selection**: Connect to actual portfolio assets
3. **New Asset Feature**: Implement add new asset scenario
4. **Rebalance Feature**: Implement portfolio rebalancing scenario
5. **Persistence**: Save simulation history
6. **Comparison**: Allow comparing multiple scenarios
7. **Export**: Add ability to export/share results
8. **Charts**: Add visual charts for projected vs current

## Estimated Time: ✅ Completed in ~2 hours

**User Story**: Part of US-7.7 - What-If Scenario Simulator

---

*Implementation Date: February 5, 2026*  
*Status: ✅ Ready for Testing*
