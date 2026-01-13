# Script pour ajouter Flutter au PATH de cette session PowerShell
# Executez ce script dans votre terminal avant d'utiliser Flutter
# OU ajoutez cette ligne au debut de votre profil PowerShell

$flutterPath = "C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter\bin"
if (Test-Path $flutterPath) {
    if ($env:Path -notlike "*$flutterPath*") {
        $env:Path += ";$flutterPath"
        Write-Host "Flutter ajoute au PATH pour cette session" -ForegroundColor Green
    } else {
        Write-Host "Flutter est deja dans le PATH de cette session" -ForegroundColor Green
    }
} else {
    Write-Host "Erreur: Flutter non trouve dans $flutterPath" -ForegroundColor Red
}
