# 💰 Planes de Suscripción - WealthScope

## Productos a crear en RevenueCat Test Store

### Plan Mensual
```
Product ID: wealthscope_monthly
Tipo: Subscription
Precio: $1.00 USD
Duración: 1 month
Display Name: Premium Mensual
Descripción: Acceso premium por mes
```

### Plan Anual (Mejor Valor)
```
Product ID: wealthscope_yearly
Tipo: Subscription
Precio: $10.00 USD
Duración: 1 year
Display Name: Premium Anual
Descripción: Acceso premium por año - Ahorra 83%
```

## Configuración Requerida

### 1. Entitlement
```
Identifier: premium
Display Name: Premium Access
Productos asociados: 
  - wealthscope_monthly
  - wealthscope_yearly
```

### 2. Offering
```
Identifier: default
Descripción: WealthScope Premium Plans
Marcar como: Current Offering ✓

Packages:
  - monthly → wealthscope_monthly
  - annual → wealthscope_yearly
```

## Comparación de Planes

| Plan | Precio | Precio/Mes | Ahorro |
|------|--------|------------|--------|
| Mensual | $1.00 USD | $1.00 | - |
| Anual | $10.00 USD | $0.83 | 83% |

## Beneficios Premium

✨ Análisis AI Ilimitado
📈 Simulaciones What-If Avanzadas  
🔔 Alertas Personalizadas
📰 Noticias Premium
☁️ Sincronización en la Nube
🛡️ Soporte Prioritario

## Enlaces Rápidos

- Dashboard: https://app.revenuecat.com
- Guía completa: Ver `REVENUECAT_TEST_STORE_SETUP.md`
- Test Store: Pre-configurada, no requiere App Store Connect

## Comandos después de configurar

```bash
# 1. Hot restart para recargar configuración
R (en terminal de flutter)

# O reiniciar completamente
flutter run -d chrome --dart-define-from-file=.env
```

## Verificación

Una vez configurado, deberías ver:
1. ✅ Dos planes en la pantalla de suscripción
2. ✅ Badge "MEJOR VALOR" en el plan anual
3. ✅ Precio mensual equivalente ($0.83/mes) en plan anual
4. ✅ Badge verde "Ahorra 83%" en plan anual
5. ✅ Poder seleccionar y "comprar" (sin cargos reales)

## Troubleshooting

**No veo los planes:**
- Verifica que offering "default" esté marcado como "Current"
- Espera 1-2 minutos y recarga la app
- Revisa logs en consola (busca mensajes RevenueCat)

**Error "SDK not configured":**
- Actualiza API key en `revenuecat_service.dart`
- Reinicia la app completamente (no hot reload)

**Precios no se muestran:**
- Asegúrate de configurar precio y moneda en cada producto
- Verifica que los productos estén asociados al entitlement
