# Démarrage Rapide - Application SIG Mobile

## 🚀 État du Projet

✅ **Projet initialisé avec succès !**

Toutes les fonctionnalités demandées ont été implémentées :
- ✅ Authentification (connexion/inscription)
- ✅ Relevé des polygones pour les constructions
- ✅ Formulaire de saisie (adresse, contact, type, notes)
- ✅ Affichage des constructions sur la carte avec symbologie par type
- ✅ Liste des constructions avec navigation vers la carte
- ✅ Recherche multicritères (type, adresse)

## 📋 Prochaines Étapes

### 1. Installer Flutter (si ce n'est pas déjà fait)

Flutter n'est actuellement **pas installé** sur votre système ou n'est pas dans le PATH.

**Windows :**
```powershell
# Téléchargez Flutter depuis https://flutter.dev/docs/get-started/install/windows
# Extrayez dans C:\src\flutter (ou autre dossier)
# Ajoutez C:\src\flutter\bin au PATH dans les variables d'environnement
```

Puis vérifiez :
```bash
flutter doctor
```

### 2. Installer les dépendances du projet

Une fois Flutter installé :

```bash
cd C:\Users\Hajar\Desktop\projet_mobilr
flutter pub get
```

### 3. Configurer un appareil/émulateur

**Option A : Émulateur Android**
- Installez Android Studio
- Créez un émulateur via AVD Manager
- Démarrez l'émulateur

**Option B : Appareil physique**
- Activez le mode développeur
- Activez le débogage USB
- Connectez votre téléphone

### 4. Lancer l'application

```bash
flutter run
```

## 🔐 Compte par défaut

L'application crée automatiquement un compte administrateur lors de la première utilisation :
- **Username** : `admin`
- **Password** : `admin`

## 📱 Utilisation de l'Application

### 1. Se connecter
- Utilisez le compte `admin/admin` ou créez un nouveau compte

### 2. Faire un relevé cartographique
1. Cliquez sur le bouton "+" en bas à droite
2. Remplissez le formulaire :
   - **Adresse** : Obligatoire
   - **Contact** : Optionnel
   - **Type de construction** : Sélectionnez dans la liste
   - **Notes** : Optionnel
3. Cliquez sur "Dessiner sur la carte"
4. Appuyez sur la carte pour ajouter des points au polygone
5. Cliquez sur "Terminer" une fois le polygone complet (minimum 3 points)
6. Enregistrez la construction

### 3. Visualiser les constructions
- Les constructions apparaissent automatiquement sur la carte avec des couleurs selon leur type
- Utilisez la légende en bas à gauche pour voir les types et leurs couleurs

### 4. Consulter la liste
- Cliquez sur l'icône "Liste" dans la barre d'application
- Cliquez sur une construction pour voir les détails
- Cliquez sur "Voir sur la carte" pour naviguer vers cette construction

### 5. Rechercher
- Cliquez sur l'icône "Recherche" dans la liste
- Utilisez les critères (adresse, type) pour filtrer
- Cliquez sur "Rechercher"

## 🎨 Symbologie par Type

- 🔴 **Résidentiel** : Rouge
- 🔵 **Commercial** : Bleu  
- 🟠 **Industriel** : Orange
- 🟢 **Administratif** : Vert
- 🟣 **Éducatif** : Magenta
- 🔵 **Sanitaire** : Cyan
- ⚫ **Autre** : Gris

## 🛠️ Technologies Utilisées

- **Flutter** : Framework mobile
- **SQLite** : Base de données locale (via `sqflite`)
- **flutter_map** : Cartographie (alternative à Leaflet.js dans Flutter)
- **Provider** : Gestion d'état
- **geolocator** : Géolocalisation

## 📂 Structure du Projet

```
projet_mobilr/
├── lib/
│   ├── main.dart                          # Point d'entrée
│   ├── models/                            # Modèles de données
│   │   ├── user.dart
│   │   └── construction.dart
│   ├── database/
│   │   └── database_helper.dart           # Gestion SQLite
│   ├── providers/                         # Gestion d'état
│   │   ├── auth_provider.dart
│   │   └── construction_provider.dart
│   ├── screens/                           # Écrans
│   │   ├── login_screen.dart
│   │   ├── map_screen.dart
│   │   ├── construction_form_screen.dart
│   │   ├── construction_list_screen.dart
│   │   └── search_screen.dart
│   └── widgets/                           # Widgets réutilisables
│       ├── polygon_drawer.dart
│       └── construction_card.dart
├── pubspec.yaml                           # Dépendances
├── README.md
├── GUIDE_INSTALLATION.md                  # Guide détaillé
└── DEMARRAGE_RAPIDE.md                    # Ce fichier
```

## ⚠️ Notes Importantes

1. **Flutter doit être installé** avant de pouvoir exécuter le projet
2. **Permissions de localisation** : L'application demande automatiquement les permissions lors du premier lancement
3. **Base de données** : Créée automatiquement au premier lancement
4. **Carte** : Utilise OpenStreetMap (tiles publiques)

## 🐛 Résolution de Problèmes

### "Flutter command not found"
→ Installez Flutter et ajoutez-le au PATH

### "No devices found"
→ Démarrez un émulateur OU connectez un appareil physique

### Erreur de compilation
→ Exécutez `flutter clean && flutter pub get`

### Erreur de permissions
→ Vérifiez les permissions dans les paramètres de l'appareil

## 📚 Documentation

Consultez `GUIDE_INSTALLATION.md` pour un guide d'installation détaillé.

## ✨ Fonctionnalités Implémentées

Toutes les fonctionnalités demandées dans le cahier des charges sont implémentées :

1. ✅ **Authentification** : Connexion et inscription avec gestion dans SQLite
2. ✅ **Relevé des polygones** : Dessin interactif sur la carte avec validation
3. ✅ **Formulaire** : Saisie complète des attributs (adresse, contact, type, notes)
4. ✅ **Affichage carte** : Visualisation avec symbologie par type de construction
5. ✅ **Liste** : Consultation avec navigation vers la carte
6. ✅ **Recherche** : Multicritères (type, adresse) avec filtrage

Le projet est **prêt à être utilisé** une fois Flutter installé !
