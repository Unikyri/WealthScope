import 'package:flutter/material.dart';
import 'package:wealthscope_app/features/subscriptions/domain/plan_limits.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/usage_tracker.dart';

// ---------------------------------------------------------------------------
// Gate result
// ---------------------------------------------------------------------------

/// Result of a feature gate check.
///
/// If [allowed] is true the user can proceed.
/// If false, [deniedTitle], [deniedMessage] and [deniedIcon] carry the
/// information needed to display an upgrade prompt.
class GateResult {
  final bool allowed;
  final String? deniedTitle;
  final String? deniedMessage;
  final IconData? deniedIcon;

  const GateResult.allowed()
      : allowed = true,
        deniedTitle = null,
        deniedMessage = null,
        deniedIcon = null;

  const GateResult.denied({
    required this.deniedTitle,
    required this.deniedMessage,
    this.deniedIcon,
  }) : allowed = false;
}

// ---------------------------------------------------------------------------
// Centralized feature gating service
// ---------------------------------------------------------------------------

/// Encapsulates **all** plan-based feature gating logic for WealthScope.
///
/// Instantiated via [featureGateProvider] which watches [isPremiumProvider]
/// and [usageTrackerProvider], so consumers get a synchronous API:
///
/// ```dart
/// final gate = ref.watch(featureGateProvider);
/// final result = gate.canSendAiQuery();
/// if (!result.allowed) showGatePrompt(context, result);
/// ```
class FeatureGateService {
  final bool isPremium;
  final UsageState usage;

  const FeatureGateService({
    required this.isPremium,
    required this.usage,
  });

  // ---- Assets --------------------------------------------------------------

  /// Whether the user can add a new asset given their current [currentCount].
  GateResult canAddAsset(int currentCount) {
    final max = PlanLimits.maxAssets(isPremium);
    if (max == -1) return const GateResult.allowed(); // unlimited
    if (currentCount < max) return const GateResult.allowed();
    return GateResult.denied(
      deniedTitle: 'Asset Limit Reached',
      deniedMessage:
          'Scout plan allows up to $max assets. '
          'Upgrade to Sentinel for unlimited assets.',
      deniedIcon: Icons.inventory_2_outlined,
    );
  }

  // ---- AI Chat -------------------------------------------------------------

  /// Whether the user can send another AI query today.
  GateResult canSendAiQuery() {
    if (usage.aiQueriesUsedToday < maxAiQueries) {
      return const GateResult.allowed();
    }
    return GateResult.denied(
      deniedTitle: 'Daily AI Limit Reached',
      deniedMessage:
          'You\'ve used all $maxAiQueries AI queries for today. '
          '${isPremium ? 'Your limit resets tomorrow.' : 'Upgrade to Sentinel for 50 queries/day.'}',
      deniedIcon: Icons.psychology_outlined,
    );
  }

  /// How many AI queries the user has left today.
  int get aiQueriesRemaining =>
      (maxAiQueries - usage.aiQueriesUsedToday).clamp(0, maxAiQueries);

  /// Maximum AI queries per day for the user's plan.
  int get maxAiQueries => PlanLimits.maxAiQueries(isPremium);

  // ---- What-If Engine ------------------------------------------------------

  /// Whether the user can access the What-If simulation engine.
  GateResult canUseWhatIf() {
    if (isPremium) return const GateResult.allowed();
    return const GateResult.denied(
      deniedTitle: 'Sentinel Feature',
      deniedMessage:
          'The What-If simulation engine is available exclusively for '
          'Sentinel members. Upgrade to unlock scenario analysis.',
      deniedIcon: Icons.science_outlined,
    );
  }

  // ---- OCR / Document Scanning ---------------------------------------------

  /// Whether the user can scan another document this month.
  GateResult canScanDocument() {
    if (usage.ocrScansUsedThisMonth < maxOcrScans) {
      return const GateResult.allowed();
    }
    return GateResult.denied(
      deniedTitle: 'Monthly OCR Limit Reached',
      deniedMessage:
          'You\'ve used all $maxOcrScans OCR scans this month. '
          '${isPremium ? 'Your limit resets next month.' : 'Upgrade to Sentinel for 20 scans/month.'}',
      deniedIcon: Icons.document_scanner_outlined,
    );
  }

  /// How many OCR scans the user has left this month.
  int get ocrScansRemaining =>
      (maxOcrScans - usage.ocrScansUsedThisMonth).clamp(0, maxOcrScans);

  /// Maximum OCR scans per month for the user's plan.
  int get maxOcrScans => PlanLimits.maxOcrScans(isPremium);

  // ---- Premium Asset Types -------------------------------------------------

  /// Whether the user can use a premium-only asset type.
  GateResult canUsePremiumAssetType(String typeName) {
    if (isPremium) return const GateResult.allowed();
    if (!PlanLimits.premiumAssetTypes.contains(typeName)) {
      return const GateResult.allowed();
    }
    return GateResult.denied(
      deniedTitle: 'Premium Asset Type',
      deniedMessage:
          'Adding ${_formatTypeName(typeName)} assets requires the Sentinel plan. '
          'Upgrade to access advanced asset tracking.',
      deniedIcon: Icons.workspace_premium_outlined,
    );
  }

  // ---- Model info ----------------------------------------------------------

  /// Label for the AI model tier the user has access to.
  String get aiModelLabel => isPremium ? 'Pro \u2022 Thinking Mode' : 'Standard';

  // ---- Helpers -------------------------------------------------------------

  static String _formatTypeName(String name) {
    return name
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }
}
