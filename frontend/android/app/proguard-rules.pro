# =============================================================================
# ProGuard Rules para WealthScope - Producción
# =============================================================================

# -----------------------------------------------------------------------------
# Flutter Core
# -----------------------------------------------------------------------------
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.embedding.engine.**  { *; }
-keep class io.flutter.embedding.android.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry

# -----------------------------------------------------------------------------
# Flutter Plugins - WealthScope específicos
# -----------------------------------------------------------------------------
-keep class com.mr.flutter.plugin.filepicker.** { *; }
-keep class io.flutter.plugins.urllauncher.** { *; }
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class com.it_nomads.fluttersecurestorage.** { *; }
-keep class io.flutter.plugins.pathprovider.** { *; }
-keep class com.baseflow.permissionhandler.** { *; }
-keep class io.flutter.plugins.imagepicker.** { *; }
-keep class dev.fluttercommunity.plus.share.** { *; }
-keep class io.flutter.plugins.webviewflutter.** { *; }

# -----------------------------------------------------------------------------
# Supabase & HTTP Clients
# -----------------------------------------------------------------------------
-keep class io.supabase.** { *; }
-dontwarn io.supabase.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# -----------------------------------------------------------------------------
# Serialización (Gson/JSON)
# -----------------------------------------------------------------------------
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keep class com.google.gson.** { *; }

# -----------------------------------------------------------------------------
# Kotlin
# -----------------------------------------------------------------------------
-keep class kotlin.Metadata { *; }
-keepclassmembers class kotlin.Metadata {
    public <methods>;
}

# -----------------------------------------------------------------------------
# WebView & JavaScript Interface
# -----------------------------------------------------------------------------
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keepattributes JavascriptInterface

# -----------------------------------------------------------------------------
# Security & Crypto
# -----------------------------------------------------------------------------
-keep class javax.crypto.** { *; }
-keep class javax.security.** { *; }

# -----------------------------------------------------------------------------
# Optimizaciones
# -----------------------------------------------------------------------------
-optimizationpasses 5
-allowaccessmodification

# Mantener información de línea para stack traces
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# -----------------------------------------------------------------------------
# Remover Logs en Producción (mejora seguridad y performance)
# -----------------------------------------------------------------------------
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** w(...);
}

