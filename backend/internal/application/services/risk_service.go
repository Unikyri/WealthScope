package services

import (
	"encoding/json"
	"fmt"
	"math"
	"strings"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
)

const (
	SectorConcentrationWarning  = 40.0
	SectorConcentrationCritical = 70.0

	GeoConcentrationInfo    = 60.0
	GeoConcentrationWarning = 80.0
)

type RiskAlert struct {
	Type      string  `json:"type"`
	Severity  string  `json:"severity"` // info, warning, critical
	Title     string  `json:"title"`
	Message   string  `json:"message"`
	Value     float64 `json:"value"`
	Threshold float64 `json:"threshold"`
}

//nolint:govet // fieldalignment: keep response DTO readable and stable
type PortfolioRisk struct {
	DiversificationLevel string      `json:"diversification_level"`
	Alerts               []RiskAlert `json:"alerts"`
	RiskScore            int         `json:"risk_score"`
}

type RiskService struct{}

func NewRiskService() *RiskService { return &RiskService{} }

func (s *RiskService) AnalyzePortfolio(assets []entities.Asset) PortfolioRisk {
	totalValue := 0.0
	for i := range assets {
		totalValue += assets[i].TotalValue()
	}
	if totalValue <= 0 {
		return PortfolioRisk{
			Alerts:               []RiskAlert{},
			RiskScore:            0,
			DiversificationLevel: "good",
		}
	}

	alerts := make([]RiskAlert, 0, 4)
	alerts = append(alerts, s.checkSectorConcentration(assets, totalValue)...)
	alerts = append(alerts, s.checkGeographicConcentration(assets, totalValue)...)

	// Concentration score: max single-entity percentage across dimensions.
	maxPct := math.Max(s.maxSectorPercent(assets, totalValue), s.maxGeoPercent(assets, totalValue))
	concentrationScore := int(math.Round(clamp(maxPct, 0, 100)))

	// Diversification level considers both concentration AND asset type variety.
	// A portfolio with many asset types is better diversified even if concentrated in one sector.
	level := s.diversificationLevel(assets, concentrationScore)

	return PortfolioRisk{
		Alerts:               alerts,
		RiskScore:            concentrationScore,
		DiversificationLevel: level,
	}
}

func (s *RiskService) checkSectorConcentration(assets []entities.Asset, totalValue float64) []RiskAlert {
	sectorValues := make(map[string]float64)
	for i := range assets {
		sector := getMetadataString(assets[i].ExtendedData, "sector")
		if sector == "" {
			sector = "Other"
		}
		sectorValues[sector] += assets[i].TotalValue()
	}

	out := make([]RiskAlert, 0, len(sectorValues))
	for sector, value := range sectorValues {
		pct := (value / totalValue) * 100
		if pct >= SectorConcentrationCritical {
			out = append(out, RiskAlert{
				Type:      "sector_concentration",
				Severity:  "critical",
				Title:     fmt.Sprintf("Critical concentration in %s", sector),
				Message:   fmt.Sprintf("%.0f%% of your portfolio is in %s. High risk.", pct, sector),
				Value:     pct,
				Threshold: SectorConcentrationCritical,
			})
			continue
		}
		if pct >= SectorConcentrationWarning {
			out = append(out, RiskAlert{
				Type:      "sector_concentration",
				Severity:  "warning",
				Title:     fmt.Sprintf("High concentration in %s", sector),
				Message:   fmt.Sprintf("%.0f%% of your portfolio is in %s. Consider diversifying.", pct, sector),
				Value:     pct,
				Threshold: SectorConcentrationWarning,
			})
		}
	}
	return out
}

