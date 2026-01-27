# Auth Feature - AuthService

## Descripción
El `AuthService` encapsula todas las operaciones de autenticación con Supabase, siguiendo la arquitectura Feature-First de WealthScope.

## Estructura
```
features/auth/data/
├── services/
│   └── auth_service.dart          # Servicio de autenticación
├── providers/
│   ├── auth_service_provider.dart # Providers de Riverpod
│   └── auth_service_provider.g.dart (generado)
└── auth_data.dart                  # Barrel file
```

## Uso

### 1. Acceder al AuthService
```dart
// En un ConsumerWidget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    // Usar authService...
  }
}
```

### 2. Sign Up
```dart
try {
  final authService = ref.read(authServiceProvider);
  final response = await authService.signUp(
    email: 'user@example.com',
    password: 'password123',
  );
  // Manejar respuesta exitosa
} catch (e) {
  // Manejar error
}
```

### 3. Sign In
```dart
try {
  final authService = ref.read(authServiceProvider);
  final response = await authService.signIn(
    email: 'user@example.com',
    password: 'password123',
  );
  // Manejar respuesta exitosa
} catch (e) {
  // Manejar error
}
```

### 4. Sign Out
```dart
try {
  final authService = ref.read(authServiceProvider);
  await authService.signOut();
  // Usuario desconectado
} catch (e) {
  // Manejar error
}
```

### 5. Obtener Usuario Actual
```dart
// Opción 1: Usando el provider
final currentUser = ref.watch(currentUserProvider);
if (currentUser != null) {
  print('Usuario: ${currentUser.email}');
}

// Opción 2: Directamente desde el servicio
final authService = ref.read(authServiceProvider);
final user = authService.currentUser;
```

### 6. Escuchar Cambios de Estado
```dart
class AuthStateWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateStream = ref.watch(authStateChangesProvider);
    
    return authStateStream.when(
      data: (authState) {
        if (authState.session != null) {
          return Text('Usuario autenticado: ${authState.session!.user.email}');
        } else {
          return Text('No hay sesión activa');
        }
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

## Providers Disponibles

### `authServiceProvider`
Proveedor del servicio de autenticación.
- **Tipo**: `Provider<AuthService>`
- **Uso**: `ref.watch(authServiceProvider)` o `ref.read(authServiceProvider)`

### `currentUserProvider`
Proveedor del usuario actual autenticado.
- **Tipo**: `Provider<User?>`
- **Uso**: `ref.watch(currentUserProvider)`

### `authStateChangesProvider`
Proveedor del stream de cambios de estado de autenticación.
- **Tipo**: `StreamProvider<AuthState>`
- **Uso**: `ref.watch(authStateChangesProvider)`

## Criterios de Aceptación ✅

- [x] Métodos `signUp`, `signIn`, `signOut` implementados
- [x] Getter para usuario actual (`currentUser`)
- [x] Stream de cambios de estado de auth (`authStateChanges`)
- [x] Providers configurados con `@riverpod`
- [x] Código generado con `build_runner`
- [x] Sin errores de linting

## Notas Técnicas

- **Riverpod 2.x**: Usa sintaxis de generadores con `@riverpod`
- **Supabase Flutter**: Versión 2.0.0
- **AutoDispose**: Los providers se limpian automáticamente cuando no se usan
- **Type-Safe**: Los providers son type-safe gracias a la generación de código

## Siguiente Paso
Implementar los controladores de presentación que usen este servicio para la UI de login/registro.
