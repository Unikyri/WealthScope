# 🏦 WealthScope

<div align="center">

![Go](https://img.shields.io/badge/Go-1.23-00ADD8?style=flat-square&logo=go)
![Flutter](https://img.shields.io/badge/Flutter-3.24-02569B?style=flat-square&logo=flutter)
![Supabase](https://img.shields.io/badge/Supabase-Database-3ECF8E?style=flat-square&logo=supabase)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)

**Consolida todos tus activos de inversión en un solo dashboard inteligente**

*Acciones • Inmuebles • Oro • Bonos • Criptomonedas*

</div>

---

## ✨ Features

### 📊 Portfolio Unificado
- **Dashboard inteligente** con vista consolidada de todos tus activos
- **Gráficos interactivos** de rendimiento histórico
- **Métricas de portfolio** (ganancia/pérdida, ROI, volatilidad)
- **Distribución por tipo de activo** con pie charts dinámicos

### 🤖 AI-Powered Financial Advisor
- **Chat conversacional** con Gemini 3.0 Flash
- **Análisis personalizado** basado en tu portfolio
- **Insights automáticos** y recomendaciones
- **Daily briefings** con resumen del mercado

### 📄 Document OCR Import
- **Escaneo de documentos** financieros con Google Vision AI
- **Extracción automática** de datos de activos
- **Confirmación inteligente** antes de agregar al portfolio
- Soporta estados de cuenta, certificados, contratos

### 🔮 What-If Scenario Simulator
- **Simulación de compra/venta** de activos
- **Proyección de movimientos** de mercado
- **Análisis de rebalanceo** del portfolio
- **8 templates predefinidos** de escenarios comunes

### 📈 Real-Time Market Data
- **9 APIs integradas** para datos de mercado
- **Precios en tiempo real** para acciones y crypto
- **Conversión de divisas** actualizada
- **Fallback automático** entre proveedores

### 📰 Financial News
- **Noticias relevantes** del mercado financiero
- **Filtrado por relevancia** a tu portfolio
- **Múltiples fuentes** de noticias

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         FRONTEND                                 │
│                    Flutter Mobile App                            │
│         (iOS/Android - Material Design 3)                        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                          BACKEND                                 │
│                    Go REST API (Gin)                             │
│              Clean Architecture Pattern                          │
│  ┌─────────┐  ┌─────────────┐  ┌──────────────┐  ┌──────────┐  │
│  │Handlers │→ │  Use Cases  │→ │ Repositories │→ │ Entities │  │
│  └─────────┘  └─────────────┘  └──────────────┘  └──────────┘  │
└─────────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
┌──────────────────┐ ┌───────────────┐ ┌─────────────────┐
│     SUPABASE     │ │  GEMINI AI    │ │  EXTERNAL APIs  │
│  ┌────────────┐  │ │  ┌─────────┐  │ │  ┌───────────┐  │
│  │ PostgreSQL │  │ │  │  Chat   │  │ │  │Alpha Vant.│  │
│  │    Auth    │  │ │  │  OCR    │  │ │  │  Finnhub  │  │
│  │  Storage   │  │ │  │ Vision  │  │ │  │ CoinGecko │  │
│  └────────────┘  │ │  └─────────┘  │ │  │  Binance  │  │
└──────────────────┘ └───────────────┘ │  │  Forex    │  │
                                       │  │  Metals   │  │
                                       │  │   News    │  │
                                       │  └───────────┘  │
                                       └─────────────────┘
```

---

## 🔌 API Endpoints

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/auth/register` | User registration |
| POST | `/api/v1/auth/login` | User login |
| POST | `/api/v1/auth/refresh` | Refresh token |

### Assets
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/assets` | List user assets |
| POST | `/api/v1/assets` | Create new asset |
| GET | `/api/v1/assets/:id` | Get asset details |
| PUT | `/api/v1/assets/:id` | Update asset |
| DELETE | `/api/v1/assets/:id` | Delete asset |
| GET | `/api/v1/portfolio/summary` | Portfolio summary |

### AI Features
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/ai/chat` | AI chat conversation |
| GET | `/api/v1/ai/insights` | Get AI insights |
| POST | `/api/v1/ai/ocr` | OCR document processing |
| POST | `/api/v1/ai/ocr/confirm` | Confirm OCR extraction |
| POST | `/api/v1/ai/simulate` | What-If simulation |
| GET | `/api/v1/ai/scenarios/templates` | Scenario templates |
| GET | `/api/v1/ai/scenarios/historical` | Historical analysis |

### Market Data
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/prices/:symbol` | Get asset price |
| GET | `/api/v1/currency/rate` | Currency exchange rate |
| GET | `/api/v1/currency/convert` | Convert currency |
| GET | `/api/v1/news` | Financial news |

---

## 🚀 Getting Started

### Prerequisites

- **Go 1.23+** - [Download](https://golang.org/dl/)
- **Flutter 3.24+** - [Download](https://flutter.dev/docs/get-started/install)
- **Supabase Account** - [Sign up](https://supabase.com/)

### Environment Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/Unikyri/WealthScope.git
   cd WealthScope
   ```

2. **Backend setup**
   ```bash
   cd backend
   cp .env.example .env
   # Edit .env with your credentials
   ```

3. **Configure environment variables**
   ```env
   # Database
   DATABASE_URL=your_supabase_connection_string
   
   # Supabase
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_KEY=your_anon_key
   
   # AI
   GEMINI_API_KEY=your_gemini_api_key
   
   # Market Data APIs
   ALPHA_VANTAGE_API_KEY=your_key
   FINNHUB_API_KEY=your_key
   COINGECKO_API_KEY=your_key  # optional
   METALS_API_KEY=your_key
   EXCHANGERATE_API_KEY=your_key
   NEWSDATA_API_KEY=your_key
   MARKETAUX_API_KEY=your_key
   ```

4. **Run the backend**
   ```bash
   cd backend
   go run cmd/api/main.go
   ```

5. **Run the frontend**
   ```bash
   cd frontend
   flutter pub get
   flutter run
   ```

---

## 📁 Project Structure

```
WealthScope/
├── backend/
│   ├── cmd/api/              # Application entrypoint
│   ├── internal/
│   │   ├── application/      # Use cases & services
│   │   ├── domain/           # Entities & repositories
│   │   ├── infrastructure/   # External implementations
│   │   └── interfaces/       # HTTP handlers & routes
│   ├── pkg/                  # Shared packages
│   ├── docs/                 # Swagger documentation
│   └── migrations/           # Database migrations
├── frontend/
│   ├── lib/
│   │   ├── core/             # App configuration
│   │   ├── data/             # Data layer
│   │   ├── domain/           # Business logic
│   │   └── presentation/     # UI components
│   └── test/                 # Unit tests
└── docs/                     # Project documentation
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|------------|
| **Frontend** | Flutter 3.24, Dart, Riverpod, fl_chart |
| **Backend** | Go 1.23, Gin, GORM, Zap Logger |
| **Database** | PostgreSQL (Supabase) |
| **AI** | Google Gemini 3.0 Flash, Vision AI |
| **APIs** | 9 external market data providers |
| **CI/CD** | GitHub Actions, golangci-lint |

---

## 📊 External APIs Integrated

| API | Purpose | Rate Limit |
|-----|---------|------------|
| Alpha Vantage | Stocks/ETFs | 5/min |
| Finnhub | Stocks/Market | 60/min |
| CoinGecko | Crypto | 50/min |
| Binance | Crypto | 1200/min |
| Frankfurter | Forex | 100/min |
| ExchangeRate-API | Forex | 100/min |
| Metals-API | Precious Metals | 50/min |
| NewsData.io | News | 200/day |
| Marketaux | News | 100/day |

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**Unikyri**

- GitHub: [@Unikyri](https://github.com/Unikyri)

---

<div align="center">
<i>Built for the Codeathon 2026</i>
</div>
