# Script pour recharger l'application Flutter
# Executez: powershell -ExecutionPolicy Bypass -File .\recharger-app.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  RECHARGEMENT DE L'APPLICATION" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Ajouter Flutter au PATH
$env:Path += ";C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter\bin"

Write-Host "Options de rechargement :" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Si Flutter est deja en cours d'execution :" -ForegroundColor Cyan
Write-Host "   - Allez dans le terminal Flutter" -ForegroundColor White
Write-Host "   - Appuyez sur 'R' (majuscule) pour Hot Restart" -ForegroundColor Green
Write-Host "   - OU appuyez sur 'r' (minuscule) pour Hot Reload" -ForegroundColor Green
Write-Host ""
Write-Host "2. Dans Chrome :" -ForegroundColor Cyan
Write-Host "   - Appuyez sur F5 pour recharger" -ForegroundColor Green
Write-Host "   - OU Ctrl+Shift+R pour rechargement force" -ForegroundColor Green
Write-Host ""
Write-Host "3. Relancer completement l'application :" -ForegroundColor Cyan
Write-Host "   - Fermez Chrome et le terminal Flutter" -ForegroundColor Yellow
Write-Host "   - Executez: .\lancer-chrome-simple.ps1" -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  RELANCEMENT COMPLET" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Voulez-vous relancer completement l'application ? (O/N)" -ForegroundColor Yellow
$response = Read-Host

if ($response -eq "O" -or $response -eq "o") {
    Write-Host ""
    Write-Host "Fermeture des processus existants..." -ForegroundColor Yellow
    Get-Process | Where-Object {$_.ProcessName -like "*dart*" -or $_.ProcessName -like "*chrome*" -and $_.MainWindowTitle -like "*localhost*"} | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    
    Write-Host ""
    Write-Host "Relancement de l'application..." -ForegroundColor Green
    Write-Host ""
    & ".\lancer-chrome-simple.ps1"
} else {
    Write-Host ""
    Write-Host "Pour recharger manuellement :" -ForegroundColor Cyan
    Write-Host "  - Dans le terminal Flutter : appuyez sur 'R'" -ForegroundColor White
    Write-Host "  - Dans Chrome : appuyez sur F5" -ForegroundColor White
    Write-Host ""
}
