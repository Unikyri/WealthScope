---
name: shadow-pricing
description: Guides implementation of the Shadow Pricing engine for valuing illiquid assets in WealthScope. Use when building real estate valuation, precious metals pricing, bond valuation, or AI-based estimation. Covers algorithms, data sources, and confidence scoring.
---

# Shadow Pricing Skill

## Overview

Shadow Pricing estimates the current market value of illiquid assets that don't have readily available market prices. This is WealthScope's key differentiator.

## Supported Asset Types

| Type | Primary Method | Fallback | Data Sources |
|------|----------------|----------|--------------|
| Real Estate | Comparable Sales | AI Estimation | Property APIs, market indices |
| Precious Metals | Spot Price | N/A | Commodity APIs |
| Bonds (unlisted) | DCF + Credit Spread | N/A | Yield curves |
| Art/Collectibles | AI Estimation | N/A | Auction data |

## Architecture

```go
// Shadow Pricing Engine Interface
type ShadowPricingEngine interface {
    Valuate(ctx context.Context, asset *Asset) (*ValuationResult, error)
}

type ValuationResult struct {
    EstimatedValue float64
    Confidence     float64
    Method         string
    Factors        map[string]any
    ValuationDate  time.Time
}

// Router dispatches to appropriate valuator
type PricingRouter struct {
    realEstate *RealEstateValuator
    metals     *MetalsValuator
    bonds      *BondValuator
    aiGeneric  *AIFallbackValuator
}

func (r *PricingRouter) Valuate(ctx context.Context, asset *Asset) (*ValuationResult, error) {
    switch asset.Type {
    case AssetTypeRealEstate:
        return r.realEstate.Valuate(ctx, asset)
    case AssetTypeGold:
        return r.metals.Valuate(ctx, asset)
    case AssetTypeBond:
        return r.bonds.Valuate(ctx, asset)
    default:
        return r.aiGeneric.Valuate(ctx, asset)
    }
}
```

## Real Estate Valuation

### Comparable Sales Method

```go
type RealEstateValuator struct {
    propertyAPI PropertyDataAPI
    gemini      *genai.Client
}

type PropertyInput struct {
    Address      string
    City         string
    Country      string
    PropertyType string  // residential, commercial, land
    AreaSQM      float64
    YearBuilt    int
    Condition    string  // excellent, good, fair, poor
    Features     []string
}

func (v *RealEstateValuator) Valuate(ctx context.Context, asset *Asset) (*ValuationResult, error) {
    input := extractPropertyInput(asset)
    
    // Step 1: Find comparable properties
    comps, err := v.propertyAPI.FindComparables(ctx, ComparableQuery{
        City:         input.City,
        PropertyType: input.PropertyType,
        AreaRange:    [2]float64{input.AreaSQM * 0.8, input.AreaSQM * 1.2},
        MaxAgeDays:   180,
        Limit:        10,
    })
    
    // If insufficient data, use AI fallback
    if len(comps) < 3 {
        return v.aiEstimate(ctx, asset)
    }
    
    // Step 2: Calculate weighted average price/sqm
    basePricePerSQM := v.calculateWeightedPrice(comps, input)
    
    // Step 3: Apply adjustments
    adjustments := v.calculateAdjustments(input, comps)
    adjustedPrice := basePricePerSQM
    for _, adj := range adjustments {
        adjustedPrice *= adj.Factor
    }
    
    // Step 4: Apply market trend
    trend := v.propertyAPI.GetMarketTrend(input.City)
    adjustedPrice *= (1 + trend.MonthlyChange)
    
    // Step 5: Calculate final value
    estimatedValue := adjustedPrice * input.AreaSQM
    confidence := v.calculateConfidence(len(comps), comps, adjustments)
    
    return &ValuationResult{
        EstimatedValue: estimatedValue,
        Confidence:     confidence,
        Method:         "comparable_sales",
        Factors: map[string]any{
            "comparables_count": len(comps),
            "price_per_sqm":     adjustedPrice,
            "adjustments":       adjustments,
            "market_trend":      trend.Direction,
        },
        ValuationDate: time.Now(),
    }, nil
}
```

### Adjustment Factors

