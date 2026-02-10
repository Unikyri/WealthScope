### 🚀 CHECKLIST: Implementación RevenueCat en WealthScope

#### ✅ Fase 1: Instalación y Configuración Inicial

- [ ] **1.1** Ejecutar `flutter pub get` para instalar dependencias
- [ ] **1.2** Ejecutar `flutter pub run build_runner build --delete-conflicting-outputs` para generar código Freezed
- [ ] **1.3** Crear cuenta en [RevenueCat](https://app.revenuecat.com/) si no la tienes
- [ ] **1.4** Crear un nuevo proyecto en RevenueCat

#### ✅ Fase 2: Configuración de RevenueCat Dashboard

- [ ] **2.1** Copiar las API Keys del dashboard:
  - [ ] Test Store API Key
  - [ ] Apple API Key (si usas iOS)
  - [ ] Google API Key (si usas Android)
  
- [ ] **2.2** Pegar las API Keys en `revenuecat_service.dart`:
  ```dart
  static const String _testStoreApiKey = 'TU_KEY_AQUI';
  static const String _appleApiKey = 'TU_KEY_AQUI';
  static const String _googleApiKey = 'TU_KEY_AQUI';
  ```

- [ ] **2.3** Crear Entitlement llamado `premium` en el dashboard

- [ ] **2.4** Crear productos en Test Store:
  - [ ] Producto mensual (ej: wealthscope_monthly)
  - [ ] Producto anual (ej: wealthscope_annual)
  - [ ] Producto vitalicio opcional (ej: wealthscope_lifetime)

- [ ] **2.5** Crear Offering llamado `default`

- [ ] **2.6** Agregar los productos al offering y asociarlos con el entitlement `premium`

#### ✅ Fase 3: Inicialización en la App

- [ ] **3.1** Abrir `main.dart` (o donde inicializas tu app)

- [ ] **3.2** Importar RevenueCat:
  ```dart
  import 'package:wealthscope_app/features/subscriptions/init_revenuecat.dart';
  ```

- [ ] **3.3** Inicializar RevenueCat en `main()` o `initState()`:
  ```dart
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeRevenueCat(ref);
    });
  }
  ```

#### ✅ Fase 4: Testing Básico

- [ ] **4.1** Ejecutar la app en modo debug
- [ ] **4.2** Verificar logs de inicialización: "✅ RevenueCat initialized successfully"
- [ ] **4.3** Navegar al Dashboard
- [ ] **4.4** Verificar que aparece el badge "Obtener Premium"
- [ ] **4.5** Click en el badge para abrir la pantalla de suscripciones
- [ ] **4.6** Verificar que se muestran los planes disponibles
- [ ] **4.7** Intentar una compra de prueba (Test Store no cobra dinero real)
- [ ] **4.8** Verificar que después de la compra el badge cambia a "Premium"

#### ✅ Fase 5: Integración de Features Premium

- [ ] **5.1** Decidir qué funciones serán premium:
  - [ ] Consultas AI ilimitadas
  - [ ] Simulaciones What-If avanzadas
  - [ ] Alertas personalizadas
  - [ ] Noticias premium
  - [ ] Sincronización en la nube
  - [ ] Otras: ________________

- [ ] **5.2** Implementar checks de premium en cada feature (ver `INTEGRATION_EXAMPLES.dart`)

- [ ] **5.3** Agregar badges/locks visuales donde corresponda

- [ ] **5.4** Probar cada feature en modo free y premium

#### ✅ Fase 6: Configuración de Stores Reales (Producción)

##### iOS (App Store)
- [ ] **6.1** Crear app en App Store Connect
- [ ] **6.2** Configurar In-App Purchases en App Store Connect
- [ ] **6.3** Crear productos con IDs exactos a RevenueCat
- [ ] **6.4** Conectar app en RevenueCat Dashboard
- [ ] **6.5** Verificar Bundle ID coincida
- [ ] **6.6** Crear usuarios de prueba en App Store Connect
- [ ] **6.7** Probar compras en TestFlight

##### Android (Google Play)
- [ ] **6.8** Crear app en Google Play Console
- [ ] **6.9** Configurar productos en Google Play Console
- [ ] **6.10** Crear productos con IDs exactos a RevenueCat
- [ ] **6.11** Conectar app en RevenueCat Dashboard
- [ ] **6.12** Verificar Package Name coincida
- [ ] **6.13** Agregar cuentas de prueba
- [ ] **6.14** Probar en Internal Testing

#### ✅ Fase 7: Configuración Avanzada

- [ ] **7.1** Configurar diferentes API Keys para debug/release:
  ```dart
  static const String _apiKey = kDebugMode 
    ? 'TEST_STORE_KEY'
    : Platform.isIOS ? 'APPLE_KEY' : 'GOOGLE_KEY';
  ```

- [ ] **7.2** Implementar manejo de promociones (opcional)
- [ ] **7.3** Configurar trials gratuitos (opcional)
- [ ] **7.4** Implementar ofertas introductivas (opcional)
- [ ] **7.5** Configurar webhooks para backend sync (opcional)

#### ✅ Fase 8: Testing Final

- [ ] **8.1** Probar flujo completo de compra
- [ ] **8.2** Probar restauración de compras
- [ ] **8.3** Probar en diferentes dispositivos
- [ ] **8.4** Verificar que features premium funcionan correctamente
- [ ] **8.5** Verificar que features free están limitadas correctamente
- [ ] **8.6** Probar logout/login con suscripción activa
- [ ] **8.7** Verificar sincronización entre dispositivos

#### ✅ Fase 9: Deployment

- [ ] **9.1** ⚠️ **CRÍTICO**: Cambiar a API Keys de producción (NO Test Store)
- [ ] **9.2** Revisar que NO hay logs de debug en producción
- [ ] **9.3** Probar build de release
- [ ] **9.4** Revisar términos y condiciones de suscripción
- [ ] **9.5** Agregar links de políticas en la app
- [ ] **9.6** Configurar descripciones de productos
- [ ] **9.7** Submit a App Store / Google Play

#### ✅ Fase 10: Monitoreo Post-Launch

- [ ] **10.1** Configurar alertas en RevenueCat
- [ ] **10.2** Monitorear métricas de conversión
- [ ] **10.3** Revisar errores de compra
- [ ] **10.4** Analizar churn rate
- [ ] **10.5** Optimizar ofertas basado en datos

---

## 🎯 Quick Start (Testing Inmediato)

Si solo quieres probar rápidamente:

1. ✅ `flutter pub get`
2. ✅ `flutter pub run build_runner build`
3. ✅ Agregar Test Store API Key en `revenuecat_service.dart`
4. ✅ Inicializar en `main.dart`
5. ✅ Ejecutar app y navegar a `/subscription`

---

## 📝 Notas Importantes

- **Test Store** es suficiente para desarrollo completo
- No necesitas configurar App Store/Google Play hasta production
- Los productos de Test Store se pueden usar inmediatamente
- Las compras de Test Store NO cobran dinero real
- Puedes cambiar entre Test Store y stores reales solo cambiando el API Key

---

## 🆘 Ayuda

- 📚 Documentación: [docs.revenuecat.com](https://docs.revenuecat.com/)
- 💬 Community: [community.revenuecat.com](https://community.revenuecat.com/)
- 📧 Support: support@revenuecat.com

---

**Última actualización**: Febrero 2026
**Versión SDK**: purchases_flutter ^9.8.0
