import 'dart:math';

/// Lightweight data class representing an asset for prompt generation.
/// Decoupled from StockAsset to keep PromptGenerator framework-agnostic.
class AssetInfo {
  final String name;
  final String symbol;
  final String type;
  final double totalValue;

  const AssetInfo({
    required this.name,
    required this.symbol,
    required this.type,
    required this.totalValue,
  });
}

/// Lightweight data class representing a portfolio type breakdown.
class TypeBreakdown {
  final String type;
  final double percent;

  const TypeBreakdown({
    required this.type,
    required this.percent,
  });
}

/// Generates contextual AI prompts based on the user's portfolio composition.
///
/// Pure utility class with no Flutter dependencies. Produces 5-8 prompts
/// tailored to the user's assets, diversification gaps, and concentration risks.
class PromptGenerator {
  PromptGenerator._();

  static final _random = Random();

  /// Known asset types for diversification gap analysis.
  static const _commonTypes = {'stock', 'crypto', 'bond', 'gold', 'etf'};

  /// Generates contextual prompts based on user assets and breakdown.
  ///
  /// Returns 5-8 prompts. The first 2 are always the most relevant
  /// (what-if on highest-value assets), the rest are shuffled for variety.
  static List<String> generate({
    required List<AssetInfo> assets,
    required List<TypeBreakdown> breakdown,
  }) {
    if (assets.isEmpty) return defaultPrompts();

    final prompts = <String>[];

    // 1. What-If prompts for top 2-3 assets by value
    _addWhatIfPrompts(prompts, assets);

    // 2. Diversification gap prompts
    _addDiversificationPrompts(prompts, breakdown);

    // 3. Concentration risk prompts
    _addConcentrationPrompts(prompts, breakdown);

    // 4. General risk & performance prompts
    _addGeneralPrompts(prompts);

    // Keep first 2 (most relevant), shuffle the rest for variety
    if (prompts.length > 2) {
      final top = prompts.take(2).toList();
      final rest = prompts.skip(2).toList()..shuffle(_random);
      prompts
        ..clear()
        ..addAll(top)
        ..addAll(rest);
    }

    // Cap at 8 prompts max
    return prompts.take(8).toList();
  }

  /// Default onboarding prompts when user has no assets.
  static List<String> defaultPrompts() {
    return const [
      'How do I start investing?',
      'What assets should I buy first?',
      'Explain portfolio diversification',
      'What is a good beginner portfolio?',
      'How much should I invest monthly?',
    ];
  }

  /// Adds what-if prompts for the user's highest-value assets.
  static void _addWhatIfPrompts(List<String> prompts, List<AssetInfo> assets) {
    final sorted = List<AssetInfo>.from(assets)
      ..sort((a, b) => b.totalValue.compareTo(a.totalValue));

    final topAssets = sorted.take(3);
    for (final asset in topAssets) {
      final symbol = asset.symbol.isNotEmpty ? asset.symbol : asset.name;
      prompts.add('What if I sell $symbol?');
    }

    // Add a "double position" prompt for the #1 asset
    if (sorted.isNotEmpty) {
      final top = sorted.first;
      final symbol = top.symbol.isNotEmpty ? top.symbol : top.name;
      prompts.add('What if I double my $symbol position?');
    }
  }

  /// Adds prompts about missing asset types for diversification.
  static void _addDiversificationPrompts(
      List<String> prompts, List<TypeBreakdown> breakdown) {
    final ownedTypes = breakdown.map((b) => b.type.toLowerCase()).toSet();
    final missing = _commonTypes.difference(ownedTypes);

    final suggestions = <String, String>{
      'gold': 'Should I add gold to hedge inflation?',
      'bond': 'Would bonds reduce my portfolio risk?',
      'crypto': 'Is crypto a good addition to my portfolio?',
      'etf': 'Should I invest in ETFs for diversification?',
      'stock': 'Should I add stocks to my portfolio?',
    };

    for (final type in missing) {
      if (suggestions.containsKey(type)) {
        prompts.add(suggestions[type]!);
      }
    }
  }

  /// Adds prompts about concentration risk when one type dominates.
  static void _addConcentrationPrompts(
      List<String> prompts, List<TypeBreakdown> breakdown) {
    for (final item in breakdown) {
      if (item.percent > 50) {
        final label = item.type[0].toUpperCase() + item.type.substring(1);
        prompts.add('Am I too concentrated in $label?');
        break; // Only one concentration prompt
      }
    }
  }

  /// Adds general risk and performance prompts.
  static void _addGeneralPrompts(List<String> prompts) {
    final general = [
      "What's my current risk exposure?",
      'How diversified is my portfolio?',
      'Summarize my portfolio performance',
    ];

    // Pick 1-2 random general prompts to avoid bloat
    general.shuffle(_random);
    prompts.addAll(general.take(2));
  }
}
