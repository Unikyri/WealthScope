// seed_demo_data.go - Creates demo data for hackathon presentation
// Run: go run seed_demo_data.go
package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/google/uuid"
	"github.com/joho/godotenv"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

// AssetModel represents the database model for assets
// Fields ordered for optimal memory alignment (pointers first for GC efficiency)
type AssetModel struct {
	UpdatedAt     time.Time       `gorm:"type:timestamptz;not null;default:now()"`
	CreatedAt     time.Time       `gorm:"type:timestamptz;not null;default:now()"`
	Notes         *string         `gorm:"type:text"`
	Symbol        *string         `gorm:"type:varchar(20)"`
	CurrentPrice  *float64        `gorm:"type:decimal(20,8)"`
	PurchaseDate  *time.Time      `gorm:"type:timestamptz"`
	Type          string          `gorm:"type:varchar(50);not null"`
	Name          string          `gorm:"type:varchar(255);not null"`
	Currency      string          `gorm:"type:varchar(10);not null;default:'USD'"`
	Metadata      json.RawMessage `gorm:"type:jsonb;default:'{}'"`
	Quantity      float64         `gorm:"type:decimal(20,8);not null"`
	PurchasePrice float64         `gorm:"type:decimal(20,8);not null"`
	ID            uuid.UUID       `gorm:"type:uuid;primaryKey"`
	UserID        uuid.UUID       `gorm:"type:uuid;not null;index"`
}

func (AssetModel) TableName() string {
	return "assets"
}

// DemoAsset defines a demo asset to be created
// Fields ordered for optimal memory alignment
type DemoAsset struct {
	Type          string
	Name          string
	Symbol        string
	Notes         string
	Quantity      float64
	PurchasePrice float64
	CurrentPrice  float64
	DaysAgo       int // Purchase date relative to now
}

