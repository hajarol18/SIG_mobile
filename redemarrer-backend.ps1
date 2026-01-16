# Script pour redémarrer le backend Spring Boot

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  REDEMARRAGE DU BACKEND" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Arrêter les processus Java qui utilisent le port 8081
Write-Host "1. Arrêt des processus backend existants..." -ForegroundColor Yellow
$port8081 = netstat -ano | Select-String -Pattern ":8081.*LISTENING" | ForEach-Object { ($_ -split '\s+')[-1] } | Select-Object -Unique
if ($port8081) {
    foreach ($pid in $port8081) {
        Write-Host "   Arrêt du processus PID: $pid" -ForegroundColor White
        Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
    }
    Start-Sleep -Seconds 2
    Write-Host "   [OK] Processus arrêtés" -ForegroundColor Green
} else {
    Write-Host "   [INFO] Aucun processus sur le port 8081" -ForegroundColor Cyan
}

Write-Host ""

# Rechercher le dossier du backend
Write-Host "2. Recherche du dossier backend..." -ForegroundColor Yellow

$possibleBackendPaths = @(
    "C:\Users\Hajar\Desktop\sadaka",
    "C:\Users\Hajar\Desktop\sadaka\backend",
    "C:\Users\Hajar\Desktop\sadaka\sadaka-backend",
    "C:\SIG_WEB",
    "C:\Users\Hajar\Desktop\3-sig"
)

$backendPath = $null
$pomPath = $null
$gradlePath = $null

foreach ($path in $possibleBackendPaths) {
    if (Test-Path $path) {
        Write-Host "   Vérification de: $path" -ForegroundColor White
        
        # Chercher pom.xml (Maven)
        $pom = Get-ChildItem -Path $path -Recurse -Filter "pom.xml" -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($pom) {
            $backendPath = $pom.Directory.FullName
            $pomPath = $pom.FullName
            Write-Host "   [OK] Projet Maven trouvé: $backendPath" -ForegroundColor Green
            break
        }
        
        # Chercher build.gradle (Gradle)
        $gradle = Get-ChildItem -Path $path -Recurse -Filter "build.gradle*" -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($gradle) {
            $backendPath = $gradle.Directory.FullName
            $gradlePath = $gradle.FullName
            Write-Host "   [OK] Projet Gradle trouvé: $backendPath" -ForegroundColor Green
            break
        }
    }
}

if (-not $backendPath) {
    Write-Host "   [ERREUR] Dossier backend non trouvé automatiquement" -ForegroundColor Red
    Write-Host ""
    Write-Host "Veuillez spécifier le chemin du backend:" -ForegroundColor Yellow
    Write-Host "   Exemple: C:\Users\Hajar\Desktop\sadaka\backend" -ForegroundColor White
    $backendPath = Read-Host "Chemin du backend"
}

if (-not (Test-Path $backendPath)) {
    Write-Host "   [ERREUR] Le chemin spécifié n'existe pas: $backendPath" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "3. Démarrer le backend..." -ForegroundColor Yellow
Write-Host "   Dossier: $backendPath" -ForegroundColor White

# Changer de répertoire
Set-Location $backendPath

# Vérifier le type de projet et démarrer
if ($pomPath) {
    Write-Host "   Type: Maven" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   Exécution: mvn spring-boot:run" -ForegroundColor White
    Write-Host ""
    Write-Host "   ATTENDEZ 30-60 secondes pour le démarrage..." -ForegroundColor Yellow
    Write-Host ""
    
    # Vérifier si Maven est installé
    $mvn = Get-Command mvn -ErrorAction SilentlyContinue
    if (-not $mvn) {
        Write-Host "   [ERREUR] Maven n'est pas installé ou n'est pas dans le PATH" -ForegroundColor Red
        Write-Host "   Installez Maven ou utilisez le wrapper: .\mvnw.cmd spring-boot:run" -ForegroundColor Yellow
        if (Test-Path ".\mvnw.cmd") {
            Write-Host "   Utilisation du wrapper Maven..." -ForegroundColor Cyan
            Start-Process -FilePath ".\mvnw.cmd" -ArgumentList "spring-boot:run" -NoNewWindow
        } else {
            exit 1
        }
    } else {
        Start-Process -FilePath "mvn" -ArgumentList "spring-boot:run" -NoNewWindow
    }
} elseif ($gradlePath) {
    Write-Host "   Type: Gradle" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   Exécution: gradle bootRun" -ForegroundColor White
    Write-Host ""
    Write-Host "   ATTENDEZ 30-60 secondes pour le démarrage..." -ForegroundColor Yellow
    Write-Host ""
    
    # Vérifier si Gradle est installé
    $gradle = Get-Command gradle -ErrorAction SilentlyContinue
    if (-not $gradle) {
        if (Test-Path ".\gradlew.bat") {
            Write-Host "   Utilisation du wrapper Gradle..." -ForegroundColor Cyan
            Start-Process -FilePath ".\gradlew.bat" -ArgumentList "bootRun" -NoNewWindow
        } else {
            Write-Host "   [ERREUR] Gradle n'est pas installé" -ForegroundColor Red
            exit 1
        }
    } else {
        Start-Process -FilePath "gradle" -ArgumentList "bootRun" -NoNewWindow
    }
} else {
    Write-Host "   [ERREUR] Type de projet non reconnu (ni Maven ni Gradle)" -ForegroundColor Red
    Write-Host "   Cherchez manuellement le fichier Application.java et lancez-le" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  BACKEND EN COURS DE DEMARRAGE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Le backend devrait être disponible sur: http://localhost:8081" -ForegroundColor Green
Write-Host ""
Write-Host "Vérifiez les logs dans la fenêtre qui s'est ouverte." -ForegroundColor Yellow
Write-Host ""
Write-Host "Une fois démarré, rechargez votre frontend React." -ForegroundColor Cyan
Write-Host ""