```go
type Adjustment struct {
    Factor    string
    Value     float64  // multiplier: 1.05 = +5%
    Reasoning string
}

func (v *RealEstateValuator) calculateAdjustments(input PropertyInput, comps []Comparable) []Adjustment {
    adjustments := []Adjustment{}
    
    // Condition adjustment
    conditionFactors := map[string]float64{
        "excellent": 1.10,
        "good":      1.00,
        "fair":      0.92,
        "poor":      0.85,
    }
    if factor := conditionFactors[input.Condition]; factor != 1.0 {
        adjustments = append(adjustments, Adjustment{
            Factor:    "condition",
            Value:     factor,
            Reasoning: fmt.Sprintf("Property in %s condition", input.Condition),
        })
    }
    
    // Age adjustment
    avgAge := averageAge(comps)
    propertyAge := time.Now().Year() - input.YearBuilt
    if ageDiff := propertyAge - avgAge; ageDiff > 0 {
        factor := 1.0 - (float64(ageDiff) * 0.002)
        adjustments = append(adjustments, Adjustment{
            Factor:    "age",
            Value:     factor,
            Reasoning: fmt.Sprintf("%d years older than average comparable", ageDiff),
        })
    }
    
    // Feature premiums
    featurePremiums := map[string]float64{
        "pool":       1.05,
        "garage":     1.03,
        "garden":     1.02,
        "renovated":  1.08,
        "sea_view":   1.15,
        "city_view":  1.08,
    }
    for _, feature := range input.Features {
        if premium := featurePremiums[feature]; premium > 0 {
            adjustments = append(adjustments, Adjustment{
                Factor:    "feature_" + feature,
                Value:     premium,
                Reasoning: fmt.Sprintf("Property has %s", feature),
            })
        }
    }
    
    return adjustments
}
```

### Confidence Calculation

```go
func (v *RealEstateValuator) calculateConfidence(numComps int, comps []Comparable, adjs []Adjustment) float64 {
    // Base: more comparables = higher confidence
    baseConfidence := math.Min(float64(numComps)/5.0, 1.0) * 0.5
    
    // Penalty: high price variance in comparables
    variance := calculatePriceVariance(comps)
    variancePenalty := math.Min(variance/0.3, 0.2)
    
    // Penalty: many adjustments mean less comparable
    adjustmentPenalty := float64(len(adjs)) * 0.03
    
    // Boost: recent comparables
    recencyBoost := 0.0
    for _, c := range comps {
        if time.Since(c.SaleDate).Hours() < 24*30 {
            recencyBoost += 0.03
        }
    }
    recencyBoost = math.Min(recencyBoost, 0.15)
    
    confidence := baseConfidence + 0.35 - variancePenalty - adjustmentPenalty + recencyBoost
    return math.Max(0.3, math.Min(0.95, confidence))
}
```

## Precious Metals Valuation

```go
type MetalsValuator struct {
    commodityAPI CommodityPriceAPI
}

func (v *MetalsValuator) Valuate(ctx context.Context, asset *Asset) (*ValuationResult, error) {
    metadata := asset.Metadata.(MetalMetadata)
    
    // Get spot price
    spotPrice, err := v.commodityAPI.GetSpotPrice(ctx, metadata.MetalType)
    if err != nil {
        return nil, err
    }
    
    // Calculate pure metal value
    pureValue := spotPrice.PricePerOz * metadata.WeightOz * metadata.Purity
    
    // Apply form premium/discount
    formFactors := map[string]float64{
        "bar":     1.02,  // Small premium for bars
        "coin":    1.05,  // Premium for coins (collectible)
        "jewelry": 0.85,  // Discount for jewelry (melting cost)
        "scrap":   0.75,
    }
    formFactor := formFactors[metadata.Form]
    
    estimatedValue := pureValue * formFactor
    
    // High confidence for metals (liquid market)
    confidence := 0.95
    if metadata.Form == "jewelry" {
        confidence = 0.80  // More uncertainty in resale
    }
    
    return &ValuationResult{
        EstimatedValue: estimatedValue,
        Confidence:     confidence,
        Method:         "spot_price",
        Factors: map[string]any{
            "spot_price":   spotPrice.PricePerOz,
            "weight_oz":    metadata.WeightOz,
            "purity":       metadata.Purity,
            "form_factor":  formFactor,
        },
        ValuationDate: time.Now(),
    }, nil
}
```

## Bond Valuation (DCF)

```go
type BondValuator struct {
    yieldCurveAPI YieldCurveAPI
}

func (v *BondValuator) Valuate(ctx context.Context, asset *Asset) (*ValuationResult, error) {
    metadata := asset.Metadata.(BondMetadata)
    
    // Get yield curve
    yieldCurve, _ := v.yieldCurveAPI.GetCurve(ctx, "USD")
    
    // Time to maturity
    ttm := metadata.MaturityDate.Sub(time.Now()).Hours() / (24 * 365)
    
    // Discount rate = risk-free + credit spread
    riskFreeRate := yieldCurve.GetRate(ttm)
    creditSpread := getCreditSpread(metadata.CreditRating)
    discountRate := riskFreeRate + creditSpread
    
    // PV of coupon payments
    couponPayment := asset.PurchasePrice * metadata.CouponRate / float64(metadata.PaymentFreq)
    numPayments := int(ttm * float64(metadata.PaymentFreq))
    
    pvCoupons := 0.0
    for i := 1; i <= numPayments; i++ {
        pvCoupons += couponPayment / math.Pow(1+discountRate/float64(metadata.PaymentFreq), float64(i))
    }
    
    // PV of face value
    pvFace := asset.PurchasePrice / math.Pow(1+discountRate, ttm)
    
    estimatedValue := pvCoupons + pvFace
    
    return &ValuationResult{
        EstimatedValue: estimatedValue,
        Confidence:     0.85,
        Method:         "dcf",
        Factors: map[string]any{
            "risk_free_rate": riskFreeRate,
            "credit_spread":  creditSpread,
            "ttm_years":      ttm,
        },
        ValuationDate: time.Now(),
    }, nil
}

func getCreditSpread(rating string) float64 {
    spreads := map[string]float64{
        "AAA": 0.003, "AA": 0.005, "A": 0.008,
        "BBB": 0.015, "BB": 0.030, "B": 0.050,
    }
    if spread, ok := spreads[rating]; ok {
        return spread
    }
    return 0.020
}
```

