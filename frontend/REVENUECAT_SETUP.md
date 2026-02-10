# Implementación de RevenueCat en WealthScope

## ✅ Archivos Creados

### 1. **Modelos** (`features/subscriptions/domain/models/`)
- `subscription_models.dart` - Modelos Freezed para subscripciones

### 2. **Servicios** (`features/subscriptions/data/services/`)
- `revenuecat_service.dart` - Servicio principal de RevenueCat con providers

### 3. **Pantallas** (`features/subscriptions/presentation/screens/`)
- `subscription_screen.dart` - Pantalla de paywall/suscripciones

### 4. **Widgets** (`features/subscriptions/presentation/widgets/`)
- `premium_widgets.dart` - Badge Premium y Widget de bloqueo de funciones

### 5. **Inicialización** (`features/subscriptions/`)
- `init_revenuecat.dart` - Inicialización del SDK

## 📦 Dependencias Agregadas

```yaml
purchases_flutter: ^9.8.0
purchases_ui_flutter: ^9.8.0
```

## 🔧 Configuración Requerida

### 1. Instalar Dependencias

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Configurar API Keys

Edita el archivo `revenuecat_service.dart` y reemplaza las keys:

```dart
static const String _testStoreApiKey = 'TU_TEST_STORE_API_KEY';
static const String _appleApiKey = 'TU_APPLE_API_KEY';
static const String _googleApiKey = 'TU_GOOGLE_API_KEY';
```

**Dónde encontrar las API Keys:**
1. Ve al [Dashboard de RevenueCat](https://app.revenuecat.com/)
2. Selecciona tu proyecto
3. Ve a **Project Settings > API Keys**
4. Copia las keys correspondientes:
   - **Test Store API Key** (para desarrollo)
   - **iOS/Apple API Key** (App Store)
   - **Android/Google API Key** (Google Play)

### 3. Inicializar RevenueCat

En tu `main.dart` o donde inicializas la app:

```dart
import 'package:wealthscope_app/features/subscriptions/init_revenuecat.dart';

// En tu main() o initState():
Future<void> init() async {
  // ... otros inits
  
  // Inicializar RevenueCat
  await initializeRevenueCat(ref);
}
```

### 4. Configurar Productos en RevenueCat Dashboard

#### Opción A: Test Store (Recomendado para desarrollo)
1. Ve a **Products > Test Store**
2. Crea productos de prueba
3. Configura entitlements (ej: "premium")
4. Crea offerings

#### Opción B: Conectar Stores Reales
1. **iOS (App Store Connect)**:
   - Ve a **Project Settings > Apps**
   - Conecta tu app de iOS
   - Bundle ID debe coincidir
   
2. **Android (Google Play Console)**:
   - Conecta tu app de Android
   - Package name debe coincidir

### 5. Configurar Entitlements

1. Ve a **Entitlements** en el dashboard
2. Crea un entitlement llamado `premium` (o cambia el ID en `revenuecat_service.dart`)
3. Asocia los productos a este entitlement

### 6. Configurar Offerings

1. Ve a **Offerings**
2. Crea un offering llamado `default`
3. Agrega tus packages (monthly, annual, etc.)

## 🎯 Uso en la App

### Verificar si el usuario es Premium

```dart
// En cualquier widget
final isPremium = await ref.read(revenueCatServiceProvider).isPremium();

// O usando el provider
final isPremiumAsync = ref.watch(isPremiumProvider);
isPremiumAsync.when(
  data: (isPremium) {
    if (isPremium) {
      // Usuario tiene premium
    }
  },
  loading: () => CircularProgressIndicator(),
  error: (_, __) => Text('Error'),
);
```

### Mostrar Paywall

```dart
// Navegar a la pantalla de suscripciones
context.push('/subscription');

// O mostrar el badge
PremiumBadge()  // Ya agregado en el Dashboard
```

### Bloquear Funciones Premium

```dart
// Mostrar lock para funciones premium
return isPremium 
  ? FeaturePremiumWidget()  // Tu widget premium
  : PremiumFeatureLock(
      featureName: 'Análisis AI Avanzado',
      description: 'Desbloquea análisis ilimitado con Premium',
    );
```

## 🧪 Testing

### Test Store
- Usa el Test Store API Key durante desarrollo
- No se cobra dinero real
- Funciona inmediatamente sin configuración adicional
- Perfecto para probar flujos de compra

### Sandbox Testing (iOS/Android)
1. **iOS**: Crea usuarios de prueba en App Store Connect
2. **Android**: Usa cuentas de prueba en Google Play Console
3. Cambia al API key correspondiente (iOS/Android)

## 📱 Plataformas Soportadas

- ✅ iOS
- ✅ Android
- ✅ Web (limitado)
- ❌ macOS (requiere configuración adicional)
- ❌ Windows (no soportado)

## 🔐 Seguridad

### Importante ⚠️
- **NUNCA** subas tu app a producción con Test Store API Key
- Usa build configurations para diferenciar dev/prod:

```dart
// Ejemplo de configuración
static const String _apiKey = kDebugMode 
  ? 'TEST_STORE_KEY'     // Development
  : Platform.isIOS
    ? 'APPLE_API_KEY'    // iOS Production
    : 'GOOGLE_API_KEY';  // Android Production
```

## 🎨 Features Implementadas

### ✅ Pantalla de Suscripciones
- Vista elegante con gradientes
- Lista de features premium
- Selección de packages
- Botón de compra
- Restaurar compras
- Vista de estado premium activo

### ✅ Premium Badge
- Muestra estado premium en Dashboard
- Click para abrir pantalla de suscripciones
- Diseño con gradiente y shadow

### ✅ Premium Feature Lock
- Widget para bloquear funciones
- Descripción personalizable
- Botón para obtener premium

### ✅ Providers Riverpod
- `revenueCatServiceProvider` - Servicio singleton
- `customerInfoProvider` - Info del cliente
- `isPremiumProvider` - Estado premium
- `offeringsProvider` - Offerings disponibles

## 📚 Recursos

- [RevenueCat Docs](https://docs.revenuecat.com/)
- [RevenueCat Dashboard](https://app.revenuecat.com/)
- [Flutter SDK Docs](https://docs.revenuecat.com/docs/flutter)

## 🐛 Troubleshooting

### "No offerings found"
- Verifica que hayas configurado offerings en el dashboard
- Asegúrate de estar usando el API key correcto
- Revisa los logs: `Purchases.setLogLevel(LogLevel.debug)`

### "Purchase failed"
- Verifica permisos de in-app purchases
- En iOS: verifica que el Bundle ID coincida
- En Android: verifica que el Package Name coincida
- Asegúrate de estar usando usuario de prueba en sandbox

### "Invalid API Key"
- Verifica que el API key sea correcto
- Asegúrate de usar el key correspondiente a la plataforma

## 🚀 Próximos Pasos

1. **Generar código Freezed**: `flutter pub run build_runner build`
2. **Configurar API Keys** en `revenuecat_service.dart`
3. **Crear productos** en RevenueCat Dashboard
4. **Configurar entitlements** (premium)
5. **Crear offerings** (default)
6. **Inicializar SDK** en `main.dart`
7. **Probar flujo** con Test Store

## 💡 Tips

- Usa **Test Store** durante todo el desarrollo
- Configura **diferentes tiers** de suscripción (monthly, annual)
- Implementa **trials gratuitos** para aumentar conversión
- Monitorea **métricas** en el dashboard de RevenueCat
- Usa **webhooks** para sincronizar con tu backend

---

**Nota**: Recuerda ejecutar `flutter pub get` y generar el código de Freezed antes de usar la app.
