# 🍎 Guide : Tester l'Application sur iPhone (iOS)

## ⚠️ Important : Limitations sur Windows

**iOS nécessite un Mac pour développer et tester.**

Sur Windows, vous **ne pouvez pas** :
- ❌ Compiler pour iOS
- ❌ Lancer un simulateur iOS
- ❌ Tester directement sur iPhone depuis Windows

## ✅ Options Disponibles

### Option 1 : Utiliser un Mac (Si Disponible)

Si vous avez accès à un Mac :

#### Étape 1 : Cloner le Projet sur Mac

```bash
# Sur le Mac
git clone https://github.com/hajarol18/SIG_mobile.git
cd SIG_mobile
```

#### Étape 2 : Créer le Support iOS

```bash
# Créer le dossier ios/ et la configuration
flutter create . --platforms=ios
```

#### Étape 3 : Installer Xcode

1. **Ouvrez l'App Store** sur Mac
2. **Recherchez "Xcode"**
3. **Installez Xcode** (gratuit mais volumineux ~15GB)
4. **Ouvrez Xcode** → **Preferences** → **Components**
5. **Installez un simulateur iOS** (ex: iPhone 14, iPhone 15)

#### Étape 4 : Installer CocoaPods

```bash
# Sur le Mac
sudo gem install cocoapods
cd ios
pod install
cd ..
```

#### Étape 5 : Vérifier la Configuration

```bash
flutter doctor
```

Vous devriez voir :
```
[√] Xcode - develop for iOS and macOS
[√] CocoaPods version 1.x.x
```

#### Étape 6 : Tester sur Simulateur iOS

```bash
# Lister les simulateurs disponibles
flutter emulators

# Lancer un simulateur
open -a Simulator

# OU lancer directement
flutter run
```

#### Étape 7 : Tester sur iPhone Physique

1. **Connectez votre iPhone** au Mac via USB
2. **Sur iPhone** : Faites confiance à l'ordinateur
3. **Sur Mac** : Autorisez dans Xcode (si demandé)
4. **Vérifiez** :
   ```bash
   flutter devices
   ```
   Vous devriez voir votre iPhone.

5. **Lancez** :
   ```bash
   flutter run
   ```

---

### Option 2 : Utiliser un Service Cloud (Recommandé si Pas de Mac)

#### A. Codemagic (Gratuit pour Open Source)

1. **Allez sur** : https://codemagic.io
2. **Connectez votre GitHub**
3. **Sélectionnez** votre projet `SIG_mobile`
4. **Configurez** le build iOS
5. **Lancez** le build
6. **Téléchargez** l'IPA généré

#### B. GitHub Actions (Gratuit)

Je peux créer un workflow GitHub Actions pour builder iOS automatiquement.

#### C. AppCircle / Bitrise

Services similaires qui permettent de builder iOS sans Mac.

---

### Option 3 : Tester sur Chrome/Web (Temporaire)

En attendant d'avoir un Mac ou d'utiliser un service cloud :

```powershell
flutter run -d chrome
```

**Limitations** :
- ⚠️ Base de données en mémoire (temporaire)
- ✅ Toutes les fonctionnalités UI fonctionnent
- ✅ Navigation fonctionne
- ✅ Dessin de polygones fonctionne

---

### Option 4 : Utiliser un Mac Virtuel (Avancé)

**Note** : Complexe et peut violer les conditions d'utilisation d'Apple.

1. **Installer macOS sur VirtualBox/VMware**
2. **Installer Xcode** dans la VM
3. **Suivre les étapes de l'Option 1**

⚠️ **Attention** : Cela peut être lent et peut ne pas fonctionner correctement.

---

## 🔧 Créer le Support iOS (Sur Mac)

Si vous êtes sur Mac, je peux créer la configuration iOS maintenant :

```bash
# Dans le dossier du projet
flutter create . --platforms=ios
```

