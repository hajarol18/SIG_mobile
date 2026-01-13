# Script de configuration du projet SIG Mobile apres installation de Flutter
# Executez: powershell -ExecutionPolicy Bypass -File .\configurer-projet.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Configuration du Projet SIG Mobile" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verifier que Flutter est installe
Write-Host "[1] Verification de Flutter..." -ForegroundColor Yellow
$flutterCmd = Get-Command flutter -ErrorAction SilentlyContinue
if (-not $flutterCmd) {
    Write-Host "✗ Flutter n'est pas installe ou pas dans le PATH" -ForegroundColor Red
    Write-Host ""
    Write-Host "Veuillez d'abord installer Flutter:" -ForegroundColor Yellow
    Write-Host "  1. Telechargez Flutter depuis: https://flutter.dev/docs/get-started/install/windows" -ForegroundColor White
    Write-Host "  2. Executez le script: installer-flutter.ps1" -ForegroundColor White
    Write-Host "  3. Redemarrez votre terminal" -ForegroundColor White
    Write-Host ""
    exit 1
}

Write-Host "✓ Flutter est installe" -ForegroundColor Green
flutter --version | Select-Object -First 1
Write-Host ""

# Verifier Flutter Doctor
Write-Host "[2] Verification de la configuration Flutter (flutter doctor)..." -ForegroundColor Yellow
flutter doctor
Write-Host ""

# Installer les dependances
Write-Host "[3] Installation des dependances du projet (flutter pub get)..." -ForegroundColor Yellow
try {
    flutter pub get
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Dependances installees avec succes" -ForegroundColor Green
    } else {
        Write-Host "✗ Erreur lors de l'installation des dependances" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "✗ Erreur: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Verifier la configuration du projet
Write-Host "[4] Verification de la configuration du projet..." -ForegroundColor Yellow
if (Test-Path "pubspec.yaml") {
    Write-Host "✓ pubspec.yaml trouve" -ForegroundColor Green
} else {
    Write-Host "✗ pubspec.yaml non trouve" -ForegroundColor Red
    exit 1
}

if (Test-Path "lib\main.dart") {
    Write-Host "✓ Structure du projet correcte" -ForegroundColor Green
} else {
    Write-Host "✗ Structure du projet incorrecte" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Verifier les appareils disponibles
Write-Host "[5] Verification des appareils disponibles..." -ForegroundColor Yellow
flutter devices
Write-Host ""

# Resume
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Configuration terminee !" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Le projet est pret a etre utilise !" -ForegroundColor Green
Write-Host ""
Write-Host "Pour lancer l'application:" -ForegroundColor Yellow
Write-Host "  flutter run" -ForegroundColor White
Write-Host ""
Write-Host "Pour tester sur un appareil specifique:" -ForegroundColor Yellow
Write-Host "  flutter devices  (pour voir les appareils disponibles)" -ForegroundColor White
Write-Host "  flutter run -d <device-id>" -ForegroundColor White
Write-Host ""
Write-Host "Pour construire l'application:" -ForegroundColor Yellow
Write-Host "  flutter build apk  (pour Android)" -ForegroundColor White
Write-Host "  flutter build ios  (pour iOS - Mac uniquement)" -ForegroundColor White
Write-Host ""
