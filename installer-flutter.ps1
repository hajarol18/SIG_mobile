# Script d'installation automatique de Flutter sur Windows
# Executez en tant qu'Administrateur: powershell -ExecutionPolicy Bypass -File .\installer-flutter.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installation Automatique de Flutter" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verifier les privileges administrateur
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ATTENTION: Ce script necessite des privileges administrateur pour modifier le PATH." -ForegroundColor Yellow
    Write-Host "Lancez PowerShell en tant qu'Administrateur et reexecutez ce script." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Ou vous pouvez suivre les etapes manuelles dans VERIFIER_FLUTTER.md" -ForegroundColor Cyan
    Write-Host ""
    $continue = Read-Host "Voulez-vous continuer quand meme (pour creer les dossiers seulement)? (O/N)"
    if ($continue -ne "O" -and $continue -ne "o") {
        exit
    }
}

# Etape 1: Creer le dossier C:\src\ s'il n'existe pas
Write-Host "[1] Creation du dossier C:\src\..." -ForegroundColor Yellow
$srcPath = "C:\src"
if (-not (Test-Path $srcPath)) {
    try {
        New-Item -ItemType Directory -Path $srcPath -Force | Out-Null
        Write-Host "✓ Dossier C:\src\ cree avec succes" -ForegroundColor Green
    } catch {
        Write-Host "✗ Erreur lors de la creation du dossier: $_" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "✓ Le dossier C:\src\ existe deja" -ForegroundColor Green
}

Write-Host ""

# Etape 2: Chercher un fichier ZIP Flutter telecharge
Write-Host "[2] Recherche du fichier ZIP Flutter..." -ForegroundColor Yellow
$flutterZipPaths = @(
    "$env:USERPROFILE\Downloads\flutter_windows_*.zip",
    "$env:USERPROFILE\Desktop\flutter_windows_*.zip",
    "C:\Users\$env:USERNAME\Downloads\flutter_windows_*.zip"
)

$flutterZip = $null
foreach ($pattern in $flutterZipPaths) {
    $found = Get-ChildItem -Path (Split-Path $pattern -Parent) -Filter (Split-Path $pattern -Leaf) -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) {
        $flutterZip = $found.FullName
        break
    }
}

if ($flutterZip -and (Test-Path $flutterZip)) {
    Write-Host "✓ Fichier ZIP trouve: $flutterZip" -ForegroundColor Green
    Write-Host ""
    Write-Host "[3] Extraction du fichier ZIP..." -ForegroundColor Yellow
    
    # Supprimer le dossier flutter existant s'il existe
    $flutterPath = "C:\src\flutter"
    if (Test-Path $flutterPath) {
        Write-Host "Suppression de l'ancien dossier Flutter..." -ForegroundColor Yellow
        Remove-Item -Path $flutterPath -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    try {
        # Extraire le ZIP
        Expand-Archive -Path $flutterZip -DestinationPath $srcPath -Force
        Write-Host "✓ Extraction terminee avec succes" -ForegroundColor Green
        Write-Host "✓ Flutter installe dans: C:\src\flutter" -ForegroundColor Green
    } catch {
        Write-Host "✗ Erreur lors de l'extraction: $_" -ForegroundColor Red
        Write-Host "Essayez d'extraire manuellement le fichier ZIP dans C:\src\" -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "✗ Fichier ZIP Flutter non trouve dans les emplacements standards" -ForegroundColor Red
    Write-Host ""
    Write-Host "Veuillez:" -ForegroundColor Yellow
    Write-Host "  1. Telecharger Flutter depuis: https://flutter.dev/docs/get-started/install/windows" -ForegroundColor White
    Write-Host "  2. Sauvegarder le fichier ZIP dans votre dossier Downloads" -ForegroundColor White
    Write-Host "  3. Reexecutez ce script" -ForegroundColor White
    Write-Host ""
    $manualZip = Read-Host "Ou entrez le chemin complet du fichier ZIP Flutter (laissez vide pour annuler)"
    if ($manualZip -and (Test-Path $manualZip)) {
        Write-Host ""
        Write-Host "[3] Extraction du fichier ZIP..." -ForegroundColor Yellow
        try {
            Expand-Archive -Path $manualZip -DestinationPath $srcPath -Force
            Write-Host "✓ Extraction terminee avec succes" -ForegroundColor Green
        } catch {
            Write-Host "✗ Erreur lors de l'extraction: $_" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "Installation incomplete. Veuillez extraire le ZIP manuellement dans C:\src\" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ""

# Etape 3: Verifier que Flutter est bien extrait
$flutterPath = "C:\src\flutter"
$flutterBat = Join-Path $flutterPath "bin\flutter.bat"
if (-not (Test-Path $flutterBat)) {
    Write-Host "✗ Erreur: Flutter n'a pas ete correctement extrait" -ForegroundColor Red
    Write-Host "Verifiez que le contenu du ZIP a bien ete extrait dans C:\src\flutter\" -ForegroundColor Yellow
    exit 1
}

Write-Host "[4] Verification de l'installation..." -ForegroundColor Yellow
& $flutterBat --version | Select-Object -First 3
Write-Host ""

# Etape 4: Ajouter Flutter au PATH
Write-Host "[5] Ajout de Flutter au PATH..." -ForegroundColor Yellow
$flutterBinPath = "C:\src\flutter\bin"

if ($isAdmin) {
    try {
        $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
        if ($currentPath -notlike "*$flutterBinPath*") {
            [Environment]::SetEnvironmentVariable("Path", "$currentPath;$flutterBinPath", "Machine")
            Write-Host "✓ Flutter ajoute au PATH systeme" -ForegroundColor Green
            Write-Host ""
            Write-Host "IMPORTANT: Redemarrez votre terminal pour que les changements prennent effet" -ForegroundColor Yellow
        } else {
            Write-Host "✓ Flutter est deja dans le PATH systeme" -ForegroundColor Green
        }
        
        # Ajouter aussi au PATH de la session actuelle
        $env:Path += ";$flutterBinPath"
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
    
    # Ajouter au PATH de la session actuelle seulement
    $env:Path += ";$flutterBinPath"
    Write-Host "✓ Flutter ajoute au PATH de cette session seulement" -ForegroundColor Green
}

Write-Host ""

# Etape 5: Verifier l'installation
Write-Host "[6] Verification finale..." -ForegroundColor Yellow
Write-Host ""

# Utiliser le chemin direct pour cette verification
& $flutterBat doctor

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installation terminee !" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Prochaines etapes:" -ForegroundColor Yellow
Write-Host "  1. Si le PATH a ete modifie, REDEMARREZ votre terminal" -ForegroundColor White
Write-Host "  2. Verifiez avec: flutter --version" -ForegroundColor White
Write-Host "  3. Installez les dependances du projet: flutter pub get" -ForegroundColor White
Write-Host "  4. Lancez l'application: flutter run" -ForegroundColor White
Write-Host ""