Cela créera :
- `ios/` : Dossier de configuration iOS
- `ios/Podfile` : Dépendances CocoaPods
- `ios/Runner.xcworkspace` : Projet Xcode

---

## 📱 Configuration iOS Nécessaire

### Permissions dans Info.plist

Pour que la géolocalisation fonctionne sur iOS, il faut ajouter dans `ios/Runner/Info.plist` :

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Cette application a besoin de votre localisation pour afficher votre position sur la carte.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Cette application a besoin de votre localisation pour enregistrer les relevés cartographiques.</string>
```

### Configuration du Bundle ID

Dans `ios/Runner.xcodeproj/project.pbxproj`, le Bundle ID doit être unique :
```
com.example.sig_mobile
```

---

## 🚀 Build pour iOS (Sur Mac)

### Build Debug

```bash
flutter build ios --debug
```

### Build Release (Pour App Store)

```bash
flutter build ios --release
```

### Créer un IPA (Pour TestFlight)

```bash
flutter build ipa
```

---

## ✅ Ce qui Fonctionnera sur iOS

Une fois configuré sur Mac :

- ✅ **Authentification** : Login/Register
- ✅ **Carte Interactive** : OpenStreetMap
- ✅ **Géolocalisation** : Position actuelle
- ✅ **Dessin de Polygones** : Cliquez pour ajouter des points
- ✅ **Formulaire de Saisie** : Tous les champs
- ✅ **Base de Données** : SQLite fonctionne sur iOS
- ✅ **Liste des Constructions** : Affichage et navigation
- ✅ **Recherche Multicritères** : Par type et adresse
- ✅ **Symbologie** : Couleurs par type

---

## 🎯 Recommandation

### Si Vous Avez un Mac :

1. ✅ Clonez le projet sur Mac
2. ✅ Exécutez : `flutter create . --platforms=ios`
3. ✅ Installez Xcode
4. ✅ Testez sur simulateur ou iPhone

### Si Vous N'Avez Pas de Mac :

1. ✅ **Option A** : Testez sur Chrome/Web pour l'instant
2. ✅ **Option B** : Utilisez Codemagic ou GitHub Actions pour builder iOS
3. ✅ **Option C** : Trouvez quelqu'un avec un Mac pour tester

---

## 📋 Checklist iOS

- [ ] Mac disponible
- [ ] Xcode installé
- [ ] CocoaPods installé
- [ ] Support iOS créé (`flutter create . --platforms=ios`)
- [ ] Permissions configurées dans Info.plist
- [ ] Simulateur iOS ou iPhone connecté
- [ ] `flutter doctor` montre iOS configuré
- [ ] `flutter run` fonctionne

---

## 🔍 Vérifications

### Sur Mac, Vérifier iOS :

```bash
flutter doctor
```

**Résultat attendu** :
```
[√] Xcode - develop for iOS and macOS
[√] CocoaPods version 1.x.x
[√] Connected device (iPhone disponible)
```

### Lister les Simulateurs iOS :

```bash
flutter emulators
```

**Résultat attendu** :
```
2 available emulators:
  apple_ios_simulator • iPhone 14 • Apple • ios
  apple_ios_simulator • iPhone 15 • Apple • ios
```

---

## 💡 Solution Rapide : Je Peux Créer la Config iOS

Si vous avez un Mac, je peux créer la configuration iOS maintenant. Dites-moi et je créerai :

1. Le dossier `ios/`
2. La configuration Xcode
3. Le Podfile
4. Les permissions nécessaires

**Mais cela nécessite d'être sur Mac pour fonctionner.**

---

## ✅ Résumé

**Pour iOS sur Windows** :
- ❌ Impossible de compiler directement
- ✅ Possible via Mac (si disponible)
- ✅ Possible via services cloud (Codemagic, GitHub Actions)
- ✅ Possible de tester l'UI sur Chrome en attendant

**Dites-moi quelle option vous préférez et je vous aiderai !** 🚀