func (s *RiskService) checkGeographicConcentration(assets []entities.Asset, totalValue float64) []RiskAlert {
	regionValues := make(map[string]float64)
	for i := range assets {
		region := s.getAssetRegion(assets[i])
		if region == "" {
			region = "Unclassified"
		}
		regionValues[region] += assets[i].TotalValue()
	}

	out := make([]RiskAlert, 0, len(regionValues))
	for region, value := range regionValues {
		pct := (value / totalValue) * 100
		if pct >= GeoConcentrationWarning {
			out = append(out, RiskAlert{
				Type:      "geographic_concentration",
				Severity:  "warning",
				Title:     fmt.Sprintf("High concentration in %s", region),
				Message:   fmt.Sprintf("%.0f%% of your assets are in %s.", pct, region),
				Value:     pct,
				Threshold: GeoConcentrationWarning,
			})
			continue
		}
		if pct >= GeoConcentrationInfo {
			out = append(out, RiskAlert{
				Type:      "geographic_concentration",
				Severity:  "info",
				Title:     "Geographic concentration",
				Message:   fmt.Sprintf("%.0f%% of your assets are in %s.", pct, region),
				Value:     pct,
				Threshold: GeoConcentrationInfo,
			})
		}
	}
	return out
}

func (s *RiskService) getAssetRegion(asset entities.Asset) string {
	// Prefer explicit country
	country := getMetadataString(asset.ExtendedData, "country")
	if country != "" {
		return country
	}

	exchange := strings.ToUpper(getMetadataString(asset.ExtendedData, "exchange"))
	switch exchange {
	case "NASDAQ", "NYSE", "AMEX":
		return "United States"
	case "LSE":
		return "United Kingdom"
	}

	return "Unclassified"
}

func (s *RiskService) maxSectorPercent(assets []entities.Asset, totalValue float64) float64 {
	sectorValues := make(map[string]float64)
	for i := range assets {
		sector := getMetadataString(assets[i].ExtendedData, "sector")
		if sector == "" {
			sector = "Other"
		}
		sectorValues[sector] += assets[i].TotalValue()
	}
	maxPct := 0.0
	for _, v := range sectorValues {
		pct := (v / totalValue) * 100
		if pct > maxPct {
			maxPct = pct
		}
	}
	return maxPct
}

func (s *RiskService) maxGeoPercent(assets []entities.Asset, totalValue float64) float64 {
	geoValues := make(map[string]float64)
	for i := range assets {
		geoValues[s.getAssetRegion(assets[i])] += assets[i].TotalValue()
	}
	maxPct := 0.0
	for _, v := range geoValues {
		pct := (v / totalValue) * 100
		if pct > maxPct {
			maxPct = pct
		}
	}
	return maxPct
}

func getMetadataString(raw json.RawMessage, key string) string {
	if len(raw) == 0 {
		return ""
	}
	var m map[string]interface{}
	if err := json.Unmarshal(raw, &m); err != nil {
		return ""
	}
	v, ok := m[key]
	if !ok || v == nil {
		return ""
	}
	s, ok := v.(string)
	if !ok {
		return ""
	}
	return strings.TrimSpace(s)
}

// diversificationLevel computes the diversification label by combining
// concentration risk with asset-type variety. A portfolio spread across
// many asset types gets a bonus that lowers the effective concentration score.
func (s *RiskService) diversificationLevel(assets []entities.Asset, concentrationScore int) string {
	// Count distinct asset types
	typeSet := make(map[string]bool)
	for i := range assets {
		typeSet[string(assets[i].Type)] = true
	}
	numTypes := len(typeSet)

	// Apply a diversity bonus: more asset types reduce the effective score.
	adjustedScore := float64(concentrationScore)
	switch {
	case numTypes >= 4:
		adjustedScore *= 0.6 // 40% reduction for 4+ types
	case numTypes >= 3:
		adjustedScore *= 0.7 // 30% reduction for 3 types
	case numTypes >= 2:
		adjustedScore *= 0.85 // 15% reduction for 2 types
	}
	// 1 type: no adjustment, concentration alone drives the score

	switch {
	case adjustedScore >= 70:
		return "poor"
	case adjustedScore >= 40:
		return "moderate"
	default:
		return "good"
	}
}

func clamp(v, min, max float64) float64 {
	if v < min {
		return min
	}
	if v > max {
		return max
	}
	return v
}
