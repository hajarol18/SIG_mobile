# Script de verification de Flutter
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Verification de Flutter" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1] Verification dans le PATH..." -ForegroundColor Yellow
$flutterCmd = Get-Command flutter -ErrorAction SilentlyContinue
if ($flutterCmd) {
    Write-Host "Flutter est installe et accessible !" -ForegroundColor Green
    Write-Host ""
    flutter --version | Select-Object -First 3
    Write-Host ""
    Write-Host "Emplacement: $($flutterCmd.Source)" -ForegroundColor Cyan
    Write-Host ""
    flutter doctor
    exit 0
} else {
    Write-Host "Flutter n'est pas dans le PATH" -ForegroundColor Red
}

Write-Host ""
Write-Host "[2] Recherche dans les emplacements courants..." -ForegroundColor Yellow

$locations = @(
    "C:\src\flutter",
    "C:\flutter",
    "$env:USERPROFILE\flutter"
)

$found = $false
foreach ($loc in $locations) {
    $flutterBat = Join-Path $loc "bin\flutter.bat"
    if (Test-Path $flutterBat) {
        Write-Host "Flutter trouve dans: $loc" -ForegroundColor Green
        Write-Host ""
        & $flutterBat --version | Select-Object -First 3
        Write-Host ""
        Write-Host "ATTENTION: Flutter est installe mais pas dans le PATH !" -ForegroundColor Yellow
        Write-Host "Ajoutez au PATH: $loc\bin" -ForegroundColor White
        $found = $true
        break
    }
}

if (-not $found) {
    Write-Host "Flutter n'a pas ete trouve" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
if ($found -or $flutterCmd) {
    Write-Host "Resultat: Flutter est installe" -ForegroundColor Green
} else {
    Write-Host "Resultat: Flutter N'EST PAS installe" -ForegroundColor Red
    Write-Host ""
    Write-Host "Pour installer Flutter:" -ForegroundColor Yellow
    Write-Host "  1. Visitez: https://flutter.dev/docs/get-started/install/windows" -ForegroundColor White
    Write-Host "  2. Telechargez le SDK Flutter" -ForegroundColor White
    Write-Host "  3. Extrayez dans C:\src\flutter" -ForegroundColor White
    Write-Host "  4. Ajoutez C:\src\flutter\bin au PATH" -ForegroundColor White
}
Write-Host "========================================" -ForegroundColor Cyan
