/// Centralized plan limit constants for WealthScope subscription tiers.
///
/// Scout = Free tier, Sentinel = Premium tier.
class PlanLimits {
  PlanLimits._();

  // ---------------------------------------------------------------------------
  // Scout (Free) limits
  // ---------------------------------------------------------------------------
  static const int scoutMaxAssets = 15;
  static const int scoutMaxAiQueriesPerDay = 3;
  static const int scoutMaxOcrScansPerMonth = 1;

  // ---------------------------------------------------------------------------
  // Sentinel (Premium) limits
  // ---------------------------------------------------------------------------
  static const int sentinelMaxAiQueriesPerDay = 50;
  static const int sentinelMaxOcrScansPerMonth = 20;

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Returns the maximum number of assets for the given plan.
  /// -1 means unlimited.
  static int maxAssets(bool isPremium) =>
      isPremium ? -1 : scoutMaxAssets;

  /// Returns the maximum AI queries per day for the given plan.
  static int maxAiQueries(bool isPremium) =>
      isPremium ? sentinelMaxAiQueriesPerDay : scoutMaxAiQueriesPerDay;

  /// Returns the maximum OCR scans per month for the given plan.
  static int maxOcrScans(bool isPremium) =>
      isPremium ? sentinelMaxOcrScansPerMonth : scoutMaxOcrScansPerMonth;
}
