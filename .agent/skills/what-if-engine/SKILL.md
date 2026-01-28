---
name: what-if-engine
description: Guides implementation of the What-If scenario simulation engine in WealthScope. Use when building scenario analysis, portfolio impact calculations, or conversational financial simulations. Covers prompt engineering, result parsing, and UI presentation.
---

# What-If Engine Skill

## Overview

The What-If Engine allows users to ask natural language questions like "What happens to my portfolio if there's a recession?" and receive AI-powered simulations with projected impacts.

## Architecture

```
User Query → Query Classification → Context Building → AI Simulation → Result Parsing → Display
```

## Backend Implementation

### API Endpoint

```go
// POST /api/v1/scenarios/run
type RunScenarioRequest struct {
    Query      string         `json:"query" binding:"required,max=500"`
    Parameters map[string]any `json:"parameters,omitempty"`
}

type ScenarioResponse struct {
    ScenarioID       string          `json:"scenario_id"`
    Query            string          `json:"query"`
    Analysis         ScenarioAnalysis `json:"analysis"`
    Confidence       float64         `json:"confidence"`
    GeneratedAt      string          `json:"generated_at"`
}

type ScenarioAnalysis struct {
    Summary              string          `json:"summary"`
    CurrentValue         float64         `json:"current_value"`
    ProjectedValue       float64         `json:"projected_value"`
    ProjectedChange      float64         `json:"projected_change"`
    ProjectedChangePercent float64       `json:"projected_change_percent"`
    Timeframe            string          `json:"timeframe"`
    MostAffectedAssets   []AssetImpact   `json:"most_affected_assets"`
    HedgeSuggestions     []string        `json:"hedge_suggestions"`
    Assumptions          []string        `json:"assumptions"`
}

type AssetImpact struct {
    AssetID        string  `json:"asset_id"`
    Name           string  `json:"name"`
    CurrentValue   float64 `json:"current_value"`
    ProjectedValue float64 `json:"projected_value"`
    ChangePercent  float64 `json:"change_percent"`
    Reasoning      string  `json:"reasoning"`
}
```

### Scenario Service

```go
type ScenarioService struct {
    openai       *openai.Client
    portfolioSvc PortfolioService
    marketData   MarketDataService
    scenarioRepo ScenarioRepository
}

func (s *ScenarioService) RunScenario(ctx context.Context, userID uuid.UUID, query string) (*ScenarioResult, error) {
    // 1. Get user's portfolio
    portfolio, err := s.portfolioSvc.GetDetailed(ctx, userID)
    if err != nil {
        return nil, fmt.Errorf("failed to get portfolio: %w", err)
    }
    
    // 2. Classify the scenario type
    classification := s.classifyQuery(query)
    
    // 3. Get market context
    marketContext := s.marketData.GetContext(classification.Type)
    
    // 4. Build prompt
    prompt := s.buildPrompt(portfolio, query, marketContext)
    
    // 5. Call OpenAI
    resp, err := s.openai.CreateChatCompletion(ctx, openai.ChatCompletionRequest{
        Model:       "gpt-4o",
        Messages:    prompt,
        MaxTokens:   2000,
        Temperature: 0.3,
    })
    if err != nil {
        return nil, fmt.Errorf("AI request failed: %w", err)
    }
    
    // 6. Parse and validate response
    result, err := s.parseResponse(resp.Choices[0].Message.Content)
    if err != nil {
        return nil, fmt.Errorf("failed to parse response: %w", err)
    }
    
    // 7. Save scenario
    scenario := &Scenario{
        ID:         uuid.New(),
        UserID:     userID,
        Query:      query,
        Result:     result,
        CreatedAt:  time.Now(),
    }
    s.scenarioRepo.Create(ctx, scenario)
    
    return result, nil
}
```

### System Prompt

```go
const scenarioSystemPrompt = `You are a financial scenario simulator analyzing a user's investment portfolio.

USER'S PORTFOLIO:
{{.PortfolioJSON}}

ANALYSIS GUIDELINES:
1. Apply realistic market correlations based on historical data
2. Consider asset-specific sensitivities (beta, sector exposure)
3. Account for diversification effects
4. Provide confidence intervals when uncertainty is high
5. Explain reasoning for each asset's projected change

