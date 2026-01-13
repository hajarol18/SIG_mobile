# Comment Vérifier si Flutter est Installé sur Windows

## ✅ Méthodes pour Vérifier Flutter

### Méthode 1 : Vérifier via la ligne de commande

Ouvrez PowerShell ou Invite de commandes (CMD) et exécutez :

```bash
flutter --version
```

**Si Flutter est installé**, vous verrez quelque chose comme :
```
Flutter 3.16.0 • channel stable • https://github.com/flutter/flutter.git
Framework • revision abc123 (2 days ago) • 2024-01-01 12:00:00 -0800
Engine • revision def456
Tools • Dart 3.2.0 • DevTools 2.25.0
```

**Si Flutter n'est PAS installé**, vous verrez :
```
'flutter' n'est pas reconnu comme une commande...
```

### Méthode 2 : Vérifier dans les Variables d'Environnement

1. Appuyez sur `Windows + R`
2. Tapez `sysdm.cpl` et appuyez sur Entrée
3. Allez dans l'onglet **"Avancé"**
4. Cliquez sur **"Variables d'environnement"**
5. Dans **"Variables système"**, cherchez **"Path"**
6. Cliquez sur **"Modifier"**
7. Vérifiez si une entrée contient `flutter` ou `\flutter\bin`

### Méthode 3 : Vérifier les Emplacements Courants

Flutter est généralement installé dans :
- `C:\src\flutter\`
- `C:\flutter\`
- `%USERPROFILE%\flutter\` (généralement `C:\Users\VotreNom\flutter\`)

**Pour vérifier manuellement :**
1. Ouvrez l'Explorateur de fichiers
2. Allez dans `C:\src\` et cherchez un dossier `flutter`
3. Si trouvé, allez dans `flutter\bin\` et vérifiez s'il y a `flutter.bat`

### Méthode 4 : Commande PowerShell Avancée

Dans PowerShell, exécutez :

```powershell
# Chercher Flutter dans les emplacements courants
$locations = @(
    "C:\src\flutter",
    "C:\flutter",
    "$env:USERPROFILE\flutter",
    "$env:LOCALAPPDATA\flutter"
)

foreach ($loc in $locations) {
    if (Test-Path "$loc\bin\flutter.bat") {
        Write-Host "✓ Flutter trouvé dans: $loc" -ForegroundColor Green
        & "$loc\bin\flutter.bat" --version
        break
    }
}
```

## 🔍 Résultat de Votre Vérification

**D'après la vérification effectuée sur votre PC :**
- ❌ Flutter **N'EST PAS installé** ou **n'est pas dans le PATH**

## 📥 Comment Installer Flutter (si non installé)

### Option 1 : Installation Manuelle (Recommandée)

1. **Télécharger Flutter :**
   - Allez sur : https://flutter.dev/docs/get-started/install/windows
   - Cliquez sur "Download Flutter SDK"
   - Téléchargez le fichier ZIP (environ 1.5 GB)

2. **Extraire Flutter :**
   - Créez un dossier `C:\src\` si il n'existe pas
   - Extrayez le ZIP dans `C:\src\`
   - Vous devriez avoir : `C:\src\flutter\`

3. **Ajouter Flutter au PATH :**
   - Ouvrez "Variables d'environnement" (voir Méthode 2 ci-dessus)
   - Dans "Variables système", sélectionnez **"Path"** et cliquez **"Modifier"**
   - Cliquez **"Nouveau"**
   - Ajoutez : `C:\src\flutter\bin`
   - Cliquez **"OK"** sur toutes les fenêtres

4. **Redémarrer le terminal :**
   - Fermez et rouvrez PowerShell/CMD
   - Exécutez : `flutter doctor`

### Option 2 : Installation via Chocolatey (si installé)

```bash
choco install flutter
```

### Option 3 : Installation via Git

```bash
git clone https://github.com/flutter/flutter.git -b stable C:\src\flutter
```

Puis ajoutez `C:\src\flutter\bin` au PATH (voir Option 1, étape 3).

## ✅ Vérifier l'Installation Après Installation

Après avoir installé Flutter :

1. **Ouvrez un NOUVEAU terminal** (important !)
2. Exécutez :
   ```bash
   flutter --version
   ```
3. Exécutez :
   ```bash
   flutter doctor
   ```

La commande `flutter doctor` vous indiquera :
- ✅ Ce qui est correctement configuré
- ❌ Ce qui manque ou doit être configuré

## 🛠️ Après Installation : Configuration Nécessaire

Flutter nécessite généralement :
- ✅ **Android Studio** ou **VS Code** pour le développement
- ✅ **Android SDK** pour tester sur Android
- ✅ **Git** pour le contrôle de version

## 📝 Commandes Utiles

```bash
# Vérifier la version
flutter --version

# Vérifier la configuration
flutter doctor

# Voir les canaux disponibles
flutter channel

# Mettre à jour Flutter
flutter upgrade

# Voir où Flutter est installé
where flutter  # Dans CMD
Get-Command flutter  # Dans PowerShell
```

## ⚠️ Problèmes Courants

### "Flutter command not found" même après installation
- **Solution** : Redémarrer le terminal/IDE
- **Solution** : Vérifier que le PATH est correctement configuré
- **Solution** : Redémarrer Windows

### "Flutter doctor" indique des erreurs
- Consultez les messages de `flutter doctor` - ils indiquent généralement ce qui manque
- Suivez les liens fournis pour installer les composants manquants

## 📚 Ressources

- Documentation officielle : https://flutter.dev/docs/get-started/install/windows
- Guide d'installation détaillé : https://docs.flutter.dev/get-started/install/windows

---

**En résumé : Flutter n'est pas actuellement installé sur votre PC.**
Suivez les instructions ci-dessus pour l'installer avant de pouvoir lancer votre projet SIG Mobile.
