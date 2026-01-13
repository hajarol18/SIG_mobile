# Script pour configurer Flutter deja dezippe
# Executez: powershell -ExecutionPolicy Bypass -File .\configurer-flutter-existant.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Configuration de Flutter dezippe" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Chercher Flutter dans plusieurs emplacements possibles
Write-Host "[1] Recherche de Flutter..." -ForegroundColor Yellow

$possibleLocations = @(
    "C:\Users\Hajar\Téléchargements\flutter_windows_3.38.6-stable\flutter",
    "C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter",
    "$env:USERPROFILE\Téléchargements\flutter_windows_3.38.6-stable\flutter",
    "$env:USERPROFILE\Downloads\flutter_windows_3.38.6-stable\flutter",
    "C:\src\flutter",
    "C:\flutter"
)

# Recherche recursive dans Downloads/Téléchargements
$searchFolders = @(
    "$env:USERPROFILE\Téléchargements",
    "$env:USERPROFILE\Downloads",
    "C:\Users\Hajar\Téléchargements",
    "C:\Users\Hajar\Downloads"
)

$flutterPath = $null

foreach ($folder in $searchFolders) {
    if (Test-Path $folder) {
        $flutterDirs = Get-ChildItem -Path $folder -Filter "*flutter*" -Directory -Recurse -Depth 2 -ErrorAction SilentlyContinue
        foreach ($dir in $flutterDirs) {
            $flutterBat = Join-Path $dir.FullName "bin\flutter.bat"
            if (Test-Path $flutterBat) {
                $flutterPath = $dir.FullName
                Write-Host "✓ Flutter trouve dans: $flutterPath" -ForegroundColor Green
                break
            }
        }
        if ($flutterPath) { break }
    }
}

# Si pas trouve, verifier les emplacements standards
if (-not $flutterPath) {
    foreach ($loc in $possibleLocations) {
        $flutterBat = Join-Path $loc "bin\flutter.bat"
        if (Test-Path $flutterBat) {
            $flutterPath = $loc
            Write-Host "✓ Flutter trouve dans: $flutterPath" -ForegroundColor Green
            break
        }
    }
}

