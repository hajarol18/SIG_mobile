# Script pour lancer l'application sur Android
# Usage: .\lancer-sur-android.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Lancement sur Android" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Ajouter Flutter au PATH
$env:Path += ";C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter\bin"

# Vérifier que Flutter est disponible
try {
    $flutterVersion = flutter --version 2>&1 | Select-Object -First 1
    Write-Host "[OK] Flutter trouve: $flutterVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERREUR] Flutter non trouve dans le PATH" -ForegroundColor Red
    Write-Host "Assurez-vous que Flutter est installe et dans le PATH" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "[1] Verification des appareils disponibles..." -ForegroundColor Yellow
flutter devices

Write-Host ""
Write-Host "[2] Lancement de l'application sur Android..." -ForegroundColor Yellow
Write-Host ""

# Lancer sur Android
flutter run -d android