func main() {
	// Load environment variables
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found, using environment variables")
	}

	dbURL := os.Getenv("DATABASE_URL")
	if dbURL == "" {
		log.Fatal("DATABASE_URL environment variable is required")
	}

	demoUserID := os.Getenv("DEMO_USER_ID")
	if demoUserID == "" {
		log.Fatal("DEMO_USER_ID environment variable is required (UUID of the demo user)")
	}

	userID, err := uuid.Parse(demoUserID)
	if err != nil {
		log.Fatalf("Invalid DEMO_USER_ID: %v", err)
	}

	// Connect to database
	db, err := gorm.Open(postgres.New(postgres.Config{
		DSN:                  dbURL,
		PreferSimpleProtocol: true,
	}), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Info),
	})
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	fmt.Println("🚀 WealthScope Demo Data Seeder")
	fmt.Printf("📊 Target User ID: %s\n", userID)
	fmt.Println("---")

	// Define a diversified demo portfolio (~$127K total value)
	demoAssets := []DemoAsset{
		// 📈 Tech Stocks (40% of portfolio)
		{Type: "stock", Name: "Apple Inc.", Symbol: "AAPL", Quantity: 100, PurchasePrice: 150.00, CurrentPrice: 178.50, Notes: "Core tech holding", DaysAgo: 365},
		{Type: "stock", Name: "Microsoft Corporation", Symbol: "MSFT", Quantity: 50, PurchasePrice: 280.00, CurrentPrice: 378.00, Notes: "Cloud growth play", DaysAgo: 280},
		{Type: "stock", Name: "NVIDIA Corporation", Symbol: "NVDA", Quantity: 30, PurchasePrice: 220.00, CurrentPrice: 440.00, Notes: "AI chip leader", DaysAgo: 180},
		{Type: "stock", Name: "Tesla, Inc.", Symbol: "TSLA", Quantity: 20, PurchasePrice: 200.00, CurrentPrice: 175.00, Notes: "EV position", DaysAgo: 120},

		// 💰 Cryptocurrency (15% of portfolio)
		{Type: "crypto", Name: "Bitcoin", Symbol: "BTC", Quantity: 0.5, PurchasePrice: 30000.00, CurrentPrice: 42500.00, Notes: "Digital gold", DaysAgo: 400},
		{Type: "crypto", Name: "Ethereum", Symbol: "ETH", Quantity: 5.0, PurchasePrice: 1800.00, CurrentPrice: 2350.00, Notes: "Smart contract platform", DaysAgo: 300},
		{Type: "crypto", Name: "Solana", Symbol: "SOL", Quantity: 100, PurchasePrice: 25.00, CurrentPrice: 98.00, Notes: "High-speed L1", DaysAgo: 200},

		// 🏛️ ETFs (20% of portfolio)
		{Type: "etf", Name: "Vanguard S&P 500 ETF", Symbol: "VOO", Quantity: 30, PurchasePrice: 380.00, CurrentPrice: 425.00, Notes: "Index fund core", DaysAgo: 500},
		{Type: "etf", Name: "Invesco QQQ Trust", Symbol: "QQQ", Quantity: 15, PurchasePrice: 330.00, CurrentPrice: 380.00, Notes: "Tech-heavy index", DaysAgo: 350},

		// 🏠 Real Estate (10% of portfolio)
		{Type: "real_estate", Name: "Downtown Condo Investment", Symbol: "", Quantity: 1, PurchasePrice: 12000.00, CurrentPrice: 13500.00, Notes: "REIT via crowdfunding", DaysAgo: 730},

		// 🪙 Gold (5% of portfolio)
		{Type: "gold", Name: "Gold Bullion", Symbol: "XAU", Quantity: 3, PurchasePrice: 1900.00, CurrentPrice: 2050.00, Notes: "Inflation hedge", DaysAgo: 450},

		// 📜 Bonds (5% of portfolio)
		{Type: "bond", Name: "US Treasury 10Y", Symbol: "T10Y", Quantity: 5, PurchasePrice: 980.00, CurrentPrice: 950.00, Notes: "Fixed income allocation", DaysAgo: 600},

		// 💵 Cash (5% of portfolio)
		{Type: "cash", Name: "High-Yield Savings", Symbol: "", Quantity: 5000, PurchasePrice: 1.00, CurrentPrice: 1.00, Notes: "Emergency fund", DaysAgo: 30},
	}

	ctx := context.Background()

	// First, delete existing demo assets for this user
	fmt.Println("\n🗑️  Cleaning existing demo data...")
	if err := db.WithContext(ctx).Where("user_id = ?", userID).Delete(&AssetModel{}).Error; err != nil {
		log.Printf("Warning: Failed to delete existing assets: %v", err)
	}

	// Create new demo assets
	fmt.Println("\n📝 Creating demo portfolio...")
	var totalValue, totalInvested float64

	for _, asset := range demoAssets {
		now := time.Now().UTC()
		purchaseDate := now.AddDate(0, 0, -asset.DaysAgo)

		model := AssetModel{
			ID:            uuid.New(),
			UserID:        userID,
			Type:          asset.Type,
			Name:          asset.Name,
			Quantity:      asset.Quantity,
			PurchasePrice: asset.PurchasePrice,
			CurrentPrice:  &asset.CurrentPrice,
			Currency:      "USD",
			PurchaseDate:  &purchaseDate,
			Metadata:      json.RawMessage("{}"),
			CreatedAt:     now,
			UpdatedAt:     now,
		}

		if asset.Symbol != "" {
			model.Symbol = &asset.Symbol
		}
		if asset.Notes != "" {
			model.Notes = &asset.Notes
		}

		if err := db.WithContext(ctx).Create(&model).Error; err != nil {
			log.Printf("❌ Failed to create %s: %v", asset.Name, err)
			continue
		}

		invested := asset.Quantity * asset.PurchasePrice
		value := asset.Quantity * asset.CurrentPrice
		gainLoss := value - invested
		percent := (gainLoss / invested) * 100

		totalInvested += invested
		totalValue += value

		symbol := asset.Symbol
		if symbol == "" {
			symbol = "-"
		}

		changeSign := "+"
		if gainLoss < 0 {
			changeSign = ""
		}

		fmt.Printf("  ✅ %-25s %-6s $%10.2f → $%10.2f (%s%.1f%%)\n",
			asset.Name, symbol, invested, value, changeSign, percent)
	}

	// Print summary
	gainLoss := totalValue - totalInvested
	percent := (gainLoss / totalInvested) * 100
	changeSign := "+"
	if gainLoss < 0 {
		changeSign = ""
	}

	fmt.Println("\n" + "═══════════════════════════════════════════════════════════════════")
	fmt.Printf("📊 PORTFOLIO SUMMARY\n")
	fmt.Println("───────────────────────────────────────────────────────────────────")
	fmt.Printf("  💼 Total Invested:  $%.2f\n", totalInvested)
	fmt.Printf("  💰 Current Value:   $%.2f\n", totalValue)
	fmt.Printf("  📈 Gain/Loss:       %s$%.2f (%s%.2f%%)\n", changeSign, gainLoss, changeSign, percent)
	fmt.Printf("  🪙 Asset Count:     %d assets\n", len(demoAssets))
	fmt.Println("═══════════════════════════════════════════════════════════════════")

	fmt.Println("\n✅ Demo data seeded successfully!")
	fmt.Println("🎯 Ready for hackathon demo!")
}
