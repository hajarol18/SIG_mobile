# Guide d'Installation Complète - Projet SIG Mobile

## 🎯 Installation en 3 Étapes Simples

### ✅ Étape 1 : Installer Flutter (Automatique)

1. **Télécharger Flutter** (Manuel - 1 fois) :
   - Allez sur : https://flutter.dev/docs/get-started/install/windows
   - Cliquez sur "Download Flutter SDK"
   - Téléchargez le fichier ZIP
   - **Laissez-le dans votre dossier Downloads**

2. **Exécuter le script d'installation automatique** :
   ```powershell
   # Ouvrez PowerShell EN TANT QU'ADMINISTRATEUR
   # Naviguez vers le dossier du projet
   cd C:\Users\Hajar\Desktop\projet_mobilr
   
   # Exécutez le script
   powershell -ExecutionPolicy Bypass -File .\installer-flutter.ps1
   ```

   Le script va automatiquement :
   - ✅ Créer le dossier `C:\src\`
   - ✅ Chercher le fichier ZIP Flutter
   - ✅ Extraire Flutter dans `C:\src\flutter\`
   - ✅ Ajouter Flutter au PATH
   - ✅ Vérifier l'installation

3. **Redémarrer le terminal** après l'installation

4. **Vérifier l'installation** :
   ```powershell
   flutter --version
   flutter doctor
   ```

### ✅ Étape 2 : Configurer le Projet (Automatique)

Une fois Flutter installé, configurez le projet :

```powershell
# Dans le dossier du projet
cd C:\Users\Hajar\Desktop\projet_mobilr

# Exécutez le script de configuration
powershell -ExecutionPolicy Bypass -File .\configurer-projet.ps1
```

Le script va automatiquement :
- ✅ Vérifier que Flutter est installé
- ✅ Vérifier la configuration avec `flutter doctor`
- ✅ Installer toutes les dépendances (`flutter pub get`)
- ✅ Vérifier la structure du projet
- ✅ Lister les appareils disponibles

### ✅ Étape 3 : Lancer l'Application

**Option A : Avec un Émulateur Android**

1. Ouvrez **Android Studio**
2. Créez un émulateur via **AVD Manager**
3. Démarrez l'émulateur
4. Dans le terminal :
   ```powershell
   flutter run
   ```

**Option B : Avec un Appareil Physique**

1. **Android** :
   - Activez le **Mode développeur** sur votre téléphone
   - Activez le **Débogage USB**
   - Connectez votre téléphone via USB
   - Autorisez le débogage sur votre téléphone
   ```powershell
   flutter run
   ```

2. **iOS** (Mac uniquement) :
   - Connectez votre iPhone via USB
   - Faites confiance à l'ordinateur
   ```powershell
   flutter run
   ```

## 📋 Scripts Disponibles

### 1. `check-flutter.ps1`
**Vérifie si Flutter est installé**
```powershell
powershell -ExecutionPolicy Bypass -File .\check-flutter.ps1
```

### 2. `installer-flutter.ps1`
**Installe Flutter automatiquement** (nécessite le ZIP téléchargé)
```powershell
powershell -ExecutionPolicy Bypass -File .\installer-flutter.ps1
```

### 3. `configurer-projet.ps1`
**Configure le projet après installation de Flutter**
```powershell
powershell -ExecutionPolicy Bypass -File .\configurer-projet.ps1
```

## 🚀 Commandes Rapides

```powershell
# Vérifier Flutter
flutter --version
flutter doctor

# Installer les dépendances
flutter pub get

# Voir les appareils disponibles
flutter devices

# Lancer l'application
flutter run

# Lancer sur un appareil spécifique
flutter run -d <device-id>

# Nettoyer le projet
flutter clean

# Construire l'application
flutter build apk  # Android
flutter build ios  # iOS (Mac uniquement)
```

## ⚠️ Résolution de Problèmes

### Erreur "Execution Policy"

Si vous obtenez une erreur lors de l'exécution des scripts :
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Flutter n'est pas trouvé après installation

1. **Redémarrez votre terminal** (très important !)
2. Vérifiez que `C:\src\flutter\bin` est bien dans le PATH
3. Vérifiez avec : `where.exe flutter`

### Erreur "No devices found"

- Démarrez un émulateur Android OU
- Connectez un appareil physique avec le débogage USB activé
- Vérifiez avec : `flutter devices`

### Erreur lors de `flutter pub get`

```powershell
# Nettoyer et réessayer
flutter clean
flutter pub get
```

## 📚 Documentation Disponible

- `README.md` - Vue d'ensemble du projet
- `DEMARRAGE_RAPIDE.md` - Guide de démarrage rapide
- `GUIDE_INSTALLATION.md` - Guide d'installation détaillé
- `VERIFIER_FLUTTER.md` - Comment vérifier Flutter
- `INSTALLATION_AUTOMATIQUE.md` - Installation automatique de Flutter
- `INSTALLATION_COMPLETE.md` - Ce fichier (guide complet)

## 🎉 C'est Prêt !

Une fois toutes les étapes terminées, votre application SIG Mobile est prête à être utilisée !

**Fonctionnalités disponibles :**
- ✅ Authentification
- ✅ Relevé cartographique (dessin de polygones)
- ✅ Formulaire de saisie des constructions
- ✅ Visualisation sur carte avec symbologie
- ✅ Liste des constructions
- ✅ Recherche multicritères

**Compte par défaut :**
- Username : `admin`
- Password : `admin`

Bon développement ! 🚀
