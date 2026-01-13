# Guide d'Installation et de Démarrage

## Prérequis

### 1. Installation de Flutter

Si Flutter n'est pas installé, suivez ces étapes :

1. **Télécharger Flutter** : https://flutter.dev/docs/get-started/install/windows
2. **Extraire Flutter** dans un dossier (ex: `C:\src\flutter`)
3. **Ajouter Flutter au PATH** :
   - Ouvrez "Variables d'environnement" dans Windows
   - Ajoutez `C:\src\flutter\bin` au PATH
4. **Vérifier l'installation** :
   ```bash
   flutter doctor
   ```

### 2. Installation d'un éditeur (recommandé)

- **VS Code** : https://code.visualstudio.com/
  - Extension Flutter recommandée
- **Android Studio** : https://developer.android.com/studio
  - Nécessaire pour compiler sur Android

## Configuration du Projet

### 1. Installer les dépendances

Une fois Flutter installé, exécutez dans le dossier du projet :

```bash
flutter pub get
```

### 2. Vérifier la configuration

```bash
flutter doctor
```

Assurez-vous que :
- ✅ Flutter est installé
- ✅ Android toolchain est configuré (si vous testez sur Android)
- ✅ VS Code ou Android Studio est installé

## Lancement de l'Application

### Option 1 : Émulateur/Simulateur

1. **Android Émulateur** :
   - Ouvrez Android Studio
   - Créez un émulateur Android via AVD Manager
   - Démarrez l'émulateur

2. **iOS Simulateur** (Mac uniquement) :
   - Ouvrez Xcode
   - Créez un simulateur iOS
   - Démarrez le simulateur

3. **Lancer l'application** :
   ```bash
   flutter run
   ```

### Option 2 : Appareil physique

1. **Android** :
   - Activez le "Mode développeur" sur votre téléphone
   - Activez le "Débogage USB"
   - Connectez votre téléphone via USB
   - Autorisez le débogage USB sur votre téléphone
   - Exécutez : `flutter run`

2. **iOS** (Mac uniquement) :
   - Connectez votre iPhone via USB
   - Faites confiance à l'ordinateur sur votre iPhone
   - Exécutez : `flutter run`

## Permissions requises

L'application nécessite les permissions suivantes :

- **Localisation** : Pour obtenir la position actuelle et dessiner des polygones
- **Stockage** : Pour sauvegarder la base de données SQLite locale

Ces permissions sont demandées automatiquement lors du premier lancement.

## Compte par défaut

L'application crée automatiquement un compte administrateur :
- **Nom d'utilisateur** : `admin`
- **Mot de passe** : `admin`

⚠️ **Important** : Changez ce mot de passe en production !

## Fonctionnalités principales

1. **Authentification** : Connexion/Inscription
2. **Relevé cartographique** : Dessiner des polygones sur la carte
3. **Formulaire de saisie** : Remplir les informations de chaque construction
4. **Visualisation** : Voir les constructions sur la carte avec symbologie par type
5. **Liste** : Consulter toutes les constructions enregistrées
6. **Recherche** : Recherche multicritères (type, adresse)

## Types de constructions et leurs couleurs

- 🔴 **Résidentiel** : Rouge
- 🔵 **Commercial** : Bleu
- 🟠 **Industriel** : Orange
- 🟢 **Administratif** : Vert
- 🟣 **Éducatif** : Magenta
- 🔵 **Sanitaire** : Cyan
- ⚫ **Autre** : Gris

## Résolution de problèmes

### Erreur "Flutter command not found"

Solution : Vérifiez que Flutter est dans votre PATH et redémarrez le terminal.

### Erreur "No devices found"

Solution : 
- Vérifiez qu'un émulateur est démarré OU
- Connectez un appareil physique et activez le débogage USB

### Erreur de permissions

Solution : Vérifiez que les permissions de localisation sont accordées dans les paramètres de l'application.

### Erreur "Package not found"

Solution : Exécutez `flutter pub get` pour installer toutes les dépendances.

## Structure du Projet

```
lib/
├── main.dart                    # Point d'entrée de l'application
├── models/                      # Modèles de données
│   ├── user.dart
│   └── construction.dart
├── database/                    # Gestion de la base de données
│   └── database_helper.dart
├── providers/                   # Gestion d'état (Provider)
│   ├── auth_provider.dart
│   └── construction_provider.dart
├── screens/                     # Écrans de l'application
│   ├── login_screen.dart
│   ├── map_screen.dart
│   ├── construction_form_screen.dart
│   ├── construction_list_screen.dart
│   └── search_screen.dart
└── widgets/                     # Widgets réutilisables
    ├── polygon_drawer.dart
    └── construction_card.dart
```

## Support

Pour toute question ou problème, consultez :
- Documentation Flutter : https://flutter.dev/docs
- Documentation flutter_map : https://docs.fleaflet.dev/
- Documentation sqflite : https://pub.dev/packages/sqflite
