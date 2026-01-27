# Configuración de Variables de Entorno

## 🎯 Opción 1: Editar Directamente (Más Simple)

Para el hackathon, la forma más rápida:

1. Abre el archivo [`lib/core/constants/app_config.dart`](lib/core/constants/app_config.dart)
2. Cambia el `defaultValue` de las constantes:

```dart
static const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:3000', // 👈 Cambia esto
);
```

✅ **Ventaja**: No requiere setup adicional  
⚠️ **Desventaja**: No puedes tener múltiples ambientes fácilmente

---

## 🚀 Opción 2: Usar Variables de Entorno (Recomendado)

### Paso 1: Configurar el archivo `.env`

1. Copia [`.env.example`](.env.example) → `.env`
2. Edita [`.env`](.env) con tus valores reales:

```env
API_BASE_URL=http://localhost:3000
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu-anon-key-aqui
ENVIRONMENT=development
```

### Paso 2: Ejecutar con Variables

**Para Development:**
```bash
flutter run --dart-define-from-file=.env
```

**Para Production:**
```bash
flutter run --dart-define-from-file=.env.production
```

### Paso 3: (Opcional) Configurar VS Code

Crea `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "WealthScope (Dev)",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define-from-file=.env"
      ]
    }
  ]
}
```

---

## 📝 Valores Actuales

Los valores por defecto están en [`app_config.dart`](lib/core/constants/app_config.dart):

- **API Base URL**: `http://localhost:3000`
- **Supabase URL**: Por configurar
- **Supabase Anon Key**: Por configurar
- **Environment**: `development`

---

## 🔒 Seguridad

⚠️ **NUNCA** commitees el archivo `.env` con keys reales  
✅ El `.gitignore` ya está configurado para ignorarlo
