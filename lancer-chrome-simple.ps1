# Script simple pour lancer sur Chrome
# Double-cliquez sur ce fichier OU executez: powershell -ExecutionPolicy Bypass -File .\lancer-chrome-simple.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  LANCEMENT SUR CHROME" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Ajouter Flutter au PATH
$env:Path += ";C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter\bin"

Write-Host "Verification de Flutter..." -ForegroundColor Yellow
flutter --version | Select-Object -First 1
Write-Host ""

Write-Host "Lancement de l'application sur Chrome..." -ForegroundColor Green
Write-Host "L'application va compiler (2-3 minutes la premiere fois)..." -ForegroundColor Yellow
Write-Host "Chrome s'ouvrira automatiquement quand c'est pret !" -ForegroundColor Cyan
Write-Host ""
Write-Host "ATTENDEZ PATIEMMENT..." -ForegroundColor Yellow
Write-Host ""

# Lancer Flutter
flutter run -d chrome
