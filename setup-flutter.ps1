# Script pour configurer Flutter deja dezippe
# Executez: powershell -ExecutionPolicy Bypass -File .\setup-flutter.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Configuration de Flutter dezippe" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Chercher Flutter
Write-Host "[1] Recherche de Flutter..." -ForegroundColor Yellow

$flutterPath = $null

# Emplacements a verifier
$locations = @(
    "$env:USERPROFILE\Téléchargements\flutter_windows_3.38.6-stable\flutter",
    "$env:USERPROFILE\Downloads\flutter_windows_3.38.6-stable\flutter",
    "C:\Users\Hajar\Téléchargements\flutter_windows_3.38.6-stable\flutter",
    "C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter",
    "C:\src\flutter",
    "C:\flutter"
)

# Recherche dans Downloads
$searchFolders = @(
    "$env:USERPROFILE\Téléchargements",
    "$env:USERPROFILE\Downloads"
)

foreach ($folder in $searchFolders) {
    if (Test-Path $folder) {
        $items = Get-ChildItem -Path $folder -Directory -ErrorAction SilentlyContinue
        foreach ($item in $items) {
            if ($item.Name -like "*flutter*") {
                $flutterBat = Join-Path $item.FullName "bin\flutter.bat"
                if (Test-Path $flutterBat) {
                    $flutterPath = $item.FullName
                    Write-Host "Flutter trouve dans: $flutterPath" -ForegroundColor Green
                    break
                }
                # Chercher dans les sous-dossiers
                $subItems = Get-ChildItem -Path $item.FullName -Directory -ErrorAction SilentlyContinue
                foreach ($subItem in $subItems) {
                    if ($subItem.Name -eq "flutter") {
                        $flutterBat = Join-Path $subItem.FullName "bin\flutter.bat"
                        if (Test-Path $flutterBat) {
                            $flutterPath = $subItem.FullName
                            Write-Host "Flutter trouve dans: $flutterPath" -ForegroundColor Green
                            break
                        }
                    }
                }
                if ($flutterPath) { break }
            }
        }
        if ($flutterPath) { break }
    }
}

# Si pas trouve, verifier les emplacements standards
if (-not $flutterPath) {
    foreach ($loc in $locations) {
        $flutterBat = Join-Path $loc "bin\flutter.bat"
        if (Test-Path $flutterBat) {
            $flutterPath = $loc
            Write-Host "Flutter trouve dans: $flutterPath" -ForegroundColor Green
            break
        }
    }
}

if (-not $flutterPath) {
    Write-Host "Flutter n'a pas ete trouve automatiquement" -ForegroundColor Red
    Write-Host ""
    $manualPath = Read-Host "Entrez le chemin complet du dossier flutter"
    if ($manualPath -and (Test-Path (Join-Path $manualPath "bin\flutter.bat"))) {
        $flutterPath = $manualPath
        Write-Host "Flutter trouve dans: $flutterPath" -ForegroundColor Green
    } else {
        Write-Host "Chemin invalide" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""

# Verifier la version
Write-Host "[2] Verification de la version..." -ForegroundColor Yellow
$flutterBat = Join-Path $flutterPath "bin\flutter.bat"
& $flutterBat --version | Select-Object -First 3
Write-Host ""

# Demander si on veut deplacer vers C:\src\flutter
$targetPath = "C:\src\flutter"
if ($flutterPath -ne $targetPath) {
    Write-Host "[3] Emplacement actuel: $flutterPath" -ForegroundColor White
    Write-Host "    Emplacement recommande: $targetPath" -ForegroundColor White
    Write-Host ""
    $move = Read-Host "Voulez-vous deplacer Flutter vers C:\src\flutter ? (O/N)"
    if ($move -eq "O" -or $move -eq "o") {
        Write-Host ""
        Write-Host "[4] Deplacement de Flutter..." -ForegroundColor Yellow
        
        # Creer C:\src\
        $srcPath = "C:\src"
        if (-not (Test-Path $srcPath)) {
            try {
                New-Item -ItemType Directory -Path $srcPath -Force | Out-Null
                Write-Host "Dossier C:\src\ cree" -ForegroundColor Green
            } catch {
                Write-Host "Erreur lors de la creation de C:\src\" -ForegroundColor Red
                exit 1
            }
        }
        
        # Supprimer l'ancien dossier s'il existe
        if (Test-Path $targetPath) {
            Write-Host "Suppression de l'ancien dossier..." -ForegroundColor Yellow
            Remove-Item -Path $targetPath -Recurse -Force -ErrorAction SilentlyContinue
        }
        
        # Deplacer
        try {
            Write-Host "Deplacement en cours..." -ForegroundColor Yellow
            Move-Item -Path $flutterPath -Destination $targetPath -Force
            Write-Host "Flutter deplace vers: $targetPath" -ForegroundColor Green
            $flutterPath = $targetPath
            $flutterBat = Join-Path $flutterPath "bin\flutter.bat"
        } catch {
            Write-Host "Erreur lors du deplacement: $_" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "Flutter restera dans: $flutterPath" -ForegroundColor Green
    }
}

Write-Host ""

# Ajouter au PATH
Write-Host "[5] Ajout de Flutter au PATH..." -ForegroundColor Yellow
$flutterBinPath = Join-Path $flutterPath "bin"
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($isAdmin) {
    try {
        $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
        if ($currentPath -notlike "*$flutterBinPath*") {
            [Environment]::SetEnvironmentVariable("Path", "$currentPath;$flutterBinPath", "Machine")
            Write-Host "Flutter ajoute au PATH systeme" -ForegroundColor Green
            $env:Path += ";$flutterBinPath"
        } else {
            Write-Host "Flutter est deja dans le PATH systeme" -ForegroundColor Green
        }
    } catch {
        Write-Host "Erreur lors de l'ajout au PATH: $_" -ForegroundColor Red
    }
} else {
    Write-Host "ATTENTION: Privileges administrateur necessaires pour modifier le PATH systeme" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Pour ajouter manuellement:" -ForegroundColor Yellow
    Write-Host "  1. Windows + R, tapez: sysdm.cpl" -ForegroundColor White
    Write-Host "  2. Avance > Variables d'environnement" -ForegroundColor White
    Write-Host "  3. Path > Modifier > Nouveau" -ForegroundColor White
    Write-Host "  4. Ajoutez: $flutterBinPath" -ForegroundColor White
    Write-Host ""
    $env:Path += ";$flutterBinPath"
    Write-Host "Flutter ajoute au PATH de cette session seulement" -ForegroundColor Green
}

Write-Host ""

# Verification finale
Write-Host "[6] Verification finale (flutter doctor)..." -ForegroundColor Yellow
& $flutterBat doctor

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Configuration terminee !" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "IMPORTANT: Redemarrez votre terminal !" -ForegroundColor Yellow
Write-Host ""
Write-Host "Ensuite, testez:" -ForegroundColor Yellow
Write-Host "  flutter --version" -ForegroundColor White
Write-Host "  flutter doctor" -ForegroundColor White
Write-Host ""
