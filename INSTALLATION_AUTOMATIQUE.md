# Installation Automatique de Flutter

## 🚀 Installation Automatique en 3 Étapes

### Étape 1 : Télécharger Flutter (Manuel - 1 fois)

1. Allez sur : **https://flutter.dev/docs/get-started/install/windows**
2. Cliquez sur **"Download Flutter SDK"**
3. Téléchargez le fichier ZIP (environ 1.5 GB)
4. **Ne l'extrayez pas**, laissez-le dans votre dossier **Downloads**

### Étape 2 : Exécuter le Script d'Installation

**Option A : En tant qu'Administrateur (Recommandé)**

1. Cliquez droit sur **PowerShell** ou **Invite de commandes**
2. Sélectionnez **"Exécuter en tant qu'administrateur"**
3. Naviguez vers le dossier du projet :
   ```powershell
   cd C:\Users\Hajar\Desktop\projet_mobilr
   ```
4. Exécutez le script :
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\installer-flutter.ps1
   ```

**Option B : Sans Privilèges Administrateur**

1. Ouvrez PowerShell normalement
2. Naviguez vers le dossier du projet
3. Exécutez le script (il créera les dossiers et vous guidera pour le PATH) :
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\installer-flutter.ps1
   ```

### Étape 3 : Redémarrer le Terminal

Après l'installation, **fermez et rouvrez** votre terminal pour que les changements prennent effet.

## ✅ Ce que le Script Fait Automatiquement

Le script `installer-flutter.ps1` :

1. ✅ **Crée le dossier** `C:\src\` s'il n'existe pas
2. ✅ **Cherche automatiquement** le fichier ZIP Flutter dans :
   - `C:\Users\VotreNom\Downloads\`
   - `C:\Users\VotreNom\Desktop\`
3. ✅ **Extrait automatiquement** le ZIP dans `C:\src\flutter\`
4. ✅ **Vérifie** que Flutter est correctement installé
5. ✅ **Ajoute Flutter au PATH** (si vous avez les privilèges admin)
6. ✅ **Exécute** `flutter doctor` pour vérifier la configuration

## 🔍 Si le Script ne Trouve pas le ZIP

Le script vous demandera le chemin complet du fichier ZIP. Entrez simplement :
```
C:\Users\Hajar\Downloads\flutter_windows_3.x.x-stable.zip
```
(Remplacez par le nom exact de votre fichier)

## ⚠️ Si Vous n'Avez pas les Privilèges Administrateur

Si vous ne pouvez pas exécuter en tant qu'administrateur, le script :
- ✅ Créera quand même les dossiers
- ✅ Extraira Flutter
- ⚠️ Vous donnera des instructions pour ajouter manuellement au PATH

**Pour ajouter manuellement au PATH :**
1. Appuyez sur `Windows + R`
2. Tapez : `sysdm.cpl`
3. Onglet **"Avancé"** → **"Variables d'environnement"**
4. Dans **"Variables système"**, sélectionnez **"Path"** → **"Modifier"**
5. Cliquez **"Nouveau"**
6. Ajoutez : `C:\src\flutter\bin`
7. Cliquez **"OK"** partout

## ✅ Vérifier l'Installation

Après l'installation et avoir redémarré le terminal :

```powershell
# Vérifier la version
flutter --version

# Vérifier la configuration
flutter doctor
```

## 🎯 Après l'Installation de Flutter

Une fois Flutter installé, vous pouvez :

```powershell
# Aller dans le dossier du projet
cd C:\Users\Hajar\Desktop\projet_mobilr

# Installer les dépendances
flutter pub get

# Vérifier que tout fonctionne
flutter doctor

# Lancer l'application (nécessite un émulateur ou appareil connecté)
flutter run
```

## 🐛 Résolution de Problèmes

### Erreur "Execution Policy"

Si vous obtenez une erreur d'exécution de script :
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Le Script ne Trouve pas le ZIP

1. Vérifiez que le fichier ZIP est bien dans `Downloads` ou `Desktop`
2. Ou entrez manuellement le chemin complet quand le script le demande

### Flutter n'est pas dans le PATH après installation

1. **Redémarrez votre terminal** (important !)
2. Si ça ne marche toujours pas, ajoutez manuellement au PATH (voir ci-dessus)
3. Vérifiez avec : `flutter --version`

### Erreur lors de l'Extraction

- Vérifiez que vous avez assez d'espace disque (environ 2 GB)
- Vérifiez que le fichier ZIP n'est pas corrompu (retéléchargez si nécessaire)
- Essayez d'extraire manuellement avec l'Explorateur Windows

## 📝 Commandes Utiles

```powershell
# Vérifier où Flutter est installé
where.exe flutter

# Voir la version
flutter --version

# Vérifier la configuration complète
flutter doctor -v

# Mettre à jour Flutter
flutter upgrade
```

## 🎉 C'est Tout !

Une fois Flutter installé, votre projet SIG Mobile est prêt à être utilisé !
