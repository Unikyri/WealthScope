# 🔌 API Integrations Documentation

WealthScope integrates with **9 external APIs** to provide comprehensive market data coverage with automatic fallback mechanisms.

---

## Overview

| API | Category | Rate Limit | Authentication |
|-----|----------|------------|----------------|
| Alpha Vantage | Stocks/ETFs | 5/min | API Key |
| Finnhub | Stocks/Market | 60/min | API Key |
| CoinGecko | Crypto | 50/min | Optional API Key |
| Binance | Crypto | 1200/min | None |
| Frankfurter | Forex | Unlimited | None |
| ExchangeRate-API | Forex | 100/min | API Key |
| Metals-API | Precious Metals | 50/min | API Key |
| NewsData.io | News | 200/day | API Key |
| Marketaux | News | 100/day | API Key |

---

## 📈 Stocks & ETFs

### Alpha Vantage (Primary)

**Purpose:** Real-time and historical stock/ETF prices

**Configuration:**
```env
ALPHA_VANTAGE_API_KEY=your_api_key
```

**Endpoints Used:**
- `GLOBAL_QUOTE` - Real-time price quotes
- `TIME_SERIES_DAILY` - Historical daily data

**Rate Limit Strategy:**
- 5 calls/minute, 500 calls/day (free tier)
- Queue requests with exponential backoff
- Cache results for 5 minutes

**Error Handling:**
```go
if resp.Note != "" {
    // Rate limit exceeded, fallback to Finnhub
    return e.finnhubProvider.GetPrice(symbol)
}
```

---

### Finnhub (Fallback)

**Purpose:** Backup stock data provider with higher rate limits

**Configuration:**
```env
FINNHUB_API_KEY=your_api_key
```

**Endpoints Used:**
- `/quote` - Current price data
- `/stock/candle` - Historical OHLC data

**Rate Limit:** 60 calls/minute

---

## 🪙 Cryptocurrency

### CoinGecko (Primary)

**Purpose:** Cryptocurrency prices and market data

**Configuration:**
```env
COINGECKO_API_KEY=your_api_key  # Optional for higher limits
```

**Endpoints Used:**
- `/simple/price` - Current prices in multiple currencies
- `/coins/{id}/market_chart` - Historical data

**Rate Limit:** 50 calls/minute (free), 500/min (paid)

**Symbol Mapping:**
```go
var coinGeckoIDs = map[string]string{
    "BTC":  "bitcoin",
    "ETH":  "ethereum",
    "SOL":  "solana",
    "USDT": "tether",
}
```

---

### Binance (High-Frequency)

**Purpose:** Real-time crypto prices with very high rate limits

**Configuration:** No API key required for public endpoints

**Endpoints Used:**
- `/api/v3/ticker/price` - Current price
- `/api/v3/klines` - Candlestick data

**Rate Limit:** 1200 requests/minute

**Use Case:** High-frequency price updates, crypto trading views

---

## 💱 Forex / Currency

### Frankfurter (Primary)

**Purpose:** Free, reliable forex exchange rates

**Configuration:** No API key required

**Base URL:** `https://api.frankfurter.app`

**Endpoints Used:**
- `/latest?from=USD&to=EUR,GBP` - Current rates
- `/{date}?from=USD&to=EUR` - Historical rates

**Rate Limit:** Unlimited (fair use)

**Advantages:**
- No API key required
- European Central Bank data
- Free for commercial use

---

### ExchangeRate-API (Backup)

**Purpose:** Fallback forex provider with more currencies

**Configuration:**
```env
EXCHANGERATE_API_KEY=your_api_key
```

**Endpoints Used:**
- `/v6/{apiKey}/latest/USD` - All exchange rates

**Rate Limit:** 100/month (free), 30,000/month (paid)

---

## 🥇 Precious Metals

### Metals-API

**Purpose:** Gold, Silver, Platinum, and other metals pricing

**Configuration:**
```env
METALS_API_KEY=your_api_key
```

**Endpoints Used:**
- `/latest` - Current metal prices
- `/historical/{date}` - Historical prices

**Supported Metals:**
- XAU (Gold)
- XAG (Silver)
- XPT (Platinum)
- XPD (Palladium)

**Rate Limit:** 50 calls/month (free), 10,000/month (paid)

**Price Units:** Per troy ounce in USD

---

## 📰 Financial News

### NewsData.io (Primary)

**Purpose:** Financial and market news

**Configuration:**
```env
NEWSDATA_API_KEY=your_api_key
```

**Endpoints Used:**
- `/news` - Latest news articles

**Query Parameters:**
```
category=business
language=en
q=stocks OR crypto OR market
```

**Rate Limit:** 200 credits/day (free)

---

### Marketaux (Fallback)

**Purpose:** Market-focused news with stock symbols

**Configuration:**
```env
MARKETAUX_API_KEY=your_api_key
```

**Endpoints Used:**
- `/v1/news/all` - All market news

**Advantages:**
- Filters by stock symbols
- Sentiment analysis included
- Entity recognition

**Rate Limit:** 100 requests/day (free)

---

## 🔄 Fallback Logic

WealthScope implements automatic provider fallback:

```go
func (s *PricingService) GetPrice(symbol string, assetType string) (*Price, error) {
    // Try primary provider
    price, err := s.primaryProvider.GetPrice(symbol)
    if err == nil {
        return price, nil
    }
    
    // Log and try fallback
    s.logger.Warn("Primary provider failed, trying fallback",
        zap.String("symbol", symbol),
        zap.Error(err))
    
    return s.fallbackProvider.GetPrice(symbol)
}
```

### Provider Chain by Asset Type

| Asset Type | Primary | Fallback 1 | Fallback 2 |
|------------|---------|------------|------------|
| Stocks | Alpha Vantage | Finnhub | - |
| Crypto | CoinGecko | Binance | - |
| Forex | Frankfurter | ExchangeRate | - |
| Metals | Metals-API | Manual | - |
| News | NewsData.io | Marketaux | - |

---

## 🔐 Security Best Practices

1. **Never commit API keys** - Use `.env` files
2. **Rotate keys regularly** - Monthly rotation recommended
3. **Monitor usage** - Set up rate limit alerts
4. **Use server-side only** - Never expose keys to frontend

---

## 📊 Monitoring & Alerts

Track API health with these metrics:
- Request success rate
- Average response time
- Rate limit warnings
- Fallback activations

---

*Last updated: February 2026*
