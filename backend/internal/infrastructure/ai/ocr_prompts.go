// Package ai provides AI-related functionality including prompts for OCR processing.
package ai

import "fmt"

// OCRSystemPrompt is the system instruction for OCR document processing.
const OCRSystemPrompt = `You are a financial document analysis expert. Your task is to extract financial asset information from bank statements, portfolio reports, and investment documents.

You must:
- Extract ALL visible financial holdings accurately
- Return data in valid JSON format only
- Be precise with numbers (quantities, prices)
- Identify asset types correctly based on context
- Indicate confidence levels for each extraction

Asset type mapping:
- Stocks, equities, shares → "stock"
- ETFs, index funds, mutual funds → "etf"
- Bonds, fixed income, treasuries → "bond"
- Bitcoin, Ethereum, cryptocurrencies → "crypto"
- Property, real estate investments → "real_estate"
- Gold, silver, precious metals → "gold"
- Cash, savings, money market → "cash"
- Other investments → "other"

Important:
- If a value is "total value" (qty × price), calculate the unit price
- Default currency to USD if not specified
- For ticker symbols, use standard formats (e.g., AAPL, GOOGL, BTC)
- Skip transaction history, fees, and non-asset items`

// OCRExtractionPrompt is the main prompt for extracting assets from documents.
const OCRExtractionPrompt = `Analyze this financial document image and extract all investment assets/holdings.

Return a JSON object with this EXACT structure (no markdown, no explanation):
{
  "document_type": "bank_statement|portfolio_report|investment_summary|brokerage_statement|other",
  "assets": [
    {
      "name": "Full asset name",
      "type": "stock|etf|bond|crypto|real_estate|gold|cash|other",
      "symbol": "TICKER or null if not applicable",
      "quantity": 10.5,
      "purchase_price": 150.00,
      "currency": "USD",
      "confidence": 0.95
    }
  ],
  "warnings": ["List any uncertainties or issues"]
}

Extraction rules:
1. Extract every visible asset/holding in the document
2. For stocks/ETFs: always include the ticker symbol
3. For quantities: use exact numbers, not rounded
4. For prices: use UNIT price (price per share/unit), not total value
5. If only total value shown: calculate unit_price = total_value / quantity
6. Currency: detect from document symbols ($, €, £) or text, default "USD"
7. Confidence: 0.0-1.0 based on text clarity and extraction certainty
8. Skip: fees, transactions, account summaries, non-asset items

Return ONLY the JSON object, no additional text.`

// OCRBankStatementPrompt is specialized for bank statements.
const OCRBankStatementPrompt = `Analyze this bank statement image and extract all financial assets and holdings.

Focus on:
- Investment accounts (stocks, bonds, funds)
- Savings accounts with balances (as "cash" type)
- Certificate of deposits
- Any other financial holdings

Return a JSON object with this structure:
{
  "document_type": "bank_statement",
  "assets": [
    {
      "name": "Asset name",
      "type": "stock|etf|bond|crypto|real_estate|gold|cash|other",
      "symbol": "TICKER or null",
      "quantity": 1.0,
      "purchase_price": 1000.00,
      "currency": "USD",
      "confidence": 0.9
    }
  ],
  "warnings": []
}

For cash/savings accounts: use quantity=1 and purchase_price=balance amount.
Return ONLY valid JSON.`

// OCRPortfolioReportPrompt is specialized for portfolio reports.
const OCRPortfolioReportPrompt = `Analyze this investment portfolio report and extract all holdings.

Common fields to look for:
- Security name / Description
- Ticker / Symbol
- Shares / Units / Quantity
- Price / Market Value / Current Price
- Cost Basis / Purchase Price

Return a JSON object:
{
  "document_type": "portfolio_report",
  "assets": [
    {
      "name": "Security name",
      "type": "stock|etf|bond|crypto|real_estate|gold|cash|other",
      "symbol": "TICKER",
      "quantity": 100,
      "purchase_price": 50.00,
      "currency": "USD",
      "confidence": 0.95
    }
  ],
  "warnings": []
}

If cost basis is available, use it as purchase_price.
If only market value is shown, use current price as purchase_price.
Return ONLY valid JSON.`

// DocumentTypeHints maps user-provided hints to specialized prompts.
var DocumentTypeHints = map[string]string{
	"bank_statement":   OCRBankStatementPrompt,
	"portfolio_report": OCRPortfolioReportPrompt,
	"brokerage":        OCRPortfolioReportPrompt,
	"investment":       OCRPortfolioReportPrompt,
}

// BuildOCRPrompt constructs the appropriate OCR prompt based on document hint.
// If no hint is provided or hint is unrecognized, returns the general extraction prompt.
func BuildOCRPrompt(documentHint string) string {
	if documentHint == "" {
		return OCRExtractionPrompt
	}

	if prompt, ok := DocumentTypeHints[documentHint]; ok {
		return prompt
	}

	// For custom hints, append to base prompt
	return fmt.Sprintf("%s\n\nAdditional context: This appears to be a %s document.",
		OCRExtractionPrompt, documentHint)
}

// ValidMIMETypes lists the supported image MIME types for OCR.
var ValidMIMETypes = map[string]bool{
	"image/jpeg":      true,
	"image/jpg":       true,
	"image/png":       true,
	"image/webp":      true,
	"image/gif":       true,
	"application/pdf": true,
}

// IsValidMIMEType checks if the provided MIME type is supported for OCR.
func IsValidMIMEType(mimeType string) bool {
	return ValidMIMETypes[mimeType]
}

// MaxFileSize is the maximum allowed file size for OCR (10MB).
const MaxFileSize = 10 << 20 // 10 MB
