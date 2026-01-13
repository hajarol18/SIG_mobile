# Guide de Démarrage Rapide

## 🚀 Lancer l'Application Immédiatement

### Option 1 : Script Automatique (Recommandé)

Exécutez simplement :
```powershell
powershell -ExecutionPolicy Bypass -File .\lancer-app.ps1
```

Le script vous demandera sur quel appareil lancer l'application.

### Option 2 : Manuel (Session Actuelle)

Dans votre terminal PowerShell, exécutez d'abord :

```powershell
# Ajouter Flutter au PATH pour cette session
$env:Path += ";C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter\bin"

# Vérifier que Flutter fonctionne
flutter --version

# Lancer sur Windows Desktop
flutter run -d windows

# OU lancer sur Chrome
flutter run -d chrome
```

## ⚠️ Problème : "Flutter n'est pas reconnu"

C'est normal si vous avez redémarré le terminal. Flutter n'est pas encore ajouté au PATH de manière permanente.

### Solution Temporaire (Pour cette session uniquement)

Exécutez d'abord :
```powershell
powershell -ExecutionPolicy Bypass -File .\ajouter-flutter-path-session.ps1
```

Puis utilisez `flutter` normalement.

### Solution Permanente (Recommandé)

**Ajoutez Flutter au PATH de manière permanente** :

1. Appuyez sur `Windows + R`
2. Tapez : `sysdm.cpl` puis Entrée
3. Onglet **"Avancé"** → **"Variables d'environnement"**
4. Dans **"Variables système"**, sélectionnez **"Path"** → **"Modifier"**
5. Cliquez **"Nouveau"**
6. Ajoutez :
   ```
   C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter\bin
   ```
7. Cliquez **"OK"** partout
8. **Fermez et rouvrez votre terminal**

Ensuite, `flutter` fonctionnera dans tous vos terminaux !

## 📱 Appareils Disponibles

Votre système détecte actuellement :
- ✅ **Windows Desktop** - Application Windows native
- ✅ **Chrome** - Navigateur web (bon pour tester rapidement)
- ✅ **Edge** - Navigateur web

Pour tester sur un **vrai appareil mobile** :
- Installez **Android Studio**
- Créez un émulateur Android
- OU connectez un téléphone Android avec débogage USB activé

## 🎯 Commandes Utiles

```powershell
# Ajouter Flutter au PATH (session actuelle)
$env:Path += ";C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter\bin"

# Vérifier Flutter
flutter --version

# Vérifier la configuration
flutter doctor

# Voir les appareils disponibles
flutter devices

# Lancer l'application
flutter run -d windows      # Sur Windows
flutter run -d chrome       # Sur Chrome
flutter run -d edge         # Sur Edge

# Arrêter l'application
# Appuyez sur 'q' dans le terminal

# Nettoyer le projet
flutter clean

# Installer les dépendances
flutter pub get
```

## 🐛 Résolution de Problèmes

### "Flutter n'est pas reconnu"
→ Utilisez le script `ajouter-flutter-path-session.ps1` ou ajoutez Flutter au PATH de manière permanente (voir ci-dessus)

### "No devices found"
→ Lancez sur `windows` ou `chrome` qui sont toujours disponibles

### Erreur de compilation
→ Exécutez `flutter clean` puis `flutter pub get`

## ✅ Prochaines Étapes

1. **Ajoutez Flutter au PATH de manière permanente** (voir ci-dessus)
2. **Lancez l'application** avec `flutter run -d windows` ou `flutter run -d chrome`
3. **Testez les fonctionnalités** :
   - Connexion avec `admin/admin`
   - Dessiner des polygones sur la carte
   - Remplir des formulaires
   - Voir la liste des constructions

## 🎉 C'est Prêt !

Votre application SIG Mobile est configurée et prête à être utilisée !
