# Script pour lancer l'application sur mobile (Android)
# Usage: .\lancer-mobile.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Lancement sur Mobile (Android)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Ajouter Flutter au PATH
$env:Path += ";C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter\bin"

# 1. Vérifier Flutter
Write-Host "[1] Vérification de Flutter..." -ForegroundColor Yellow
$flutterVersion = flutter --version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERREUR: Flutter n'est pas trouvé dans le PATH" -ForegroundColor Red
    Write-Host "Ajoutez Flutter au PATH ou utilisez ajouter-flutter-path-session.ps1" -ForegroundColor Yellow
    exit 1
}
Write-Host "Flutter trouvé ✓" -ForegroundColor Green
Write-Host ""

# 2. Lister les devices disponibles
Write-Host "[2] Recherche des devices disponibles..." -ForegroundColor Yellow
$devices = flutter devices 2>&1
Write-Host $devices
Write-Host ""

# 3. Vérifier s'il y a un téléphone connecté
$phoneConnected = $devices -match "android"
$emulatorAvailable = flutter emulators 2>&1 | Select-String "available"

if (-not $phoneConnected -and -not $emulatorAvailable) {
    Write-Host "AUCUN DEVICE ANDROID TROUVE" -ForegroundColor Red
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Yellow
    Write-Host "1. Connectez un téléphone Android via USB (avec débogage USB activé)" -ForegroundColor White
    Write-Host "2. Lancez un émulateur Android:" -ForegroundColor White
    Write-Host "   flutter emulators --launch <nom_emulateur>" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Pour lister les émulateurs:" -ForegroundColor Yellow
    Write-Host "   flutter emulators" -ForegroundColor Cyan
    Write-Host ""
    
    # Proposer de lancer l'émulateur disponible
    $emulators = flutter emulators 2>&1
    if ($emulators -match "available emulator") {
        Write-Host "Émulateur disponible détecté !" -ForegroundColor Green
        Write-Host "Voulez-vous lancer l'émulateur ? (O/N): " -ForegroundColor Yellow -NoNewline
        $response = Read-Host
        if ($response -eq "O" -or $response -eq "o") {
            Write-Host "Lancement de l'émulateur..." -ForegroundColor Yellow
            flutter emulators --launch Medium_Phone_API_36.1
            Write-Host "Attendez que l'émulateur démarre (30-60 secondes)..." -ForegroundColor Yellow
            Write-Host "Puis relancez ce script." -ForegroundColor Yellow
            exit 0
        }
    }
    exit 1
}

# 4. Lancer l'application
Write-Host "[3] Lancement de l'application..." -ForegroundColor Yellow
Write-Host ""

# Si un téléphone est connecté, lancer directement
if ($phoneConnected) {
    Write-Host "Téléphone Android détecté !" -ForegroundColor Green
    Write-Host "Lancement sur le téléphone..." -ForegroundColor Yellow
    flutter run
} else {
    # Sinon, proposer de lancer sur un émulateur
    Write-Host "Aucun téléphone connecté." -ForegroundColor Yellow
    Write-Host "Voulez-vous lancer sur un émulateur ? (O/N): " -ForegroundColor Yellow -NoNewline
    $response = Read-Host
    if ($response -eq "O" -or $response -eq "o") {
        Write-Host "Lancement de l'émulateur..." -ForegroundColor Yellow
        flutter emulators --launch Medium_Phone_API_36.1
        Start-Sleep -Seconds 5
        Write-Host "Lancement de l'application sur l'émulateur..." -ForegroundColor Yellow
        flutter run
    } else {
        Write-Host "Annulé." -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Application lancée !" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
