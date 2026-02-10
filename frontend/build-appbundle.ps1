#!/usr/bin/env pwsh
# =============================================================================
# Script para construir App Bundle de PRODUCCIÓN - WealthScope
# =============================================================================
# Uso: .\build-appbundle.ps1
# El App Bundle (.aab) es el formato requerido por Google Play Store

Write-Host "🚀 Building WealthScope App Bundle for PRODUCTION..." -ForegroundColor Green
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

# Generar código
Write-Host "⚙️  Generating code..." -ForegroundColor Yellow
dart run build_runner build --delete-conflicting-outputs
Write-Host ""

# Construir el App Bundle de release
Write-Host "🔨 Building release App Bundle..." -ForegroundColor Cyan
Write-Host "This may take several minutes..." -ForegroundColor Gray
Write-Host ""

$buildArgs = @("build", "appbundle", "--release") + $envVars

& flutter $buildArgs

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ BUILD SUCCESSFUL!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📱 App Bundle Location:" -ForegroundColor Cyan
    Write-Host "   build\app\outputs\bundle\release\app-release.aab" -ForegroundColor White
    Write-Host ""
    Write-Host "📊 Bundle Info:" -ForegroundColor Cyan
    
    $aabPath = "build\app\outputs\bundle\release\app-release.aab"
    if (Test-Path $ $aabPath) {
        $aabSize = (Get-Item $aabPath).Length / 1MB
        Write-Host "   Size: $([math]::Round($aabSize, 2)) MB" -ForegroundColor White
    }
    
    Write-Host ""
    Write-Host "📤 Next Steps for Google Play Store:" -ForegroundColor Yellow
    Write-Host "   1. Sign in to Google Play Console" -ForegroundColor White
    Write-Host "   2. Select your app" -ForegroundColor White
    Write-Host "   3. Go to Production → Create new release" -ForegroundColor White
    Write-Host "   4. Upload the .aab file" -ForegroundColor White
    Write-Host "   5. Complete release notes and submit" -ForegroundColor White
    Write-Host ""
    
    # Preguntar si quiere abrir la carpeta
    $response = Read-Host "Open bundle folder? (Y/N)"
    if ($response -eq "Y" -or $response -eq "y") {
        Invoke-Item "build\app\outputs\bundle\release\"
    }
} else {
    Write-Host ""
    Write-Host "❌ BUILD FAILED!" -ForegroundColor Red
    Write-Host "Check the error messages above." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}