OUTPUT FORMAT (JSON):
{
  "summary": "2-3 sentence explanation of overall impact",
  "current_value": 125000.00,
  "projected_value": 106500.00,
  "projected_change": -18500.00,
  "projected_change_percent": -14.8,
  "timeframe": "6 months",
  "confidence": 0.75,
  "most_affected_assets": [
    {
      "asset_id": "uuid",
      "name": "AAPL",
      "current_value": 5000.00,
      "projected_value": 4000.00,
      "change_percent": -20.0,
      "reasoning": "Tech stocks typically decline 1.2x market in corrections"
    }
  ],
  "hedge_suggestions": [
    "Consider increasing gold allocation",
    "Treasury bonds may provide stability"
  ],
  "assumptions": [
    "Assumes scenario plays out over 6 months",
    "Does not account for dividend reinvestment"
  ]
}

IMPORTANT:
- Base projections on the user's ACTUAL holdings
- Be conservative with predictions
- Explain WHY each asset is affected
- Never suggest specific buy/sell actions
- Acknowledge limitations and uncertainty`
```

### Query Classification

```go
type ScenarioType string

const (
    ScenarioMarketCorrection ScenarioType = "market_correction"
    ScenarioSectorCrash      ScenarioType = "sector_crash"
    ScenarioInflation        ScenarioType = "inflation"
    ScenarioInterestRates    ScenarioType = "interest_rates"
    ScenarioCurrency         ScenarioType = "currency"
    ScenarioGeopolitical     ScenarioType = "geopolitical"
    ScenarioCustom           ScenarioType = "custom"
)

type ScenarioClassification struct {
    Type       ScenarioType
    Parameters map[string]any
    Timeframe  string
    Severity   string
}

func (s *ScenarioService) classifyQuery(query string) *ScenarioClassification {
    lowered := strings.ToLower(query)
    
    // Keyword-based classification (can be enhanced with AI)
    switch {
    case strings.Contains(lowered, "recession") || strings.Contains(lowered, "crash") || strings.Contains(lowered, "correction"):
        return &ScenarioClassification{
            Type:      ScenarioMarketCorrection,
            Severity:  extractSeverity(lowered),
            Timeframe: extractTimeframe(lowered),
        }
    case strings.Contains(lowered, "tech") && (strings.Contains(lowered, "crash") || strings.Contains(lowered, "drop")):
        return &ScenarioClassification{
            Type:       ScenarioSectorCrash,
            Parameters: map[string]any{"sector": "technology"},
        }
    case strings.Contains(lowered, "inflation"):
        return &ScenarioClassification{
            Type:       ScenarioInflation,
            Parameters: map[string]any{"rate": extractPercentage(lowered)},
        }
    case strings.Contains(lowered, "interest rate") || strings.Contains(lowered, "fed"):
        return &ScenarioClassification{
            Type: ScenarioInterestRates,
        }
    default:
        return &ScenarioClassification{
            Type: ScenarioCustom,
        }
    }
}
```

### Predefined Scenario Templates

```go
// GET /api/v1/scenarios/templates
var predefinedScenarios = []ScenarioTemplate{
    {
        ID:          "recession",
        Name:        "Economic Recession",
        Description: "Simulates a typical recession with 30% equity decline over 12 months",
        Query:       "What if there's a recession with a 30% stock market decline?",
    },
    {
        ID:          "inflation_surge",
        Name:        "High Inflation",
        Description: "Simulates 8%+ annual inflation and its impact on different asset classes",
        Query:       "What if inflation rises to 8% annually?",
    },
    {
        ID:          "tech_crash",
        Name:        "Tech Sector Crash",
        Description: "Simulates a 40% decline in technology stocks",
        Query:       "What if technology stocks crash 40%?",
    },
    {
        ID:          "rate_hike",
        Name:        "Interest Rate Hike",
        Description: "Simulates Fed raising rates by 1%",
        Query:       "What if the Federal Reserve raises interest rates by 1%?",
    },
    {
        ID:          "dollar_weakness",
        Name:        "Dollar Weakness",
        Description: "Simulates 15% USD depreciation against major currencies",
        Query:       "What if the US dollar weakens 15%?",
    },
}
```

