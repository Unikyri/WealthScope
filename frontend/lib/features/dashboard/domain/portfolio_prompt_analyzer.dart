import 'dart:math';

import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_risk.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';
import 'package:wealthscope_app/features/dashboard/domain/prompt_templates.dart';

/// Lightweight data class representing an asset for prompt generation.
/// Decoupled from StockAsset to keep the analyzer framework-agnostic.
class AssetInfo {
  const AssetInfo({
    required this.name,
    required this.symbol,
    required this.type,
    required this.totalValue,
  });

  final String name;
  final String symbol;
  final String type;
  final double totalValue;
}

/// Analyzes portfolio composition and risk to generate contextual AI prompts.
class PortfolioPromptAnalyzer {
  PortfolioPromptAnalyzer._();

  /// Generates contextual prompts based on assets, breakdown, and risk.
  static List<String> analyze({
    required List<AssetInfo> assets,
    required List<AssetTypeBreakdown> breakdown,
    required PortfolioRisk risk,
  }) {
    if (assets.isEmpty) {
      return PromptTemplates.defaultPrompts;
    }

    final prompts = <String>[];

    // 1. High concentration (>70%): use top type from breakdown
    final sortedBreakdown = List<AssetTypeBreakdown>.from(breakdown)
      ..sort((a, b) => b.percent.compareTo(a.percent));
    if (sortedBreakdown.isNotEmpty && sortedBreakdown.first.percent > 70) {
      final top = sortedBreakdown.first;
      final typeLabel = _typeLabel(top.type);
      prompts.add(PromptTemplates.substitute(
        PromptTemplates.concentration.first,
        type: typeLabel,
      ));
    }

    // 2. riskScore > 70: poorly diversified portfolio
    if (risk.riskScore > 70) {
      prompts.add(PromptTemplates.diversification.first);
    }

    // 3. What-if for top 3 assets by value
    final sorted = List<AssetInfo>.from(assets)
      ..sort((a, b) => b.totalValue.compareTo(a.totalValue));
    for (final asset in sorted.take(3)) {
      final symbol = asset.symbol.isNotEmpty ? asset.symbol : asset.name;
      prompts.add('What if I sell $symbol?');
    }

    // 4. Templates for present asset types
    for (final b in breakdown) {
      final type = _normalizeType(b.type);
      if (PromptTemplates.byType.containsKey(type)) {
        final templates = PromptTemplates.byType[type]!;
        AssetInfo? asset;
        for (final a in assets) {
          if (_normalizeType(a.type) == type) {
            asset = a;
            break;
          }
        }
        final sym = asset?.symbol ?? '';
        final company = asset?.name ?? _typeLabel(type);
        for (final t in templates.take(1)) {
          final substituted =
              PromptTemplates.substitute(t, symbol: sym, company: company);
          if (substituted.isNotEmpty && !prompts.contains(substituted)) {
            prompts.add(substituted);
          }
        }
      }
    }

    // 5. Missing types (diversification)
    final ownedTypes =
        breakdown.map((b) => _normalizeType(b.type)).toSet();
    final allTypes = PromptTemplates.byType.keys.toSet();
    final missing = allTypes.difference(ownedTypes);
    for (final type in missing.take(2)) {
      prompts.add('Should I invest in ${_typeLabel(type)}?');
    }

    // 6. General (1-2)
    prompts.addAll(PromptTemplates.general.take(2));

    return prompts;
  }

  /// Selects [count] prompts from candidates with daily seed for variety.
  /// Candidates are shuffled so each day/session shows a different set.
  static List<String> selectPrompts(List<String> candidates, {int count = 6}) {
    if (candidates.isEmpty) return PromptTemplates.defaultPrompts;
    if (candidates.length <= count) return candidates;
    final seed = DateTime.now().day;
    final shuffled = List<String>.from(candidates)..shuffle(Random(seed));
    return shuffled.take(count).toList();
  }

  static String _normalizeType(String type) {
    return type.toLowerCase().replaceAll(' ', '_');
  }

  static String _typeLabel(String type) {
    final normalized = _normalizeType(type);
    final labels = {
      'crypto': 'Crypto',
      'stock': 'Stocks',
      'etf': 'ETFs',
      'bond': 'Bonds',
      'gold': 'Gold',
      'real_estate': 'Real Estate',
      'cash': 'Cash',
      'other': 'Other',
    };
    return labels[normalized] ??
        (type.isNotEmpty ? '${type[0].toUpperCase()}${type.substring(1)}' : '');
  }
}
