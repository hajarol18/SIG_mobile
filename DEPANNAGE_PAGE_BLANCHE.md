# Dépannage - Page Blanche dans Chrome

## 🔍 Diagnostic

Si vous voyez une page blanche dans Chrome après avoir lancé `flutter run -d chrome`, voici comment résoudre le problème :

## ✅ Solutions

### Solution 1 : Vérifier la Console du Navigateur

1. Dans Chrome, appuyez sur **F12** pour ouvrir les outils développeur
2. Allez dans l'onglet **"Console"**
3. Regardez s'il y a des erreurs en rouge
4. Copiez les erreurs et cherchez-les dans la documentation Flutter

### Solution 2 : Activer le Mode Développeur de Windows

Le message "Building with plugins requires symlink support" indique qu'il faut activer le mode développeur :

1. Appuyez sur **Windows + I** pour ouvrir les paramètres
2. Allez dans **"Privacy & Security"** → **"For developers"**
3. Activez **"Developer Mode"**
4. Redémarrez votre terminal
5. Relancez : `flutter run -d chrome`

### Solution 3 : Utiliser le Renderer HTML

Si CanvasKit cause des problèmes, utilisez HTML :

```powershell
flutter run -d chrome --web-renderer html
```

### Solution 4 : Nettoyer et Reconstruire

```powershell
# Nettoyer
flutter clean

# Réinstaller les dépendances
flutter pub get

# Relancer
flutter run -d chrome
```

### Solution 5 : Vérifier les Erreurs de Compilation

Dans votre terminal où vous avez lancé `flutter run`, regardez les erreurs de compilation. Si vous voyez des erreurs, corrigez-les.

### Solution 6 : Vérifier le Port

Parfois le port est occupé. Essayez un autre port :

```powershell
flutter run -d chrome --web-port=8080
```

### Solution 7 : Mode Debug Détaillé

Lancez avec plus d'informations :

```powershell
flutter run -d chrome -v
```

## 🐛 Erreurs Courantes

### Erreur : "Uncaught Error"

Cela signifie généralement qu'il y a une erreur dans le code Dart qui n'a pas été compilée. Vérifiez :
- Les imports
- Les erreurs de syntaxe
- Les widgets manquants

### Erreur : "Failed to load main.dart.js"

Cela signifie que l'application n'a pas été compilée correctement. Essayez :
```powershell
flutter clean
flutter pub get
flutter build web
flutter run -d chrome
```

### Page Blanche Sans Erreur

Si la page est blanche mais il n'y a pas d'erreurs :
1. Attendez quelques secondes (la compilation peut prendre du temps)
2. Rechargez la page (F5)
3. Vérifiez que l'application est bien compilée dans le terminal

## ✅ Code Modifié

J'ai modifié `main.dart` pour éviter l'initialisation de la base de données sur le web :

```dart
// La base de données ne s'initialise plus sur le web
if (!kIsWeb) {
  // Initialiser la DB uniquement sur mobile
}
```

Cela devrait éviter les erreurs liées à sqflite sur le web.

## 🔄 Relancer l'Application

1. **Arrêtez** l'application (appuyez sur `q` dans le terminal ou fermez Chrome)
2. **Nettoyez** : `flutter clean`
3. **Réinstallez** : `flutter pub get`
4. **Relancez** : `flutter run -d chrome`

## 📝 Vérifications

- ✅ Flutter est dans le PATH
- ✅ Les dépendances sont installées (`flutter pub get` a réussi)
- ✅ Le mode développeur est activé (pour les symlinks)
- ✅ Chrome est installé et accessible

## 🎯 Si Rien Ne Fonctionne

Si après toutes ces étapes la page est toujours blanche :
1. Vérifiez la console du navigateur (F12)
2. Partagez les erreurs
3. Essayez de lancer sur **Edge** au lieu de Chrome : `flutter run -d edge`

## ✅ Alternative : Tester sur Android

Si le web pose trop de problèmes, vous pouvez directement tester sur Android où tout fonctionnera parfaitement :

```powershell
# Avec un émulateur Android
flutter run -d android
```
