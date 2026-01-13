# Notes de Compatibilité - Plateformes

## ✅ Plateformes Supportées

L'application SIG Mobile a été conçue principalement pour :
- ✅ **Android** (Plateforme principale recommandée)
- ✅ **iOS** (Si vous développez sur Mac)

## ⚠️ Limitations sur Windows/Web

### Base de Données (sqflite)

`sqflite` fonctionne principalement sur **Android** et **iOS**. Sur **Windows Desktop** et **Web**, il y a des limitations :

**Solutions possibles :**

1. **Utiliser un émulateur Android** (Recommandé)
   - Installez Android Studio
   - Créez un émulateur Android
   - Testez l'application sur l'émulateur

2. **Utiliser sqflite_common_ffi pour Windows**
   - Nécessite des modifications du code
   - Fonctionne uniquement sur Windows Desktop, pas sur Web

3. **Utiliser une alternative pour Web**
   - Utiliser `shared_preferences` pour le stockage simple
   - OU utiliser une base de données IndexedDB via un package web

### Géolocalisation

`geolocator` fonctionne sur toutes les plateformes mais :
- Sur **Web** : Nécessite HTTPS (ou localhost)
- Sur **Windows** : Peut avoir des limitations

## 🎯 Recommandations

### Pour Développer et Tester

**Option 1 : Émulateur Android (Recommandé)**
```powershell
# Installer Android Studio
# Créer un émulateur via AVD Manager
# Puis :
flutter run -d android
```

**Option 2 : Appareil Physique Android**
```powershell
# Activer le mode développeur
# Activer le débogage USB
# Connecter le téléphone
flutter run -d <device-id>
```

**Option 3 : Tester l'Interface sur Chrome (Sans Base de Données)**
- L'interface fonctionnera mais la base de données peut ne pas fonctionner
- Bon pour tester l'UI et la navigation

### Pour Déployer

L'application devrait être déployée sur :
- ✅ **Android** (APK ou App Bundle)
- ✅ **iOS** (si vous avez un Mac)

## 🔧 Si Vous Voulez Tester sur Windows

Pour faire fonctionner la base de données sur Windows, vous devrez modifier `database_helper.dart` pour utiliser `sqflite_common_ffi`. Cela nécessite :

1. Ajouter `sqflite_common_ffi` au `pubspec.yaml`
2. Modifier `database_helper.dart` pour utiliser l'initialisation FFI
3. Configurer les imports conditionnels

Cependant, **pour un projet SIG Mobile**, il est recommandé d'utiliser un **émulateur Android** ou un **appareil Android réel** car :
- Toutes les fonctionnalités fonctionneront correctement
- C'est l'environnement cible de l'application
- La géolocalisation fonctionnera mieux
- Les tests seront plus réalistes

## 📝 Commandes Utiles

```powershell
# Voir les appareils disponibles
flutter devices

# Lancer sur Android (si émulateur/appareil disponible)
flutter run -d android

# Lancer sur Chrome (pour tester l'UI, DB peut ne pas fonctionner)
flutter run -d chrome

# Lancer sur Windows (DB peut ne pas fonctionner)
flutter run -d windows
```

## ✅ Conclusion

L'application fonctionne parfaitement sur **Android** et **iOS**. Pour tester complètement toutes les fonctionnalités (surtout la base de données SQLite), utilisez un **émulateur Android** ou un **appareil Android réel**.