## Frontend Implementation

### Scenario Input Screen

```dart
class ScenarioScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ScenarioScreen> createState() => _ScenarioScreenState();
}

class _ScenarioScreenState extends ConsumerState<ScenarioScreen> {
  final _controller = TextEditingController();
  bool _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('What-If Scenarios')),
      body: Column(
        children: [
          // Query input
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'What if there\'s a recession?',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: _startVoiceInput,
                ),
              ),
              maxLines: 2,
              onSubmitted: (_) => _runScenario(),
            ),
          ),
          
          // Quick scenario chips
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _QuickScenarioChip(
                  label: 'Recession',
                  onTap: () => _setQuery('What if there\'s a recession?'),
                ),
                _QuickScenarioChip(
                  label: 'Tech Crash',
                  onTap: () => _setQuery('What if tech stocks crash 40%?'),
                ),
                _QuickScenarioChip(
                  label: 'High Inflation',
                  onTap: () => _setQuery('What if inflation rises to 8%?'),
                ),
              ],
            ),
          ),
          
          const Divider(),
          
          // Results or history
          Expanded(
            child: _isLoading
                ? const _LoadingAnimation()
                : _buildContent(),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _runScenario,
            child: const Text('Run Scenario'),
          ),
        ),
      ),
    );
  }
  
  Future<void> _runScenario() async {
    if (_controller.text.isEmpty) return;
    
    setState(() => _isLoading = true);
    
    try {
      final result = await ref.read(scenarioProvider).run(_controller.text);
      
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ScenarioResultScreen(result: result),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
```

### Scenario Results Screen

```dart
class ScenarioResultScreen extends StatelessWidget {
  final ScenarioResult result;
  
  const ScenarioResultScreen({required this.result, super.key});
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNegative = result.projectedChangePercent < 0;
    
    return Scaffold(
      appBar: AppBar(title: const Text('Scenario Analysis')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(result.query, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 16),
                  Text(result.summary),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Impact visualization
          _ImpactCard(
            currentValue: result.currentValue,
            projectedValue: result.projectedValue,
            changePercent: result.projectedChangePercent,
            timeframe: result.timeframe,
          ),
          
          const SizedBox(height: 16),
          
          // Most affected assets
          Text('Most Affected Assets', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          ...result.mostAffectedAssets.map((asset) => _AssetImpactCard(
            asset: asset,
          )),
          
          const SizedBox(height: 16),
          
          // Hedge suggestions
          if (result.hedgeSuggestions.isNotEmpty) ...[
            Text('Hedge Suggestions', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ...result.hedgeSuggestions.map((s) => ListTile(
              leading: const Icon(Icons.lightbulb_outline),
              title: Text(s),
            )),
          ],
          
          const SizedBox(height: 16),
          
          // Confidence indicator
          _ConfidenceIndicator(confidence: result.confidence),
          
          // Assumptions
          ExpansionTile(
            title: const Text('Assumptions'),
            children: result.assumptions.map((a) => ListTile(
              leading: const Icon(Icons.info_outline, size: 16),
              title: Text(a, style: theme.textTheme.bodySmall),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
```

### Impact Visualization

```dart
class _ImpactCard extends StatelessWidget {
  final double currentValue;
  final double projectedValue;
  final double changePercent;
  final String timeframe;
  
  @override
  Widget build(BuildContext context) {
    final isNegative = changePercent < 0;
    final color = isNegative ? Colors.red : Colors.green;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ValueColumn(
                  label: 'Current',
                  value: currentValue,
                ),
                Icon(
                  Icons.arrow_forward,
                  color: color,
                ),
                _ValueColumn(
                  label: 'Projected',
                  value: projectedValue,
                  color: color,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${changePercent >= 0 ? '+' : ''}${changePercent.toStringAsFixed(1)}% over $timeframe',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Key Implementation Notes

1. **Always include confidence scores** - Users should understand uncertainty
2. **Explain reasoning** - Not just numbers, but WHY assets are affected
3. **Provide actionable insights** - Hedge suggestions, not just doom
4. **Cache results** - Same query for same portfolio = same result
5. **Rate limit AI calls** - These are expensive
6. **Include disclaimer** - This is not financial advice
