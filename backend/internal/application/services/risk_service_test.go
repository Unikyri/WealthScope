package services

import (
	"encoding/json"
	"testing"

	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
)

func TestRiskService_SectorWarning(t *testing.T) {
	svc := NewRiskService()

	a1 := newAssetWithMeta(65, map[string]interface{}{"sector": "Technology", "country": "United States"})
	a2 := newAssetWithMeta(35, map[string]interface{}{"sector": "Healthcare", "country": "United Kingdom"})

	risk := svc.AnalyzePortfolio([]entities.Asset{a1, a2})
	if len(risk.Alerts) == 0 {
		t.Fatalf("expected alerts, got none")
	}

	found := false
	for _, a := range risk.Alerts {
		if a.Type == "sector_concentration" && a.Severity == "warning" && a.Threshold == SectorConcentrationWarning {
			found = true
		}
	}
	if !found {
		t.Fatalf("expected sector warning alert, got: %+v", risk.Alerts)
	}
}

func TestRiskService_SectorCritical(t *testing.T) {
	svc := NewRiskService()

	a1 := newAssetWithMeta(75, map[string]interface{}{"sector": "Technology", "country": "United States"})
	a2 := newAssetWithMeta(25, map[string]interface{}{"sector": "Healthcare", "country": "United Kingdom"})

	risk := svc.AnalyzePortfolio([]entities.Asset{a1, a2})
	found := false
	for _, a := range risk.Alerts {
		if a.Type == "sector_concentration" && a.Severity == "critical" && a.Threshold == SectorConcentrationCritical {
			found = true
		}
	}
	if !found {
		t.Fatalf("expected sector critical alert, got: %+v", risk.Alerts)
	}
}

func TestRiskService_GeoInfoAndWarning(t *testing.T) {
	svc := NewRiskService()

	// 70% in US (info), 30% in UK.
	a1 := newAssetWithMeta(70, map[string]interface{}{"country": "United States"})
	a2 := newAssetWithMeta(30, map[string]interface{}{"country": "United Kingdom"})

	risk := svc.AnalyzePortfolio([]entities.Asset{a1, a2})
	foundInfo := false
	for _, a := range risk.Alerts {
		if a.Type == "geographic_concentration" && a.Severity == "info" && a.Threshold == GeoConcentrationInfo {
			foundInfo = true
		}
	}
	if !foundInfo {
		t.Fatalf("expected geo info alert, got: %+v", risk.Alerts)
	}

	// 90% in US (warning), 10% in UK.
	a3 := newAssetWithMeta(90, map[string]interface{}{"exchange": "NASDAQ"})
	a4 := newAssetWithMeta(10, map[string]interface{}{"country": "United Kingdom"})
	risk2 := svc.AnalyzePortfolio([]entities.Asset{a3, a4})
	foundWarning := false
	for _, a := range risk2.Alerts {
		if a.Type == "geographic_concentration" && a.Severity == "warning" && a.Threshold == GeoConcentrationWarning {
			foundWarning = true
		}
	}
	if !foundWarning {
		t.Fatalf("expected geo warning alert, got: %+v", risk2.Alerts)
	}
}

func TestRiskService_NoAlerts(t *testing.T) {
	svc := NewRiskService()

	a1 := newAssetWithMeta(34, map[string]interface{}{"sector": "Tech", "country": "United States"})
	a2 := newAssetWithMeta(33, map[string]interface{}{"sector": "Health", "country": "United Kingdom"})
	a3 := newAssetWithMeta(33, map[string]interface{}{"sector": "Energy", "country": "Canada"})

	risk := svc.AnalyzePortfolio([]entities.Asset{a1, a2, a3})
	if len(risk.Alerts) != 0 {
		t.Fatalf("expected no alerts, got: %+v", risk.Alerts)
	}
	if risk.DiversificationLevel != "good" {
		t.Fatalf("expected diversification_level=good, got %q", risk.DiversificationLevel)
	}
}

func TestRiskService_MultipleAlerts(t *testing.T) {
	svc := NewRiskService()

	// Sector 80% Tech -> critical
	// Geo 85% US -> warning
	a1 := newAssetWithMeta(85, map[string]interface{}{"sector": "Technology", "country": "United States"})
	a2 := newAssetWithMeta(15, map[string]interface{}{"sector": "Technology", "country": "United Kingdom"})

	risk := svc.AnalyzePortfolio([]entities.Asset{a1, a2})
	if len(risk.Alerts) < 2 {
		t.Fatalf("expected multiple alerts, got: %+v", risk.Alerts)
	}
}

func newAssetWithMeta(price float64, meta map[string]interface{}) entities.Asset {
	raw, _ := json.Marshal(meta)
	a := entities.NewAsset(uuid.New(), entities.AssetTypeStock, "X", 1, price, "USD")
	a.CurrentPrice = &price
	a.Metadata = raw
	return *a
}
