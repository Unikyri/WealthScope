# Mock Audit Report - US-18.3

**Date**: 2026-02-10  
**Sprint**: EPIC-18 - App Branding, Polish & Production Readiness  
**Related Issues**: #486, #494, #495, #496

## Summary

This document tracks the audit and removal of mock data across the WealthScope frontend, as part of the Real Prices audit (US-18.3).

---

## 1. Eliminated / Refactored (T-18.3.1)

| Location | Before | After |
|----------|--------|-------|
| **dashboard_screen.dart** | Avatar: `ui-avatars.com` URL; Greeting: "Good Morning" hardcoded | Avatar: `CircleAvatar` with user initial; Greeting: `getTimeBasedGreeting()` (Good Morning/Afternoon/Evening/Night) |
| **crypto_net_worth_hero.dart** | `historyData = [10, 15, 13, 20, ...]` fake sparkline | `historyData = []` (empty until backend provides history) |
| **briefing_screen.dart** | "Good Morning" hardcoded | Uses `getTimeBasedGreeting()` |
| **briefing_bottom_sheet.dart** | "Good Morning" hardcoded | Uses `getTimeBasedGreeting()` |
| **news_provider.dart** | `_getMockArticles`, `_generateMockData` | Uses `NewsRemoteDatasource` → GET /news, /news/search, /news/trending. Empty on API failure. |
| **portfolio_history_provider.dart** | `_generateMockData(period)` fake chart data | Returns `[]`. Chart shows "No historical data available". |

---

## 2. Mocks Requiring Backend / Future Work

| Provider / Location | Status | Action Required |
|---------------------|--------|-----------------|
| **performance_provider.dart** | Mock | Backend has no `/portfolio/performance` or equivalent. `_generateMockPerformance()` returns fake metrics. Document only; consider empty state or disable view. |
| **stock_form_provider.dart** | Mock | `mockSymbols` list for symbol search. Need backend symbol search endpoint (Yahoo/Alpha Vantage) or frontend direct API. |
| **simulator_provider.dart** | Mock | `_generateMockResult` for What-If. Backend has `/ai/scenarios/run` - integration pending. |
| **gold_form_provider.dart** | Placeholder | `goldPricePerOz = 2000.0` in `calculateCurrentValue()`. Backend has MetalPriceAPI - needs integration. |
| **currency_converter.dart** | Mock | `_exchangeRates` static map. Backend has Frankfurter - needs integration or dedicated FX endpoint. |
| **asset_performance_grid.dart** | Mock | "mock if null" comment - verify datasource. |
| **asset_history_chart.dart** | Mock | "mock logic" - verify datasource for price history. |
| **news_screen.dart** | Mock | `_getRelatedSymbols`, `_getSentiment` - check if still used after news provider refactor. |
| **ai_command_center_screen.dart** | Mock | "Simple Bar Chart Mock" - replace with real data when available. |

---

## 3. Price Flow Verification (T-18.3.2)

### Backend → Frontend Data Flow

| Screen | Data Source | Verification |
|--------|-------------|--------------|
| Dashboard Total Value | `dashboardPortfolioSummaryProvider` → `summary.totalValue` | ✅ From `/portfolio/summary` |
| Asset List | `allAssetsProvider` → `currentPrice`, `totalValue`, `gainLossPercent` | ✅ From `/assets` |
| Asset Detail | `assetDetailProvider` → `asset.currentPrice`, etc. | ✅ From `/assets/:id` |
| Top Movers | `allAssetsProvider` (sorted) | ✅ Uses real `gainLossPercent` |
| Donut Chart | `summary.breakdownByType` | ✅ From portfolio summary |
| CryptoNetWorthHero | `historyData` | ✅ Now `[]` when no backend history; no fake data |

### Backend APIs for Prices

- **Yahoo Finance**, **CoinGecko**, **Binance**, **Frankfurter**, **MetalPriceAPI** in `backend/internal/infrastructure/marketdata/`
- **pricing_service.go** aggregates prices
- Assets and portfolio summary include `updated_at` / `last_updated`

---

## 4. Price Freshness Indicator (T-18.3.3)

- Widget `PriceFreshnessIndicator` to be implemented in `frontend/lib/shared/widgets/`
- Integrate in `CryptoNetWorthHero` (dashboard) and `asset_detail_screen.dart`
- Use `summary.lastUpdated` and `asset.updatedAt` from API
- Scout vs Sentinel: Scout shows "Delayed 15 min" / "Al cierre"; Sentinel shows relative time

---

## 5. Helper Utilities Added

- **greeting_utils.dart**: `getTimeBasedGreeting()` for time-of-day greeting (06-12 Morning, 12-18 Afternoon, 18-22 Evening, 22-06 Night)

---

## Changelog

- 2026-02-10: Initial audit; eliminated visible mocks (avatar, greeting, sparkline, news, portfolio history); documented remaining mocks.
