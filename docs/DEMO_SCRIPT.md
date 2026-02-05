# 🎬 Hackathon Demo Script

**Project:** WealthScope  
**Duration:** 5-7 minutes  
**Target:** Codeathon 2026 Judges

---

## 📋 Pre-Demo Checklist

- [ ] Demo account logged in
- [ ] Portfolio populated with diverse assets
- [ ] AI chat history cleared
- [ ] Sample document ready for OCR
- [ ] News feed loaded
- [ ] Backup screenshots prepared

---

## 🎯 Demo Flow

### 1. Introduction (30 seconds)

**[Slide: WealthScope Logo]**

> "Hi everyone! I'm presenting **WealthScope** - an AI-powered investment portfolio management app that consolidates all your assets in one intelligent dashboard."

**Key Points:**
- 📊 Problem: Investors use multiple apps to track different asset types
- 💡 Solution: One unified dashboard with AI-powered insights
- 🎯 Target: Retail investors with diverse portfolios

---

### 2. Onboarding Experience (30 seconds)

**[Show: Onboarding screens]**

> "Let me show you the first-time user experience..."

**Demonstrate:**
- Simple email/password registration
- Clean, modern Material Design 3 UI
- Quick value proposition

---

### 3. Dashboard Tour (1 minute)

**[Navigate to: Main Dashboard]**

> "This is the heart of WealthScope - a unified view of your entire portfolio."

**Highlight:**
- 📈 **Total Portfolio Value** - $125,000 example
- 📊 **Pie Chart** - Asset allocation breakdown
- 📉 **Performance Metrics** - Gain/Loss, ROI %
- 🔄 **Real-time Updates** - Prices refresh automatically

**Script:**
> "Notice how stocks, crypto, real estate, and gold are all displayed together. No more switching between apps!"

---

### 4. Asset Management (1 minute)

**[Navigate to: Assets List]**

> "Managing assets is incredibly simple..."

**Demonstrate:**
- Tap to view asset details
- Real-time price from 9 integrated APIs
- Historical performance chart
- Add new asset flow (quick demo)

**Script:**
> "We integrate with 9 different market data APIs including Alpha Vantage, CoinGecko, and Frankfurter for comprehensive coverage."

---

### 5. AI Features - KEY DIFFERENTIATOR (2 minutes)

⭐ **This is the most important section!**

#### 5a. AI Chat Advisor (45 seconds)

**[Navigate to: AI Chat]**

> "Now for our killer feature - the AI Financial Advisor powered by Gemini 3.0!"

**Example Questions:**
1. "How is my portfolio diversified?"
2. "Should I invest more in crypto?"
3. "What's my risk exposure?"

**Script:**
> "The AI has full context of your portfolio. It can analyze your holdings, suggest improvements, and answer complex financial questions in natural language."

#### 5b. OCR Document Import (45 seconds)

**[Navigate to: OCR Feature]**

> "Adding assets from documents? Just scan them!"

**Demonstrate:**
- Take photo of financial statement (or use prepared image)
- Watch extraction in real-time
- Review extracted data
- Confirm to add asset

**Script:**
> "Using Google Vision AI, we can extract asset data from bank statements, brokerage reports, even real estate documents!"

#### 5c. What-If Simulator (30 seconds)

**[Navigate to: Scenario Simulator]**

> "Curious about 'what if' scenarios? Our simulator can project outcomes."

**Show Templates:**
- "What if the market drops 20%?"
- "What if I buy $5,000 of Bitcoin?"
- "What if I rebalance to 60/40?"

**Script:**
> "This helps investors make informed decisions before committing capital."

---

### 6. Additional Features (1 minute)

**[Quick Tour]**

#### News Feed
> "Stay informed with curated financial news relevant to your holdings."

#### Currency Conversion
> "Real-time forex rates for international assets."

#### Insights Dashboard
> "AI-generated insights about your portfolio performance."

---

### 7. Technical Highlights (1 minute)

**[Show: Architecture Slide if available]**

> "Under the hood, WealthScope is built with..."

| Technology | Purpose |
|------------|---------|
| **Flutter** | Cross-platform mobile (iOS/Android) |
| **Go** | High-performance backend API |
| **Supabase** | Database and authentication |
| **Gemini 3.0** | AI chat and insights |
| **Vision AI** | Document OCR |

**Integration Stats:**
> "We've integrated **9 external APIs** for market data with automatic fallback between providers."

**CI/CD:**
> "Full CI/CD pipeline with GitHub Actions and strict linting."

---

### 8. Closing (30 seconds)

**[Show: Summary Slide]**

> "WealthScope brings everything together in one intelligent app:"

**Recap:**
- ✅ Unified portfolio dashboard
- ✅ AI-powered financial advisor
- ✅ OCR document import
- ✅ What-If scenario simulator
- ✅ Real-time data from 9 APIs

**Call to Action:**
> "We believe WealthScope represents the future of personal investment management. Thank you!"

---

## 🚨 Backup Plans

### If API Fails
- Have screenshots ready of all screens
- Mention: "API has a rate limit, but here's what it looks like..."

### If AI Slow
- Have pre-cached response ready
- Say: "The AI typically responds in 2-3 seconds..."

### If OCR Fails
- Use pre-extracted demo
- Explain: "Here's what the extracted data looks like..."

### If App Crashes
- Have screen recording backup
- Restart app (cached data loads fast)

---

## 📝 Judge Q&A Preparation

**Q: How do you handle API rate limits?**
> "We implement a multi-provider fallback chain. If one API hits its limit, we automatically switch to a backup."

**Q: Is the AI giving real financial advice?**
> "The AI provides informational insights, not professional advice. We include appropriate disclaimers."

**Q: How secure is user data?**
> "We use Supabase with row-level security. All API keys are server-side only. No sensitive data in the frontend."

**Q: What's your monetization strategy?**
> "Freemium model with premium AI features via RevenueCat subscription."

---

## 🎯 Key Talking Points

1. **9 APIs** integrated for comprehensive market data
2. **Gemini 3.0** for intelligent conversation
3. **Vision AI** for document scanning
4. **Clean Architecture** for maintainability
5. **Real-time** price updates
6. **Automatic fallback** between providers

---

*Good luck with the presentation! 🚀*
