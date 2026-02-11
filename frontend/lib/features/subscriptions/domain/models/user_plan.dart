/// Represents the user's current subscription plan in WealthScope.
///
/// - [scout]: Free tier with limited features.
/// - [sentinel]: Premium tier ($4.99/month) with full access.
enum UserPlan {
  scout('Scout', 'Free'),
  sentinel('Sentinel', 'Premium');

  const UserPlan(this.displayName, this.tier);

  /// Human-readable plan name (e.g. "Scout", "Sentinel").
  final String displayName;

  /// Tier label (e.g. "Free", "Premium").
  final String tier;

  /// Whether this plan has premium (Sentinel) access.
  bool get isPremium => this == UserPlan.sentinel;
}
