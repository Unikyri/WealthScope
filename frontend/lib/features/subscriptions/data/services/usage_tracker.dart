import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// Usage state
// ---------------------------------------------------------------------------

/// Immutable snapshot of the user's current usage counters.
class UsageState {
  final int aiQueriesUsedToday;
  final int ocrScansUsedThisMonth;

  const UsageState({
    required this.aiQueriesUsedToday,
    required this.ocrScansUsedThisMonth,
  });

  /// Default empty state with zero usage.
  static const UsageState empty = UsageState(
    aiQueriesUsedToday: 0,
    ocrScansUsedThisMonth: 0,
  );

  UsageState copyWith({
    int? aiQueriesUsedToday,
    int? ocrScansUsedThisMonth,
  }) {
    return UsageState(
      aiQueriesUsedToday: aiQueriesUsedToday ?? this.aiQueriesUsedToday,
      ocrScansUsedThisMonth:
          ocrScansUsedThisMonth ?? this.ocrScansUsedThisMonth,
    );
  }
}

// ---------------------------------------------------------------------------
// Usage tracker notifier
// ---------------------------------------------------------------------------

class UsageTrackerNotifier extends AsyncNotifier<UsageState> {
  static const _aiQueryCountKey = 'usage_ai_query_count';
  static const _aiQueryDateKey = 'usage_ai_query_date';
  static const _ocrScanCountKey = 'usage_ocr_scan_count';
  static const _ocrScanMonthKey = 'usage_ocr_scan_month';

  @override
  Future<UsageState> build() async {
    final prefs = await SharedPreferences.getInstance();
    return UsageState(
      aiQueriesUsedToday: _getAiQueriesForToday(prefs),
      ocrScansUsedThisMonth: _getOcrScansForMonth(prefs),
    );
  }

  // ---- AI queries (daily reset) -------------------------------------------

  int _getAiQueriesForToday(SharedPreferences prefs) {
    final savedDate = prefs.getString(_aiQueryDateKey);
    final today = _todayString();
    if (savedDate != today) {
      // New day -> reset counter
      prefs.setString(_aiQueryDateKey, today);
      prefs.setInt(_aiQueryCountKey, 0);
      return 0;
    }
    return prefs.getInt(_aiQueryCountKey) ?? 0;
  }

  /// Increments the daily AI query counter and persists it.
  Future<void> recordAiQuery() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _todayString();
    final savedDate = prefs.getString(_aiQueryDateKey);

    int count;
    if (savedDate != today) {
      count = 1;
      await prefs.setString(_aiQueryDateKey, today);
    } else {
      count = (prefs.getInt(_aiQueryCountKey) ?? 0) + 1;
    }
    await prefs.setInt(_aiQueryCountKey, count);
    state = AsyncData(
      state.value!.copyWith(aiQueriesUsedToday: count),
    );
  }

  // ---- OCR scans (monthly reset) ------------------------------------------

  int _getOcrScansForMonth(SharedPreferences prefs) {
    final savedMonth = prefs.getString(_ocrScanMonthKey);
    final currentMonth = _monthString();
    if (savedMonth != currentMonth) {
      prefs.setString(_ocrScanMonthKey, currentMonth);
      prefs.setInt(_ocrScanCountKey, 0);
      return 0;
    }
    return prefs.getInt(_ocrScanCountKey) ?? 0;
  }

  /// Increments the monthly OCR scan counter and persists it.
  Future<void> recordOcrScan() async {
    final prefs = await SharedPreferences.getInstance();
    final currentMonth = _monthString();
    final savedMonth = prefs.getString(_ocrScanMonthKey);

    int count;
    if (savedMonth != currentMonth) {
      count = 1;
      await prefs.setString(_ocrScanMonthKey, currentMonth);
    } else {
      count = (prefs.getInt(_ocrScanCountKey) ?? 0) + 1;
    }
    await prefs.setInt(_ocrScanCountKey, count);
    state = AsyncData(
      state.value!.copyWith(ocrScansUsedThisMonth: count),
    );
  }

  // ---- Helpers ------------------------------------------------------------

  static String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  static String _monthString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final usageTrackerProvider =
    AsyncNotifierProvider<UsageTrackerNotifier, UsageState>(
  UsageTrackerNotifier.new,
);
