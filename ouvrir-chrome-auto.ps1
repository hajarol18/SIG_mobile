# Script pour ouvrir Chrome automatiquement quand l'application est prête
# Executez ce script dans un terminal séparé pendant que Flutter compile

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ATTENTE DE L'APPLICATION" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Recherche du port Flutter..." -ForegroundColor Yellow
Write-Host ""

$maxAttempts = 60  # 5 minutes max
$attempt = 0
$portFound = $false

while ($attempt -lt $maxAttempts -and -not $portFound) {
    $attempt++
    $ports = netstat -ano | Select-String -Pattern "LISTENING" | Select-String -Pattern "127.0.0.1" | Where-Object {$_ -match ":([89][0-9]{3})"} | ForEach-Object { 
        if ($_ -match ":(\d+)") { 
            $matches[1] 
        } 
    }
    
    if ($ports) {
        $port = $ports | Select-Object -First 1
        Write-Host "[OK] Port detecte: $port" -ForegroundColor Green
        Write-Host ""
        Write-Host "Ouverture de Chrome sur http://localhost:$port" -ForegroundColor Yellow
        Start-Process "chrome.exe" "http://localhost:$port"
        $portFound = $true
        Write-Host ""
        Write-Host "Chrome devrait s'ouvrir maintenant !" -ForegroundColor Green
        break
    } else {
        Write-Host "Tentative $attempt/$maxAttempts - Attente..." -ForegroundColor Gray
        Start-Sleep -Seconds 5
    }
}

if (-not $portFound) {
    Write-Host ""
    Write-Host "[!] Port non detecte apres 5 minutes" -ForegroundColor Red
    Write-Host ""
    Write-Host "Essayez d'ouvrir manuellement Chrome sur :" -ForegroundColor Yellow
    Write-Host "  http://localhost:8080" -ForegroundColor Cyan
    Write-Host "  http://localhost:8090" -ForegroundColor Cyan
    Write-Host "  http://localhost:60613" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Ou verifiez le terminal Flutter pour les erreurs." -ForegroundColor Yellow
}
