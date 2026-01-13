# Script pour lancer l'application Flutter
# Executez: powershell -ExecutionPolicy Bypass -File .\lancer-app.ps1

# Ajouter Flutter au PATH pour cette session
$flutterPath = "C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter\bin"
if (Test-Path $flutterPath) {
    $env:Path += ";$flutterPath"
    Write-Host "Flutter ajoute au PATH pour cette session" -ForegroundColor Green
} else {
    Write-Host "Erreur: Flutter non trouve dans $flutterPath" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Voulez-vous lancer sur quel appareil ?" -ForegroundColor Yellow
Write-Host "  1. Windows Desktop" -ForegroundColor White
Write-Host "  2. Chrome (navigateur web)" -ForegroundColor White
Write-Host "  3. Edge (navigateur web)" -ForegroundColor White
Write-Host "  4. Afficher les appareils disponibles" -ForegroundColor White
Write-Host ""
$choice = Read-Host "Votre choix (1-4)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "Lancement sur Windows Desktop..." -ForegroundColor Yellow
        flutter run -d windows
    }
    "2" {
        Write-Host ""
        Write-Host "Lancement sur Chrome..." -ForegroundColor Yellow
        flutter run -d chrome
    }
    "3" {
        Write-Host ""
        Write-Host "Lancement sur Edge..." -ForegroundColor Yellow
        flutter run -d edge
    }
    "4" {
        Write-Host ""
        Write-Host "Appareils disponibles:" -ForegroundColor Yellow
        flutter devices
    }
    default {
        Write-Host "Choix invalide" -ForegroundColor Red
        Write-Host "Affichage des appareils disponibles:" -ForegroundColor Yellow
        flutter devices
    }
}
