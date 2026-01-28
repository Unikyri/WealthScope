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
	Alerts               []RiskAlert `json:"alerts"`
	RiskScore            int         `json:"risk_score"` // 0-100
	DiversificationLevel string      `json:"diversification_level"`
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

	// Simple score: max concentration percentage across dimensions.
	maxPct := math.Max(s.maxSectorPercent(assets, totalValue), s.maxGeoPercent(assets, totalValue))
	score := int(math.Round(clamp(maxPct, 0, 100)))

	level := diversificationLevelFromScore(score)

	return PortfolioRisk{
		Alerts:               alerts,
		RiskScore:            score,
		DiversificationLevel: level,
	}
}

func (s *RiskService) checkSectorConcentration(assets []entities.Asset, totalValue float64) []RiskAlert {
	sectorValues := make(map[string]float64)
	for i := range assets {
		sector := getMetadataString(assets[i].Metadata, "sector")
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
	country := getMetadataString(asset.Metadata, "country")
	if country != "" {
		return country
	}

	exchange := strings.ToUpper(getMetadataString(asset.Metadata, "exchange"))
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
		sector := getMetadataString(assets[i].Metadata, "sector")
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

func diversificationLevelFromScore(score int) string {
	switch {
	case score >= 70:
		return "poor"
	case score >= 40:
		return "medium"
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
