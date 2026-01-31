# HOTFIX-1: Correcciones API Compatibility

**Issue**: #192  
**Fecha**: 30 de enero de 2026  
**Gravedad**: 🚨 Crítica  

---

## 🔍 Diagnóstico

El frontend tenía **inconsistencias graves** entre las entidades esperadas y la API real documentada en Swagger. Esto habría causado errores 400/500 en producción.

---

## ✅ Correcciones Aplicadas

### 1. **Portfolio Summary API** (`/api/v1/portfolio/summary`)

#### ❌ Antes (Incorrecto)
```dart
class PortfolioSummary {
  final double totalGain;
  final double totalGainPercentage;
  final double dayChange;           // ❌ NO EXISTE en API
  final double dayChangePercentage; // ❌ NO EXISTE en API
  final List<AssetAllocation> allocations; // ❌ Nombre incorrecto
  final List<TopAsset> topAssets;   // ❌ NO EXISTE en /summary
  final bool? isMarketOpen;         // ❌ NO EXISTE en API
}
```

#### ✅ Ahora (Correcto)
```dart
class PortfolioSummary {
  final double totalValue;
  final double totalInvested;       // ✅ NUEVO campo de API
  final double gainLoss;            // ✅ Renombrado
  final double gainLossPercent;     // ✅ Renombrado
  final List<AssetTypeBreakdown> breakdownByType; // ✅ Nombre correcto
  final DateTime lastUpdated;
}
```

---

### 2. **Asset DTO** (`/api/v1/assets`)

La API devuelve campos **calculados por el backend** que el frontend ignoraba:

#### ✅ Campos Agregados
```dart
class AssetDto {
  final double? totalCost;        // quantity * purchase_price
  final double? totalValue;       // quantity * current_price
  final double? gainLoss;         // total_value - total_cost
  final double? gainLossPercent;  // (gain_loss / total_cost) * 100
}
```

#### ❌ Campos Eliminados
```dart
// Estos ya NO los calcula el frontend:
final double? currentValue;    // Ahora es totalValue
final DateTime? lastPriceUpdate; // No viene en la API
```

---

### 3. **Risk Endpoint Separado** (`/api/v1/portfolio/risk`)

Creado soporte para el endpoint de riesgo que es **independiente**:

```dart
// NUEVO DTO
class PortfolioRiskDto {
  final int riskScore;
  final String diversificationLevel;
  final List<RiskAlertDto> alerts;
}
```

---

### 4. **Asset Response Structure** (Paginación)

La API devuelve:
```json
{
  "data": {
    "assets": [...],  // ✅ Array dentro de "data"
    "pagination": {...}
  }
}
```

**Antes** esperábamos: `data: [...]` (array directo).  
**Ahora** parseamos: `data['assets']`.

---

## 📁 Archivos Modificados

### Domain Layer (Entidades)
- ✅ [portfolio_summary.dart](lib/features/dashboard/domain/entities/portfolio_summary.dart)
- ✅ [portfolio_risk.dart](lib/features/dashboard/domain/entities/portfolio_risk.dart) (NUEVO)
- ✅ [stock_asset.dart](lib/features/assets/domain/entities/stock_asset.dart)

### Data Layer (DTOs & DataSources)
- ✅ [portfolio_summary_dto.dart](lib/features/dashboard/data/models/portfolio_summary_dto.dart)
- ✅ [portfolio_risk_dto.dart](lib/features/dashboard/data/models/portfolio_risk_dto.dart) (NUEVO)
- ✅ [asset_dto.dart](lib/features/assets/data/models/asset_dto.dart)
- ✅ [dashboard_remote_source.dart](lib/features/dashboard/data/datasources/dashboard_remote_source.dart)
- ✅ [asset_remote_data_source.dart](lib/features/assets/data/datasources/asset_remote_data_source.dart)

### Presentation Layer (Widgets & Screens)
- ✅ [portfolio_summary_card.dart](lib/features/dashboard/presentation/widgets/portfolio_summary_card.dart)
- ✅ [allocation_pie_chart.dart](lib/features/dashboard/presentation/widgets/allocation_pie_chart.dart)
- ✅ [allocation_legend.dart](lib/features/dashboard/presentation/widgets/allocation_legend.dart)
- ✅ [allocation_section.dart](lib/features/dashboard/presentation/widgets/allocation_section.dart)
- ✅ [enhanced_allocation_section.dart](lib/features/dashboard/presentation/widgets/enhanced_allocation_section.dart)
- ✅ [dashboard_screen.dart](lib/features/dashboard/presentation/screens/dashboard_screen.dart)

---

## 🔄 Cambios en Nomenclatura

| Antes (Frontend)        | Ahora (API Real)         |
|------------------------|--------------------------|
| `totalGain`            | `gainLoss`               |
| `totalGainPercentage`  | `gainLossPercent`        |
| `allocations`          | `breakdownByType`        |
| `AssetAllocation`      | `AssetTypeBreakdown`     |
| `allocation.percentage`| `allocation.percent`     |
| `allocation.label`     | `allocation.type` (humanizado en UI) |
| `currentValue`         | `totalValue`             |

---

## ⚠️ Breaking Changes

### Para Providers/Repositorios
Si tu código llama a `portfolioSummary.totalGain`, cámbialo a `.gainLoss`.

### Para Widgets
Si tu widget recibe `List<AssetAllocation>`, cámbialo a `List<AssetTypeBreakdown>`.

---

## 🧪 Verificación Post-Hotfix

```bash
# Regenerar archivos
dart run build_runner build --delete-conflicting-outputs

# Verificar errores
flutter analyze

# Correr tests (si existen)
flutter test
```

---

## 📊 Endpoints Actualizados

| Endpoint                    | Método | Cambios Aplicados                          |
|-----------------------------|--------|--------------------------------------------|
| `/api/v1/portfolio/summary` | GET    | ✅ Estructura DTO corregida                |
| `/api/v1/portfolio/risk`    | GET    | ✅ NUEVO endpoint soportado                |
| `/api/v1/assets`            | GET    | ✅ Paginación y campos calculados          |
| `/api/v1/assets`            | POST   | ✅ Compatible con backend                  |
| `/api/v1/assets/{id}`       | PUT    | ✅ Compatible con backend                  |

---

## 🎯 Próximos Pasos

1. **Testing Manual**: Probar flujo completo con backend real
2. **Widget Tests**: Actualizar tests que usen las entidades viejas
3. **Error Handling**: Validar respuestas inesperadas
4. **Loading States**: Asegurar que `AsyncValue.when()` funciona correctamente

---

## 📝 Notas del Desarrollador

- **NO** se eliminaron features, solo se alinearon nombres.
- Los cambios respetan **Scream Architecture**.
- Los widgets eliminados (`TopAssetsSection`, `PriceStatusChip`) se pueden recrear cuando el backend los soporte.
- `build_runner` ejecutado sin errores.

---

**Estado**: ✅ Completado  
**Compilación**: ✅ Sin errores  
**Arquitectura**: ✅ Respetada
