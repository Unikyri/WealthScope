/// Price Status Enum
/// Represents the current state of price data freshness
enum PriceStatus {
  /// Prices are current (< 5 minutes old)
  current,

  /// Prices are from cache (5-60 minutes old)
  cached,

  /// Prices are stale (> 1 hour old)
  stale,

  /// Market is currently closed
  marketClosed,
}
