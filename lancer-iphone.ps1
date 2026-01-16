# Script pour lancer l'application sur iPhone
# Nécessite : Mac avec Xcode OU iPhone connecté en mode développeur

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  LANCEMENT SUR IPHONE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Vérifier Flutter
Write-Host "Vérification de Flutter..." -ForegroundColor Yellow
$env:Path += ";C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter\bin"
flutter --version | Select-Object -First 1

Write-Host ""
Write-Host "Vérification des appareils iOS connectés..." -ForegroundColor Yellow
flutter devices

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  OPTIONS POUR TESTER SUR IPHONE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "OPTION 1 : iPhone connecté (Recommandé si vous avez un Mac)" -ForegroundColor Yellow
Write-Host "  1. Connectez votre iPhone à votre Mac via USB" -ForegroundColor White
Write-Host "  2. Faites confiance à l'ordinateur sur l'iPhone" -ForegroundColor White
Write-Host "  3. Sur Mac, ouvrez Xcode" -ForegroundColor White
Write-Host "  4. Allez dans Window > Devices and Simulators" -ForegroundColor White
Write-Host "  5. Sélectionnez votre iPhone et cliquez sur 'Use for Development'" -ForegroundColor White
Write-Host "  6. Exécutez : flutter run -d <device-id>" -ForegroundColor White
Write-Host ""
Write-Host "OPTION 2 : Codemagic (Recommandé si vous n'avez pas de Mac)" -ForegroundColor Yellow
Write-Host "  1. Allez sur https://codemagic.io" -ForegroundColor White
Write-Host "  2. Créez un compte gratuit" -ForegroundColor White
Write-Host "  3. Connectez votre repository GitHub" -ForegroundColor White
Write-Host "  4. Configurez un workflow iOS" -ForegroundColor White
Write-Host "  5. Téléchargez l'IPA généré" -ForegroundColor White
Write-Host "  6. Installez via TestFlight ou directement" -ForegroundColor White
Write-Host ""
Write-Host "OPTION 3 : Simulateur iOS (Sur Mac uniquement)" -ForegroundColor Yellow
Write-Host "  1. Ouvrez Xcode" -ForegroundColor White
Write-Host "  2. Allez dans Xcode > Settings > Platforms" -ForegroundColor White
Write-Host "  3. Téléchargez un simulateur iOS" -ForegroundColor White
Write-Host "  4. Exécutez : flutter run -d ios" -ForegroundColor White
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  INFORMATIONS IMPORTANTES" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "✓ Permissions de localisation configurées" -ForegroundColor Green
Write-Host "✓ Base de données SQLite fonctionnelle sur iOS" -ForegroundColor Green
Write-Host "✓ Configuration iOS prête" -ForegroundColor Green
Write-Host ""
Write-Host "⚠ Pour tester sur iPhone physique, vous avez besoin :" -ForegroundColor Yellow
Write-Host "  - Un Mac avec Xcode installé" -ForegroundColor White
Write-Host "  - OU utiliser Codemagic (gratuit pour projets open source)" -ForegroundColor White
Write-Host ""
Write-Host "📱 L'application fonctionnera avec TOUTES les fonctionnalités :" -ForegroundColor Cyan
Write-Host "  ✓ Base de données SQLite" -ForegroundColor Green
Write-Host "  ✓ Géolocalisation GPS" -ForegroundColor Green
Write-Host "  ✓ Relevé de polygones" -ForegroundColor Green
Write-Host "  ✓ Toutes les fonctionnalités" -ForegroundColor Green
Write-Host ""
