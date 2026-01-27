# Register Screen - Auth Feature

## Descripción
Pantalla de registro completa que permite a los usuarios crear una nueva cuenta en WealthScope.

## Estructura
```
features/auth/presentation/
├── providers/
│   ├── register_provider.dart         # Lógica del formulario de registro
│   └── register_provider.g.dart       # Código generado
├── screens/
│   └── register_screen.dart           # UI de registro
└── auth_presentation.dart              # Barrel file
```

## Características Implementadas ✅

### UI Elements
- ✅ Logo de WealthScope (placeholder icon)
- ✅ Título "Crear cuenta"
- ✅ Subtítulo "Comienza a gestionar tu riqueza"
- ✅ Campo de email con validación
- ✅ Campo de contraseña con toggle de visibilidad
- ✅ Campo de confirmar contraseña con toggle de visibilidad
- ✅ Checkbox de términos y condiciones
- ✅ Botón "Crear cuenta" (primario)
- ✅ Link "Ya tengo cuenta" → navegar a login

### Estados Manejados
- ✅ **Loading**: Botón deshabilitado con spinner
- ✅ **Error**: Mensaje de error en SnackBar
- ✅ **Success**: Navega automáticamente a dashboard

### Validaciones
- ✅ Email requerido y formato válido
- ✅ Contraseña mínimo 6 caracteres
- ✅ Confirmación de contraseña coincide
- ✅ Términos y condiciones aceptados
- ✅ Campos no vacíos

### Características Adicionales
- ✅ Diseño responsive
- ✅ Keyboard dismiss al hacer scroll
- ✅ Form validation con GlobalKey
- ✅ Gestión de estado con Riverpod
- ✅ Theming correcto (sin colores hardcodeados)
- ✅ Accessible (labels, hints, etc.)

## Uso

### Navegación
```dart
// Navegar a registro
context.go('/register');

// Desde registro a login
context.go('/login');
```

### Provider
El `RegisterNotifier` maneja toda la lógica:

```dart
// Observar estado
final registerState = ref.watch(registerNotifierProvider);

// Toggle password visibility
ref.read(registerNotifierProvider.notifier).togglePasswordVisibility();

// Registrar usuario
final success = await ref.read(registerNotifierProvider.notifier).register(
  email: 'user@example.com',
  password: 'password123',
  confirmPassword: 'password123',
);
```

## Flujo de Registro

1. **Usuario completa formulario**
   - Email
   - Contraseña
   - Confirmar contraseña
   - Acepta términos

2. **Usuario presiona "Crear cuenta"**
   - Validación de formulario (Form validation)
   - Validación de negocio (RegisterNotifier)

3. **RegisterNotifier procesa**
   - Valida inputs
   - Llama a `AuthService.signUp()`
   - Maneja respuesta/error

4. **Resultado**
   - **Éxito**: Navega a `/dashboard`
   - **Error**: Muestra SnackBar con mensaje

## Mensajes de Error

| Error | Mensaje |
|-------|---------|
| Campos vacíos | "Todos los campos son requeridos" |
| Email inválido | "Email inválido" |
| Contraseña corta | "La contraseña debe tener al menos 6 caracteres" |
| Contraseñas no coinciden | "Las contraseñas no coinciden" |
| Términos no aceptados | "Debes aceptar los términos y condiciones" |
| Email ya registrado | "Este email ya está registrado" |
| Error genérico | "Error al crear la cuenta. Intenta nuevamente." |

## Diseño

### Layout
- Scroll vertical para adaptarse a teclado
- Padding horizontal: 24px
- Espaciado entre elementos: 16-24px
- Logo centrado arriba
- Campos apilados verticalmente

### Componentes
- **TextFormField**: Bordes redondeados (12px)
- **FilledButton**: Padding vertical 16px, bordes redondeados (12px)
- **CheckboxListTile**: Términos con link destacado
- **SnackBar**: Floating, color de error del tema

### Colores
Todos los colores usan `Theme.of(context).colorScheme.*`:
- `primary`: Botones, iconos principales, links
- `onPrimary`: Texto sobre primary
- `surface`: Fondo
- `onSurface`: Texto principal
- `onSurfaceVariant`: Texto secundario
- `primaryContainer`: Fondo del logo
- `error`: Mensajes de error

## Arquitectura

### Clean Architecture (Feature-First)
```
Presentation Layer (UI)
    ↓
RegisterNotifier (Business Logic)
    ↓
AuthService (Data Layer)
    ↓
Supabase Client
```

### Riverpod State Management
- **RegisterNotifier**: `AutoDisposeNotifier<RegisterState>`
- **State Class**: `RegisterState` (immutable con copyWith)
- **Provider**: `registerNotifierProvider`

## Testing Checklist

- [ ] Validación de email
- [ ] Validación de contraseña
- [ ] Comparación de contraseñas
- [ ] Toggle de visibilidad funciona
- [ ] Checkbox de términos funciona
- [ ] Navegación a login funciona
- [ ] Loading state funciona
- [ ] Error messages funcionan
- [ ] Success navigation funciona
- [ ] Responsive en diferentes tamaños

## Próximos Pasos

1. Crear LoginScreen (similar estructura)
2. Crear DashboardScreen (destino tras registro)
3. Implementar verificación de email
4. Agregar pantalla de términos y condiciones
5. Mejorar logo (usar asset real)
6. Agregar animaciones (flutter_animate)
7. Implementar reset de contraseña

## Notas Técnicas

- **ConsumerStatefulWidget**: Necesario para TextEditingController y Form
- **Form + GlobalKey**: Validación integrada de Flutter
- **ref.listen**: Para side-effects (SnackBar)
- **context.go()**: GoRouter navigation
- **AutoDispose**: Providers se limpian automáticamente
- **Type-Safe**: Gracias a code generation

## Dependencias

- ✅ supabase_flutter: 2.0.0
- ✅ flutter_riverpod: 2.6.1
- ✅ riverpod_annotation: 2.6.1
- ✅ go_router: 14.8.1

---

**Issue**: [T-2.1.5] Crear pantalla de registro UI #34  
**Tiempo Estimado**: 3 horas  
**Estado**: ✅ Completado
