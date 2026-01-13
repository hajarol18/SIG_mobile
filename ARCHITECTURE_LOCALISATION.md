# Architecture - Gestion de la Localisation

## 📍 Où se Trouve la Gestion de la Localisation

### ❌ `construction_form_screen.dart` (Formulaire)
**N'est PAS responsable de la localisation GPS**

Ce fichier gère :
- ✅ Le formulaire de saisie (adresse, contact, type, notes)
- ✅ Le bouton pour dessiner le polygone
- ✅ La sauvegarde des coordonnées du polygone (géométrie)
- ❌ **N'obtient PAS la position GPS**

### ✅ Fichiers Responsables de la Localisation

#### 1. **`lib/screens/map_screen.dart`** 
**Responsable de la localisation sur la carte principale**

```dart
Future<void> _getCurrentLocation() async {
  // Obtient la position GPS actuelle
  Position position = await Geolocator.getCurrentPosition();
  _currentPosition = LatLng(position.latitude, position.longitude);
  // Centre la carte sur la position
  _mapController.move(_currentPosition!, 15.0);
}
```

**Fonctions :**
- ✅ Obtient la position GPS de l'utilisateur
- ✅ Centre la carte sur la position actuelle
- ✅ Affiche le bouton "Ma position" pour recentrer

#### 2. **`lib/widgets/polygon_drawer.dart`**
**Responsable de la localisation lors du dessin de polygone**

```dart
Future<void> _getCurrentLocation() async {
  // Obtient la position GPS pour centrer la carte de dessin
  Position position = await Geolocator.getCurrentPosition();
  _currentPosition = LatLng(position.latitude, position.longitude);
  _mapController.move(_currentPosition!, 15.0);
}
```

**Fonctions :**
- ✅ Obtient la position GPS pour centrer la carte de dessin
- ✅ Permet de dessiner le polygone autour de la position actuelle
- ✅ Si GPS indisponible, utilise Casablanca par défaut

## 🔄 Flux de Localisation

### Scénario 1 : Affichage de la Carte
```
map_screen.dart
  └─> _getCurrentLocation()
      └─> Geolocator.getCurrentPosition()
          └─> Centre la carte sur la position GPS
```

### Scénario 2 : Dessiner un Polygone
```
construction_form_screen.dart
  └─> Bouton "Dessiner sur la carte"
      └─> polygon_drawer.dart
          └─> _getCurrentLocation()
              └─> Geolocator.getCurrentPosition()
                  └─> Centre la carte de dessin sur la position GPS
                      └─> L'utilisateur dessine le polygone
                          └─> Les coordonnées sont sauvegardées dans construction_form_screen.dart
```

### Scénario 3 : Sauvegarde des Coordonnées
```
construction_form_screen.dart
  └─> _save()
      └─> geometry: jsonEncode(_polygonCoordinates)
          └─> Les coordonnées du polygone sont sauvegardées (pas la position GPS)
```

## 📊 Résumé : Qui Fait Quoi

| Fichier | Responsabilité Localisation |
|---------|---------------------------|
| `map_screen.dart` | ✅ Obtient la position GPS pour centrer la carte principale |
| `polygon_drawer.dart` | ✅ Obtient la position GPS pour centrer la carte de dessin |
| `construction_form_screen.dart` | ❌ **N'obtient PAS la position GPS**<br>✅ Sauvegarde les coordonnées du polygone dessiné |

## 🎯 Données de Localisation Stockées

### Ce qui est Sauvegardé :
- ✅ **Géométrie du polygone** : Les coordonnées (latitude/longitude) de chaque point du polygone
- ✅ **Adresse textuelle** : L'adresse saisie par l'utilisateur
- ❌ **Position GPS de l'utilisateur** : N'est PAS sauvegardée (seulement utilisée pour centrer la carte)

### Format de Stockage :
```dart
geometry: jsonEncode(_polygonCoordinates)
// Format: [[longitude1, latitude1], [longitude2, latitude2], ...]
```

## 🔧 Si Vous Voulez Sauvegarder la Position GPS

Si vous voulez aussi sauvegarder la position GPS de l'utilisateur lors de la création :

1. **Modifier `construction_form_screen.dart`** :
   - Ajouter un champ `userLocation` dans le modèle `Construction`
   - Obtenir la position GPS dans `construction_form_screen.dart`
   - Sauvegarder avec les autres données

2. **Modifier `lib/models/construction.dart`** :
   - Ajouter un champ optionnel pour la position GPS de l'utilisateur

## ✅ Conclusion

**`construction_form_screen.dart`** :
- ❌ N'obtient PAS la position GPS
- ✅ Sauvegarde les coordonnées du polygone (géométrie)
- ✅ Gère le formulaire de saisie

**La localisation GPS est gérée par :**
- ✅ `map_screen.dart` - Pour la carte principale
- ✅ `polygon_drawer.dart` - Pour la carte de dessin
