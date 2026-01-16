# 🚀 Configuration Codemagic pour iOS

## ✅ État Actuel

Vous avez déjà :
- ✅ Compte Codemagic créé
- ✅ Repository GitHub connecté (`hajarol18/SIG_mobile`)
- ✅ Workflow configuré avec **Android** et **iOS** activés
- ✅ Prêt à lancer le build

## 📋 Configuration iOS Nécessaire

### 1. Bundle Identifier
Votre app utilise : `com.example.sigMobile`

**Important :** Pour publier sur TestFlight, vous devrez peut-être changer ce bundle ID pour quelque chose d'unique comme :
- `com.hajarol18.sigmobile`
- `com.votrenom.sigmobile`

### 2. Certificats Apple Developer

#### Option A : Compte Apple Developer Gratuit (Recommandé)
1. Allez sur https://developer.apple.com
2. Créez un compte (gratuit pour développement)
3. Générez un certificat de développement
4. Ajoutez-le dans Codemagic

#### Option B : Codemagic Gère Automatiquement
- Codemagic peut générer les certificats automatiquement
- Vous devrez juste connecter votre compte Apple Developer

### 3. Configuration dans Codemagic

Dans l'onglet **"Workflow Editor"** :

1. **Vérifiez que iOS est coché** ✅ (déjà fait)

2. **Cliquez sur "Switch to YAML configuration"** pour plus de contrôle

3. **Ou configurez dans l'interface** :
   - Bundle Identifier : `com.example.sigMobile` (ou un ID unique)
   - Version : `1.0.0`
   - Build number : `1`

## 🚀 Lancer le Build

### Étapes :

1. **Cliquez sur "Start your first build"** (bouton bleu en haut)

2. **Sélectionnez la branche** :
   - `main` ou `master` (selon votre repository)

3. **Codemagic va** :
   - Cloner votre repository
   - Installer les dépendances Flutter
   - Builder Android et iOS
   - Générer les fichiers APK (Android) et IPA (iOS)

4. **Temps d'attente** : 10-15 minutes

## 📱 Installer sur iPhone

### Option 1 : TestFlight (Recommandé)

1. **Téléchargez l'IPA** depuis Codemagic
2. **Uploadez sur App Store Connect** :
   - Allez sur https://appstoreconnect.apple.com
   - Créez une nouvelle app
   - Uploadez l'IPA via Transporter ou Xcode
3. **Ajoutez à TestFlight**
4. **Installez via l'app TestFlight** sur iPhone

### Option 2 : Installation Directe

1. **Téléchargez l'IPA** depuis Codemagic
2. **Utilisez AltStore** ou **3uTools** :
   - Installez AltStore sur votre ordinateur
   - Connectez votre iPhone
   - Installez l'IPA via AltStore

## ⚙️ Configuration YAML (Optionnel)

Si vous voulez plus de contrôle, vous pouvez utiliser un fichier YAML :

```yaml
workflows:
  ios-workflow:
    name: iOS Workflow
    max_build_duration: 60
    instance_type: mac_mini_m1
    environment:
      groups:
        - app_store_credentials
      flutter: stable
      xcode: latest
      cocoapods: default
    scripts:
      - name: Get dependencies
        script: |
          flutter pub get
      - name: Build iOS
        script: |
          flutter build ipa --release
    artifacts:
      - build/ios/ipa/*.ipa
```

## 🔧 Dépannage

### Erreur de certificat
- Vérifiez que votre compte Apple Developer est connecté
- Générez un nouveau certificat si nécessaire

### Erreur de bundle ID
- Changez le bundle ID pour quelque chose d'unique
- Mettez à jour dans `ios/Runner.xcodeproj/project.pbxproj`

### Build échoue
- Vérifiez les logs dans Codemagic
- Assurez-vous que toutes les dépendances sont correctes
- Vérifiez que `pubspec.yaml` est valide

## ✅ Checklist

- [x] Compte Codemagic créé
- [x] Repository connecté
- [x] iOS activé dans le workflow
- [ ] Certificat Apple Developer configuré
- [ ] Bundle ID vérifié
- [ ] Build lancé
- [ ] IPA téléchargé
- [ ] Installé sur iPhone

## 🎯 Prochaines Étapes

1. **Cliquez sur "Start your first build"** maintenant
2. **Attendez 10-15 minutes**
3. **Téléchargez l'IPA** quand c'est prêt
4. **Installez sur iPhone**

**Tout est prêt ! Lancez le build !** 🚀