if (-not $flutterPath) {
    Write-Host "✗ Flutter n'a pas ete trouve automatiquement" -ForegroundColor Red
    Write-Host ""
    $manualPath = Read-Host "Entrez le chemin complet du dossier 'flutter' (ex: C:\Users\Hajar\Téléchargements\flutter_windows_3.38.6-stable\flutter)"
    if ($manualPath -and (Test-Path (Join-Path $manualPath "bin\flutter.bat"))) {
        $flutterPath = $manualPath
        Write-Host "✓ Flutter trouve dans: $flutterPath" -ForegroundColor Green
    } else {
        Write-Host "✗ Chemin invalide ou Flutter non trouve" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""

# Verifier la version de Flutter
Write-Host "[2] Verification de la version..." -ForegroundColor Yellow
$flutterBat = Join-Path $flutterPath "bin\flutter.bat"
& $flutterBat --version | Select-Object -First 3
Write-Host ""

# Decider si on deplace ou on laisse en place
Write-Host "[3] Configuration de l'emplacement..." -ForegroundColor Yellow
$targetPath = "C:\src\flutter"
$shouldMove = $false

if ($flutterPath -ne $targetPath) {
    Write-Host "Flutter est actuellement dans: $flutterPath" -ForegroundColor White
    Write-Host "Emplacement recommande: $targetPath" -ForegroundColor White
    Write-Host ""
    $move = Read-Host "Voulez-vous deplacer Flutter vers C:\src\flutter ? (O/N - Recommande: O)"
    if ($move -eq "O" -or $move -eq "o") {
        $shouldMove = $true
    } else {
        Write-Host "✓ Flutter restera dans: $flutterPath" -ForegroundColor Green
        $targetPath = $flutterPath
    }
}

if ($shouldMove) {
    Write-Host ""
    Write-Host "[4] Deplacement de Flutter..." -ForegroundColor Yellow
    
    # Creer C:\src\ s'il n'existe pas
    $srcPath = "C:\src"
    if (-not (Test-Path $srcPath)) {
        try {
            New-Item -ItemType Directory -Path $srcPath -Force | Out-Null
            Write-Host "✓ Dossier C:\src\ cree" -ForegroundColor Green
        } catch {
            Write-Host "✗ Erreur lors de la creation de C:\src\ : $_" -ForegroundColor Red
            Write-Host "Veuillez creer manuellement C:\src\ et reexecuter le script" -ForegroundColor Yellow
            exit 1
        }
    }
    
    # Supprimer l'ancien dossier s'il existe
    if (Test-Path $targetPath) {
        Write-Host "Suppression de l'ancien dossier Flutter..." -ForegroundColor Yellow
        Remove-Item -Path $targetPath -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    # Deplacer Flutter
    try {
        Write-Host "Deplacement en cours... (cela peut prendre quelques minutes)" -ForegroundColor Yellow
        Move-Item -Path $flutterPath -Destination $targetPath -Force
        Write-Host "✓ Flutter deplace vers: $targetPath" -ForegroundColor Green
        $flutterPath = $targetPath
        $flutterBat = Join-Path $flutterPath "bin\flutter.bat"
    } catch {
        Write-Host "✗ Erreur lors du deplacement: $_" -ForegroundColor Red
        Write-Host "Vous pouvez copier manuellement le dossier flutter vers C:\src\" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ""

# Ajouter au PATH
Write-Host "[5] Ajout de Flutter au PATH..." -ForegroundColor Yellow
$flutterBinPath = Join-Path $flutterPath "bin"

# Verifier les privileges administrateur
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($isAdmin) {
    try {
        $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
        if ($currentPath -notlike "*$flutterBinPath*") {
            [Environment]::SetEnvironmentVariable("Path", "$currentPath;$flutterBinPath", "Machine")
            Write-Host "✓ Flutter ajoute au PATH systeme" -ForegroundColor Green
            # Ajouter aussi a la session actuelle
            $env:Path += ";$flutterBinPath"
        } else {
            Write-Host "✓ Flutter est deja dans le PATH systeme" -ForegroundColor Green
        }
    } catch {
        Write-Host "✗ Erreur lors de l'ajout au PATH: $_" -ForegroundColor Red
        Write-Host "Ajoutez manuellement au PATH: $flutterBinPath" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠ Privileges administrateur necessaires pour modifier le PATH systeme" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Pour ajouter Flutter au PATH manuellement:" -ForegroundColor Yellow
    Write-Host "  1. Appuyez sur Windows + R" -ForegroundColor White
    Write-Host "  2. Tapez: sysdm.cpl" -ForegroundColor White
    Write-Host "  3. Onglet Avance > Variables d'environnement" -ForegroundColor White
    Write-Host "  4. Dans Variables systeme, selectionnez Path > Modifier" -ForegroundColor White
    Write-Host "  5. Ajoutez: $flutterBinPath" -ForegroundColor White
    Write-Host ""
    
    # Ajouter au PATH de la session actuelle
    $env:Path += ";$flutterBinPath"
    Write-Host "✓ Flutter ajoute au PATH de cette session seulement" -ForegroundColor Green
}

Write-Host ""

# Verification finale
Write-Host "[6] Verification finale..." -ForegroundColor Yellow
& $flutterBat doctor

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Configuration terminee !" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Flutter est maintenant configure dans: $flutterPath" -ForegroundColor Green
Write-Host ""
Write-Host "IMPORTANT: Redemarrez votre terminal pour que les changements prennent effet" -ForegroundColor Yellow
Write-Host ""
Write-Host "Ensuite, testez avec:" -ForegroundColor Yellow
Write-Host "  flutter --version" -ForegroundColor White
Write-Host "  flutter doctor" -ForegroundColor White
Write-Host ""
