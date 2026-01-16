# Script interactif pour trouver et lancer le backend

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  RECHERCHE ET DEMARRAGE DU BACKEND" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Arrêter les processus sur le port 8081
Write-Host "1. Arrêt des processus sur le port 8081..." -ForegroundColor Yellow
$connections = Get-NetTCPConnection -LocalPort 8081 -ErrorAction SilentlyContinue
foreach ($conn in $connections) {
    if ($conn.State -eq "Listen") {
        Write-Host "   Arrêt du processus PID: $($conn.OwningProcess)" -ForegroundColor White
        Stop-Process -Id $conn.OwningProcess -Force -ErrorAction SilentlyContinue
    }
}
Start-Sleep -Seconds 2
Write-Host "   [OK] Port 8081 libéré" -ForegroundColor Green
Write-Host ""

# Chercher les projets Spring Boot
Write-Host "2. Recherche des projets Spring Boot..." -ForegroundColor Yellow

$searchPaths = @(
    "C:\Users\Hajar\Desktop",
    "C:\SIG_WEB"
)

$foundProjects = @()

foreach ($basePath in $searchPaths) {
    if (Test-Path $basePath) {
        Write-Host "   Recherche dans: $basePath" -ForegroundColor White
        
        # Chercher pom.xml avec spring-boot dans le parent
        $poms = Get-ChildItem -Path $basePath -Recurse -Filter "pom.xml" -ErrorAction SilentlyContinue -Depth 3
        foreach ($pom in $poms) {
            $content = Get-Content $pom.FullName -Raw -ErrorAction SilentlyContinue
            if ($content -and ($content -match "spring-boot-starter-parent" -or $content -match "spring-boot-starter-web")) {
                $projectDir = $pom.Directory.FullName
                if ($projectDir -notlike "*META-INF*" -and $projectDir -notlike "*target*" -and $projectDir -notlike "*build*") {
                    $foundProjects += @{
                        Path = $projectDir
                        Type = "Maven"
                        ConfigFile = $pom.FullName
                    }
                    Write-Host "   [TROUVÉ] Maven: $projectDir" -ForegroundColor Green
                }
            }
        }
        
        # Chercher build.gradle avec Spring Boot
        $gradles = Get-ChildItem -Path $basePath -Recurse -Filter "build.gradle*" -ErrorAction SilentlyContinue -Depth 3
        foreach ($gradle in $gradles) {
            $content = Get-Content $gradle.FullName -Raw -ErrorAction SilentlyContinue
            if ($content -and ($content -match "spring-boot" -or $content -match "org.springframework.boot")) {
                $projectDir = $gradle.Directory.FullName
                if ($projectDir -notlike "*META-INF*" -and $projectDir -notlike "*build*") {
                    $foundProjects += @{
                        Path = $projectDir
                        Type = "Gradle"
                        ConfigFile = $gradle.FullName
                    }
                    Write-Host "   [TROUVÉ] Gradle: $projectDir" -ForegroundColor Green
                }
            }
        }
    }
}

Write-Host ""

if ($foundProjects.Count -eq 0) {
    Write-Host "   [INFO] Aucun projet Spring Boot trouvé automatiquement" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Veuillez entrer le chemin du dossier backend:" -ForegroundColor Yellow
    Write-Host "   Exemple: C:\Users\Hajar\Desktop\sadaka\backend" -ForegroundColor White
    $manualPath = Read-Host "Chemin du backend"
    
    if (Test-Path $manualPath) {
        $foundProjects += @{
            Path = $manualPath
            Type = "Unknown"
            ConfigFile = ""
        }
    } else {
        Write-Host "   [ERREUR] Le chemin n'existe pas!" -ForegroundColor Red
        exit 1
    }
} elseif ($foundProjects.Count -eq 1) {
    $selectedProject = $foundProjects[0]
    Write-Host "   [OK] Projet trouvé: $($selectedProject.Path)" -ForegroundColor Green
} else {
    Write-Host "   Plusieurs projets trouvés:" -ForegroundColor Yellow
    for ($i = 0; $i -lt $foundProjects.Count; $i++) {
        Write-Host "   $($i+1). $($foundProjects[$i].Path) ($($foundProjects[$i].Type))" -ForegroundColor White
    }
    $choice = Read-Host "   Choisissez un numéro (1-$($foundProjects.Count))"
    $selectedProject = $foundProjects[[int]$choice - 1]
}

Write-Host ""
Write-Host "3. Démarrage du backend..." -ForegroundColor Yellow
Write-Host "   Dossier: $($selectedProject.Path)" -ForegroundColor White
Write-Host "   Type: $($selectedProject.Type)" -ForegroundColor White

Set-Location $selectedProject.Path

# Démarrer selon le type
if ($selectedProject.Type -eq "Maven") {
    if (Test-Path ".\mvnw.cmd") {
        Write-Host ""
        Write-Host "   Utilisation du wrapper Maven..." -ForegroundColor Cyan
        Write-Host "   Commande: .\mvnw.cmd spring-boot:run" -ForegroundColor White
        Write-Host ""
        Write-Host "   ATTENDEZ 30-60 secondes pour le démarrage..." -ForegroundColor Yellow
        Write-Host ""
        Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$($selectedProject.Path)'; .\mvnw.cmd spring-boot:run"
    } else {
        Write-Host "   [ERREUR] mvnw.cmd non trouvé. Vérifiez que Maven est installé." -ForegroundColor Red
        exit 1
    }
} elseif ($selectedProject.Type -eq "Gradle") {
    if (Test-Path ".\gradlew.bat") {
        Write-Host ""
        Write-Host "   Utilisation du wrapper Gradle..." -ForegroundColor Cyan
        Write-Host "   Commande: .\gradlew.bat bootRun" -ForegroundColor White
        Write-Host ""
        Write-Host "   ATTENDEZ 30-60 secondes pour le démarrage..." -ForegroundColor Yellow
        Write-Host ""
        Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$($selectedProject.Path)'; .\gradlew.bat bootRun"
    } else {
        Write-Host "   [ERREUR] gradlew.bat non trouvé. Vérifiez que Gradle est installé." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "   [INFO] Type inconnu. Cherchez un script de démarrage ou lancez manuellement." -ForegroundColor Yellow
    Write-Host "   Cherchez: Application.java ou un fichier .jar" -ForegroundColor White
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  BACKEND EN COURS DE DEMARRAGE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Le backend devrait être disponible sur: http://localhost:8081" -ForegroundColor Green
Write-Host ""
Write-Host "Vérifiez les logs dans la nouvelle fenêtre PowerShell." -ForegroundColor Yellow
Write-Host ""
Write-Host "Une fois démarré (messages 'Started Application')," -ForegroundColor Cyan
Write-Host "rechargez votre frontend React (Ctrl+R ou F5)." -ForegroundColor Cyan
Write-Host ""
