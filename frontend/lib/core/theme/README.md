# WealthScope Design System

## 🎨 Brand Colors

```dart
AppTheme.primaryColor    // #1E3A5F - Navy Blue
AppTheme.secondaryColor  // #3D8B7F - Teal
AppTheme.accentColor     // #FFB800 - Gold
AppTheme.errorColor      // #E53935 - Red
AppTheme.successColor    // #43A047 - Green
```

### Usage in Widgets
❌ **NEVER do this:**
```dart
Container(color: Color(0xFF1E3A5F))
```

✅ **ALWAYS use theme:**
```dart
Container(color: Theme.of(context).colorScheme.primary)
Container(color: Theme.of(context).colorScheme.secondary)
Container(color: Theme.of(context).colorScheme.tertiary) // accent
```

## 📏 Spacing (8px base unit)

```dart
AppTheme.spacingXs   // 4px
AppTheme.spacingSm   // 8px
AppTheme.spacingMd   // 16px
AppTheme.spacingLg   // 24px
AppTheme.spacingXl   // 32px
AppTheme.spacingXxl  // 48px
```

### Examples
```dart
// Padding
Padding(
  padding: EdgeInsets.all(AppTheme.spacingMd),
  child: ...,
)

// Gap between widgets
SizedBox(height: AppTheme.spacingSm)
```

## 🔘 Border Radius

```dart
AppTheme.radiusXs    // 4px
AppTheme.radiusSm    // 8px
AppTheme.radiusMd    // 12px
AppTheme.radiusLg    // 16px
AppTheme.radiusXl    // 24px
AppTheme.radiusFull  // 999px - Circular
```

### Examples
```dart
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
  ),
)
```

## 🌑 Shadows

```dart
AppTheme.shadowSm  // Subtle shadow
AppTheme.shadowMd  // Medium shadow
AppTheme.shadowLg  // Large shadow
```

### Examples
```dart
Container(
  decoration: BoxDecoration(
    boxShadow: AppTheme.shadowMd,
  ),
)
```

## 🔤 Typography

Use theme text styles instead of hardcoding:

```dart
// Display (Large headings)
Text('Title', style: Theme.of(context).textTheme.displayLarge)

// Headlines
Text('Section', style: Theme.of(context).textTheme.headlineMedium)

// Body text
Text('Content', style: Theme.of(context).textTheme.bodyMedium)

// Labels
Text('Small', style: Theme.of(context).textTheme.labelSmall)
```

## 🎯 Theme Application

The theme is automatically applied in [app.dart](../../app/app.dart):

```dart
MaterialApp.router(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system, // Respects device settings
)
```

## ✅ Best Practices

1. **Never hardcode colors** - Always use `Theme.of(context).colorScheme.*`
2. **Use spacing constants** - Maintain visual consistency
3. **Follow Material 3 patterns** - Leverage built-in components
4. **Test in dark mode** - Ensure readability in both themes
5. **Use semantic colors** - `primary` for CTAs, `error` for errors, etc.
