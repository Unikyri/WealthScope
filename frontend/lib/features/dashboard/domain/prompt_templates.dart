/// Bank of prompt templates by asset type.
/// Variables: {symbol}, {company} (company = asset name when no symbol), {type}.
class PromptTemplates {
  PromptTemplates._();

  static const Map<String, List<String>> byType = {
    'crypto': [
      'What happens if Bitcoin drops 30%?',
      'Should I DCA into {symbol}?',
      'Is now a good time to sell {symbol}?',
      'How can I protect my crypto gains?',
      'How can I reduce my crypto exposure?',
    ],
    'stock': [
      "What's the outlook for {company}?",
      'Should I diversify outside tech stocks?',
      'How do interest rates affect my stocks?',
      'What if I sell {symbol}?',
    ],
    'etf': [
      'How diversified is my ETF allocation?',
      'Should I rebalance my {symbol} position?',
      'What if I sell {symbol}?',
      'How do ETFs fit in my portfolio?',
    ],
    'gold': [
      'Is gold a good hedge for my portfolio?',
      'Should I increase my gold position?',
      'How does gold protect against inflation?',
      'What if I add more gold?',
    ],
    'bond': [
      'How do interest rates affect my bonds?',
      'What is the duration risk of my bonds?',
      'Should I rebalance my bond allocation?',
      'How do bonds fit in my portfolio?',
    ],
    'real_estate': [
      'How does real estate fit in my portfolio?',
      'Should I add more real estate?',
      'What is the risk of my real estate exposure?',
    ],
    'cash': [
      'Am I holding too much cash?',
      'What should I do with my cash reserves?',
    ],
    'other': [
      'How does this asset fit in my portfolio?',
      'Should I rebalance my holdings?',
    ],
  };

  static const List<String> concentration = [
    'How can I reduce my concentration in {type}?',
    'Am I too concentrated? How do I diversify?',
  ];

  static const List<String> diversification = [
    'How can I diversify my portfolio?',
    'What asset classes am I missing?',
  ];

  static const List<String> general = [
    "What's my current risk exposure?",
    'How diversified is my portfolio?',
    'Summarize my portfolio performance',
  ];

  /// Default onboarding prompts when user has no assets.
  static const List<String> defaultPrompts = [
    'How do I start investing?',
    'What assets should I buy first?',
    'Explain portfolio diversification',
    'What is a good beginner portfolio?',
    'How much should I invest monthly?',
  ];

  /// Substitutes {symbol}, {company}, {type} in template.
  /// Removes any remaining placeholders and trims.
  static String substitute(
    String template, {
    String? symbol,
    String? company,
    String? type,
  }) {
    var result = template;
    if (symbol != null && symbol.isNotEmpty) {
      result = result.replaceAll('{symbol}', symbol);
    }
    if (company != null && company.isNotEmpty) {
      result = result.replaceAll('{company}', company);
    }
    if (type != null && type.isNotEmpty) {
      result = result.replaceAll('{type}', type);
    }
    result = result.replaceAll(RegExp(r'\{[^}]+\}'), '').trim();
    return result;
  }
}
