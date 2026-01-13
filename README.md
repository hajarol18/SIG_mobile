# Application Mobile de Relevé Cartographique (SIG)

Application mobile développée avec Flutter pour le relevé cartographique des constructions.

## Fonctionnalités

- ✅ Authentification
- ✅ Relevé des polygones pour les constructions
- ✅ Formulaire de saisie (adresse, contact, type de construction, ...)
- ✅ Affichage des constructions sur la carte avec symbologie par type
- ✅ Liste des constructions avec navigation vers la carte
- ✅ Recherche multicritères (type, adresse, ...)

## Technologies

- **Flutter** : Framework de développement mobile
- **SQLite** : Base de données locale (via sqflite)
- **Leaflet** : Bibliothèque de cartes (via flutter_map)

## Installation

1. Installer Flutter : https://flutter.dev/docs/get-started/install
2. Vérifier l'installation : `flutter doctor`
3. Installer les dépendances : `flutter pub get`
4. Lancer l'application : `flutter run`

## Structure du projet

```
lib/
├── main.dart
├── models/
│   ├── construction.dart
│   └── user.dart
├── database/
│   └── database_helper.dart
├── screens/
│   ├── login_screen.dart
│   ├── map_screen.dart
│   ├── construction_form_screen.dart
│   ├── construction_list_screen.dart
│   └── search_screen.dart
├── widgets/
│   ├── polygon_drawer.dart
│   ├── construction_marker.dart
│   └── construction_card.dart
└── providers/
    ├── auth_provider.dart
    └── construction_provider.dart
```

## Note importante

Pour utiliser cette application, vous devez avoir Flutter installé sur votre système. Si Flutter n'est pas installé, consultez la documentation officielle : https://flutter.dev/docs/get-started/install
