# WealthScope Frontend - Feature-First Structure

## 📂 Estructura Creada

```
lib/
├── main.dart                    # Entry point con ProviderScope
├── app/                         # Configuración de la aplicación
│   ├── app.dart                # MaterialApp setup con GoRouter
│   └── router.dart             # Re-exporta AppRouter
├── core/                        # Lógica compartida entre features
│   ├── constants/
│   │   └── app_constants.dart  # Constantes globales
│   ├── errors/
│   │   └── failures.dart       # Clases de error/fallo
│   ├── network/
│   │   └── dio_client.dart     # Cliente HTTP centralizado
│   ├── router/
│   │   └── app_router.dart     # Configuración de GoRouter
│   ├── theme/
│   │   └── app_theme.dart      # Tema light/dark
│   └── utils/
│       └── logger.dart         # Utilidad de logging
├── shared/                      # Widgets y providers compartidos
│   ├── widgets/
│   │   ├── error_view.dart     # Widget de error reutilizable
│   │   └── loading_view.dart   # Widget de loading reutilizable
│   └── providers/
│       └── .gitkeep
└── features/                    # Features organizados por dominio
    ├── auth/                   # Autenticación
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── assets/                 # Gestión de activos
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── dashboard/              # Dashboard principal
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    └── profile/                # Perfil de usuario
        ├── data/
        ├── domain/
        └── presentation/
```

## ✅ Criterios de Aceptación Cumplidos

- ✅ Todas las carpetas existen
- ✅ Cada feature tiene subcarpetas: `data/`, `domain/`, `presentation/`
- ✅ Archivos `.gitkeep` o placeholder en cada carpeta
- ✅ Estructura sigue Scream Architecture (feature-first)
- ✅ Configuración inicial de Riverpod (ProviderScope en main.dart)
- ✅ GoRouter configurado
- ✅ Tema Material 3 configurado
- ✅ Cliente Dio configurado

## 🎯 Próximos Pasos

1. Instalar dependencias necesarias en `pubspec.yaml`:
   - `flutter_riverpod`
   - `riverpod_annotation`
   - `go_router`
   - `dio`
   - `freezed` (para modelos)
   - `json_serializable` (para JSON)

2. Implementar cada feature siguiendo el flujo:
   - Domain: Entidades y contratos de repositorios
   - Data: Implementación de repositorios y data sources
   - Presentation: Screens, widgets y providers

3. Ejecutar code generation cuando sea necesario:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

## 📖 Referencias

- [AGENTS.md](./AGENTS.md) - Contexto del proyecto y arquitectura
- [RULES.md](./RULES.md) - Reglas estrictas del proyecto
- [SKILLS.md](./SKILLS.md) - Procedimientos estándar
