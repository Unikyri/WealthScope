# 🧪 Configuración Test Store - RevenueCat

## Pasos para crear tus planes de suscripción

### 1. Accede al Dashboard de RevenueCat
- Ve a: https://app.revenuecat.com
- Inicia sesión con tu cuenta
- Selecciona tu proyecto "WealthScope" (o el nombre que le hayas puesto)

### 2. Verifica que Test Store está activo
- En el menú lateral, ve a **"Overview"**
- Deberías ver "Test Store" en la lista de stores conectadas
- Test Store viene pre-configurada en todos los proyectos nuevos ✅

### 3. Crea los Productos (Products)

#### Paso 3.1: Ir a la sección de productos
1. En el menú lateral, haz clic en **"Products"**
2. Haz clic en **"+ New"** (botón azul arriba a la derecha)

#### Paso 3.2: Crear Plan Mensual ($1 USD)
1. **Product identifier**: `wealthscope_monthly`
2. **Store**: Selecciona **"Test Store"**
3. **Type**: Selecciona **"Subscription"**
4. **Subscription group**: (déjalo vacío o crea uno llamado "wealthscope_subs")
5. Haz clic en **"Save"**
6. Dentro del producto, configura:
   - **Display name**: "Premium Mensual"
   - **Description**: "Acceso premium por mes"
   - **Price**: `1.00`
   - **Currency**: `USD`
   - **Duration**: `1 month`
7. Guarda los cambios

#### Paso 3.3: Crear Plan Anual ($10 USD)
1. Repite el paso anterior, pero con:
   - **Product identifier**: `wealthscope_yearly`
   - **Display name**: "Premium Anual"
   - **Description**: "Acceso premium por año - Ahorra 83%"
   - **Price**: `10.00`
   - **Currency**: `USD`
   - **Duration**: `1 year`
2. Guarda los cambios

### 4. Crea el Entitlement (Permiso)

Un "entitlement" es lo que verificas en tu código para saber si el usuario tiene premium.

#### Paso 4.1: Crear el entitlement
1. En el menú lateral, ve a **"Entitlements"**
2. Haz clic en **"+ New"**
3. **Identifier**: `premium` (⚠️ Importante: debe ser exactamente "premium")
4. **Display name**: "Premium Access"
5. Haz clic en **"Save"**

#### Paso 4.2: Asociar productos al entitlement
1. Dentro del entitlement "premium", busca la sección **"Attached Products"**
2. Haz clic en **"Attach"**
3. Selecciona ambos productos:
   - ✅ `wealthscope_monthly`
   - ✅ `wealthscope_yearly`
4. Guarda los cambios

### 5. Crea el Offering (Oferta)

Los "offerings" agrupan tus planes y determinan qué se muestra en tu app.

#### Paso 5.1: Crear el offering
1. En el menú lateral, ve a **"Offerings"**
2. Haz clic en **"+ New"**
3. **Identifier**: `default`
4. **Description**: "WealthScope Premium Plans"
5. Marca como **"Current offering"** ✅
6. Haz clic en **"Save"**

#### Paso 5.2: Agregar paquetes al offering
1. Dentro del offering, haz clic en **"+ Add Package"**
2. Para el plan mensual:
   - **Package name**: `monthly` (o usa el preset "$rc_monthly")
   - **Product**: Selecciona `wealthscope_monthly`
   - Guarda
3. Haz clic en **"+ Add Package"** otra vez
4. Para el plan anual:
   - **Package name**: `annual` (o usa el preset "$rc_annual")
   - **Product**: Selecciona `wealthscope_yearly`
   - Guarda

### 6. Configura las API Keys

#### Paso 6.1: Obtén tu API Key
1. En el menú lateral, ve a **"API Keys"**
2. Copia el **"Public app-specific API key"**
3. ⚠️ **NUNCA uses la Secret Key en tu app**

#### Paso 6.2: Actualiza tu código
Abre el archivo: `lib/features/subscriptions/data/services/revenuecat_service.dart`

Reemplaza esta línea:
```dart
static const String _appleApiKey = 'YOUR_APPLE_API_KEY';
```

Con tu API key real:
```dart
static const String _appleApiKey = 'appl_xxxxxxxxxx'; // Tu API key
```

Para desarrollo (Test Store), puedes usar la misma key en las 3 constantes:
```dart
static const String _testStoreApiKey = 'appl_xxxxxxxxxx';
static const String _appleApiKey = 'appl_xxxxxxxxxx';
static const String _googleApiKey = 'appl_xxxxxxxxxx';
```

### 7. 🎉 ¡Listo! Prueba tu app

1. Detén tu app completamente (si está corriendo)
2. Ejecuta: `flutter run -d chrome --dart-define-from-file=.env`
3. Ve a la pantalla de suscripciones
4. Deberías ver tus dos planes: Mensual ($1) y Anual ($10)

---

## 📝 Resumen de lo que creaste

| Elemento | Identifier | Descripción |
|----------|-----------|-------------|
| **Producto 1** | `wealthscope_monthly` | Plan mensual - $1 USD |
| **Producto 2** | `wealthscope_yearly` | Plan anual - $10 USD |
| **Entitlement** | `premium` | Permiso de acceso premium |
| **Offering** | `default` | Agrupación de planes (marcado como current) |
| **Packages** | `monthly`, `annual` | Paquetes dentro del offering |

---

## 🧪 Probar las compras

Con Test Store, las "compras" son completamente ficticias:
- ✅ No se cobra dinero real
- ✅ Puedes "comprar" cuantas veces quieras
- ✅ Funciona exactamente como producción
- ✅ Puedes probar renovaciones, cancelaciones, etc.

### En el dashboard de RevenueCat:
1. Ve a **"Customers"** → **"Customer Lists"**
2. Podrás ver tu usuario y sus suscripciones activas
3. Puedes revocar manualmente las suscripciones para probar expiración

---

## ❓ Troubleshooting

### No veo mis productos en la app
1. Verifica que el offering "default" está marcado como **"Current"**
2. Verifica que ambos productos están asociados al entitlement "premium"
3. Revisa los logs en la consola de Flutter (busca mensajes de RevenueCat)
4. Intenta hacer hot restart (R en la terminal)

### Error: "SDK not configured"
- Verifica que copiaste la API key correctamente en `revenuecat_service.dart`
- Asegúrate de que no tiene espacios extra al inicio o final
- La app debe reiniciarse completamente (no hot reload)

### Los precios no se muestran
- Espera 1-2 minutos después de crear los productos
- Cierra y vuelve a abrir la app
- Verifica en el dashboard que los productos tienen precio configurado

---

## 🚀 Próximos pasos

Una vez que todo funcione con Test Store:
1. Conecta tu cuenta de Apple App Store Connect
2. Conecta tu cuenta de Google Play Console
3. Crea los mismos productos en las tiendas reales
4. Actualiza las API keys específicas de cada plataforma