## AI Fallback Valuation

```go
const aiValuationPrompt = `You are an expert asset valuator. Estimate the current market value.

Asset Details:
{{.AssetJSON}}

Provide valuation as JSON:
{
  "estimated_value": 125000.00,
  "confidence": 0.65,
  "currency": "USD",
  "methodology": "How you arrived at this value",
  "comparable_references": ["Reference 1", "Reference 2"],
  "risk_factors": ["Factor 1"],
  "value_range": {"low": 100000, "high": 150000}
}

Be conservative. If uncertain, reflect in lower confidence and wider range.`

func (v *AIFallbackValuator) Valuate(ctx context.Context, asset *Asset) (*ValuationResult, error) {
    assetJSON, _ := json.Marshal(asset)
    
    req := &genai.GenerateContentRequest{
        Model: "gemini-3.0-flash",
        Contents: []*genai.Content{
            {
                Role: "user",
                Parts: []*genai.Part{
                    {Text: strings.Replace(aiValuationPrompt, "{{.AssetJSON}}", string(assetJSON), 1)},
                    {Text: "Please provide your valuation."},
                },
            },
        },
        GenerationConfig: &genai.GenerationConfig{
            Temperature:     0.2,
            MaxOutputTokens: 800,
        },
    }
    
    resp, err := v.gemini.GenerateContent(ctx, req)
    if err != nil {
        return nil, fmt.Errorf("Gemini API error: %w", err)
    }
    
    // Parse response
    var aiResult AIValuationResponse
    json.Unmarshal([]byte(resp.Candidates[0].Content.Parts[0].Text), &aiResult)
    
    // Cap AI confidence at 0.75 (never fully trust AI-only)
    confidence := math.Min(aiResult.Confidence, 0.75)
    
    return &ValuationResult{
        EstimatedValue: aiResult.EstimatedValue,
        Confidence:     confidence,
        Method:         "ai_estimation",
        Factors:        aiResult,
        ValuationDate:  time.Now(),
    }, nil
}
```

## Scheduling Valuations

```go
func (s *ValuationScheduler) ScheduleDailyValuations() {
    s.cron.AddFunc("0 6 * * *", func() {  // 6 AM UTC daily
        ctx := context.Background()
        
        // Get assets needing valuation
        assets, _ := s.assetRepo.FindNeedingValuation(ctx, 24*time.Hour)
        
        for _, asset := range assets {
            // Skip listed assets (have market prices)
            if asset.IsListed() {
                continue
            }
            
            result, err := s.engine.Valuate(ctx, asset)
            if err != nil {
                s.logger.Error("Valuation failed", zap.Error(err))
                continue
            }
            
            // Save valuation history
            s.valuationRepo.Create(ctx, &AssetValuation{
                AssetID:        asset.ID,
                EstimatedValue: result.EstimatedValue,
                Confidence:     result.Confidence,
                Method:         result.Method,
                Factors:        result.Factors,
            })
            
            // Update asset's current value
            s.assetRepo.UpdateValue(ctx, asset.ID, result.EstimatedValue)
        }
    })
}
```

## Frontend Display

```dart
class ShadowPriceWidget extends StatelessWidget {
  final Asset asset;
  final ValuationResult? valuation;
  
  @override
  Widget build(BuildContext context) {
    if (valuation == null) {
      return const Text('Valuation pending...');
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              formatCurrency(valuation!.estimatedValue),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(width: 8),
            _ConfidenceBadge(confidence: valuation!.confidence),
          ],
        ),
        Text(
          'Shadow Pricing • ${valuation!.method}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        TextButton(
          onPressed: () => _showValuationDetails(context),
          child: const Text('View methodology'),
        ),
      ],
    );
  }
}

class _ConfidenceBadge extends StatelessWidget {
  final double confidence;
  
  Color get color {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.orange;
    return Colors.red;
  }
  
  String get label {
    if (confidence >= 0.8) return 'High';
    if (confidence >= 0.6) return 'Moderate';
    return 'Low';
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label (${(confidence * 100).toInt()}%)',
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }
}
```

## Key Implementation Notes

1. **Always show confidence** - Users must understand estimation uncertainty
2. **Explain methodology** - Show what factors influenced the valuation
3. **Update regularly** - Stale valuations lose trust
4. **Handle missing data gracefully** - Fall back to AI when APIs fail
5. **Cache API responses** - Property/commodity APIs have rate limits
6. **Allow manual override** - User knows their property best
