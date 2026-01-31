# 🐛 Debug Guide - Asset Loading

## ✅ Debug Prints Agregados

He agregado prints detallados con emojis de colores en toda la cadena de carga de assets para identificar exactamente dónde ocurre el problema.

### 📍 Ubicaciones de los Prints

#### 1. **Data Source** (🟣 Morado)
Archivo: `asset_remote_data_source.dart`
- Llamada HTTP a `/api/v1/assets`
- Status code de respuesta
- Datos recibidos del API
- Parsing de cada asset

#### 2. **Repository** (🔵 Azul)
Archivo: `asset_repository_impl.dart`
- Inicio de fetch desde API
- Cantidad de DTOs recibidos
- Conversión de DTO a Domain
- Errores de Dio o excepciones

#### 3. **Provider** (🟢 Verde)
Archivo: `assets_provider.dart`
- Build del provider
- Llamada al repository
- Assets recibidos con detalles
- Filtrado por tipo

#### 4. **Dashboard** (🔴 Rojo)
Archivo: `dashboard_screen.dart`
- Portfolio summary cargado
- Watching del provider de assets
- Assets recibidos en UI
- Sorting y selección de top 3
- Loading y error states

#### 5. **Assets List** (🟠 Naranja)
Archivo: `assets_list_screen.dart`
- Assets recibidos en lista
- Empty state
- Loading state
- Error state con stack trace

---

## 🔍 Cómo Interpretar los Logs

### Flujo Normal (Todo OK):
```
🟣 [AssetDataSource] GET /assets (page: 1, perPage: 20)
🟣 [AssetDataSource] Response status: 200
🟣 [AssetDataSource] Response data: {...}
🟣 [AssetDataSource] Assets list length: 2
🟣 [AssetDataSource] Parsing asset: ahorros
🟣 [AssetDataSource] Parsing asset: BULIION
✅ [AssetDataSource] Returning 2 DTOs

🔵 [AssetRepository] Fetching assets from API...
🔵 [AssetRepository] Received 2 assets from API
🔵 [AssetRepository] Converting DTO: ahorros (cash)
🔵 [AssetRepository] Converting DTO: BULIION (gold)
✅ [AssetRepository] Successfully converted 2 assets

🟢 [AllAssetsProvider] Building provider...
🟢 [AllAssetsProvider] Calling repository.getAssets()...
✅ [AllAssetsProvider] Received 2 assets
   - ahorros (cash): $222222000
   - BULIION (gold): $2000000

🔴 [Dashboard] Portfolio summary loaded successfully
🔴 [Dashboard] Asset count: 2
🔴 [Dashboard] Watching allAssetsProvider...
✅ [Dashboard] Assets loaded: 2
🔴 [Dashboard] Top 2 assets selected
   - ahorros: $222222000
   - BULIION: $2000000
```

### Si Hay Error en API:
```
🟣 [AssetDataSource] GET /assets (page: 1, perPage: 20)
❌ [AssetRepository] DioException: Connection timeout
❌ [AssetRepository] Status: null
❌ [AssetRepository] Response: null
```

### Si Hay Error en Parsing:
```
🟣 [AssetDataSource] Parsing asset: ahorros
❌ [AssetRepository] Unexpected error: FormatException...
```

### Si Assets Está Vacío:
```
✅ [AssetDataSource] Returning 0 DTOs
✅ [AllAssetsProvider] Received 0 assets
⚠️ [Dashboard] No assets to display
```

---

## 📋 Pasos para Debuggear

1. **Abre la terminal donde corre Flutter**
2. **Haz hot restart** presionando `R` en la terminal
3. **Observa los logs** en orden cronológico:
   - Busca emojis de error (❌)
   - Verifica cantidades en cada paso
   - Identifica dónde se rompe la cadena

4. **Navega a diferentes pantallas**:
   - Dashboard → Ver 🔴 logs
   - Assets List → Ver 🟠 logs
   - Pull to refresh → Ver 🔄 logs

5. **Crea un nuevo asset** y observa:
   - POST request
   - Invalidación del provider
   - Re-fetch de assets

---

## 🎯 Qué Buscar

### ✅ Señales Buenas:
- ✅ Status 200 en requests
- ✅ Assets list length > 0
- ✅ Successfully converted X assets
- ✅ Assets loaded: X

### ⚠️ Señales de Advertencia:
- ⚠️ Assets list is empty
- ⚠️ No assets to display
- ⚠️ Assets list length: 0

### ❌ Señales de Error:
- ❌ DioException
- ❌ Status: 401, 404, 500
- ❌ Unexpected error
- ❌ FormatException
- ❌ Type cast error

---

## 🔧 Soluciones Comunes

### Si no aparecen assets:
1. Verifica que el API devuelve datos (`Response data`)
2. Verifica que el parsing funciona (`Parsing asset: X`)
3. Verifica que el provider recibe datos (`Received X assets`)
4. Verifica que el UI renderiza (`Assets loaded: X`)

### Si hay error de tipo:
```
❌ type 'X' is not a subtype of type 'Y'
```
- Revisa el DTO (`AssetDto`)
- Verifica el JSON del API
- Chequea campos nullable

### Si hay timeout:
```
❌ Connection timeout
```
- Verifica conexión a internet
- Verifica que el backend está online
- Aumenta timeout en Dio config

---

## 📱 Hot Reload vs Hot Restart

- **Hot Reload (`r`)**: Actualiza UI pero mantiene estado
- **Hot Restart (`R`)**: Reinicia app completa, **RECOMENDADO** para ver logs desde el inicio

---

## 🚀 Después de Debuggear

Una vez identificado y resuelto el problema, puedes:
1. Comentar los prints si molestan
2. O dejarlos para debugging futuro
3. O removerlos completamente

Para remover todos los prints:
```bash
# Buscar y reemplazar en VS Code
Buscar: print\('.*?\[.*?\].*?'\);\n
Reemplazar con: (vacío)
```
