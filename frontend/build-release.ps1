#!/usr/bin/env pwsh
# =============================================================================
# Script para construir APK de PRODUCCIÓN - WealthScope
# =============================================================================
# Uso: .\build-release.ps1

Write-Host "🚀 Building WealthScope for PRODUCTION..." -ForegroundColor Green
Write-Host ""

# Leer variables del archivo .env.production
Write-Host "📋 Loading production environment variables..." -ForegroundColor Yellow
$envFile = ".env.production"

if (-Not (Test-Path $envFile)) {
    Write-Host "❌ Error: .env.production file not found!" -ForegroundColor Red
    exit 1
}

# Parsear el archivo .env.production
$envVars = @()
Get-Content $envFile | ForEach-Object {
    $line = $_.Trim()
    # Ignorar comentarios y líneas vacías
    if ($line -and -not $line.StartsWith("#")) {
        $parts = $line -split "=", 2
        if ($parts.Count -eq 2) {
            $key = $parts[0].Trim()
            $value = $parts[1].Trim()
            $envVars += "--dart-define=$key=$value"
        }
    }
}

Write-Host "✅ Loaded $($envVars.Count) environment variables" -ForegroundColor Green
Write-Host ""

# Limpiar builds anteriores
Write-Host "🧹 Cleaning previous builds..." -ForegroundColor Yellow
flutter clean
Write-Host ""

# Obtener dependencias
Write-Host "📦 Getting dependencies..." -ForegroundColor Yellow
flutter pub get
Write-Host ""

# Generar código (Riverpod, Freezed, etc.)
Write-Host "⚙️  Generating code..." -ForegroundColor Yellow
dart run build_runner build --delete-conflicting-outputs
Write-Host ""

# Construir el APK de release
Write-Host "🔨 Building release APK..." -ForegroundColor Cyan
Write-Host "This may take several minutes..." -ForegroundColor Gray
Write-Host ""

$buildArgs = @("build", "apk", "--release") + $envVars

& flutter $buildArgs

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ BUILD SUCCESSFUL!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📱 APK Location:" -ForegroundColor Cyan
    Write-Host "   build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor White
    Write-Host ""
    Write-Host "📊 APK Info:" -ForegroundColor Cyan
    
    $apkPath = "build\app\outputs\flutter-apk\app-release.apk"
    if (Test-Path $apkPath) {
        $apkSize = (Get-Item $apkPath).Length / 1MB
        Write-Host "   Size: $([math]::Round($apkSize, 2)) MB" -ForegroundColor White
    }
    
    Write-Host ""
    Write-Host "📤 Next Steps:" -ForegroundColor Yellow
    Write-Host "   1. Test the APK on a physical device" -ForegroundColor White
    Write-Host "   2. Verify all features work correctly" -ForegroundColor White
    Write-Host "   3. Check API connections to production" -ForegroundColor White
    Write-Host "   4. Ready to distribute!" -ForegroundColor White
    Write-Host ""
    
    # Preguntar si quiere abrir la carpeta
    $response = Read-Host "Open APK folder? (Y/N)"
    if ($response -eq "Y" -or $response -eq "y") {
        Invoke-Item "build\app\outputs\flutter-apk\"
    }
} else {
    Write-Host ""
    Write-Host "❌ BUILD FAILED!" -ForegroundColor Red
    Write-Host "Check the error messages above." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}
