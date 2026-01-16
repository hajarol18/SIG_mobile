# 📱 Tester sur Téléphone Android via USB

## ✅ Avantages de Tester sur Android

- ✅ **SQLite réel** : Données persistées dans la vraie base de données
- ✅ **Géolocalisation réelle** : Utilise le GPS du téléphone
- ✅ **Performance** : L'application fonctionne à vitesse native
- ✅ **Toutes les fonctionnalités** : Tout fonctionne parfaitement

---

## 📋 Étapes pour Connecter votre Téléphone Android

### 1. **Activer le Mode Développeur sur Android**

1. Ouvrez **Paramètres** sur votre téléphone
2. Allez dans **À propos du téléphone** (ou **Informations sur le téléphone**)
3. Trouvez **Numéro de build** (ou **Version MIUI** sur Xiaomi)
4. **Tapez 7 fois** sur "Numéro de build" jusqu'à voir "Vous êtes maintenant développeur !"

### 2. **Activer le Débogage USB**

1. Retournez dans **Paramètres**
2. Allez dans **Options pour les développeurs** (ou **Paramètres développeur**)
3. Activez **Débogage USB** ✅
4. (Optionnel) Activez **Installer via USB** si disponible

### 3. **Connecter le Téléphone à l'Ordinateur**

1. **Branchez le câble USB** entre le téléphone et l'ordinateur
2. Sur le téléphone, choisissez **Transfert de fichiers** (MTP) ou **Débogage USB**
3. Si une alerte apparaît : **Autoriser le débogage USB** → Cochez **Toujours autoriser** → **OK**

---

## 🔍 Vérifier que Flutter Détecte votre Téléphone

### Commande à Exécuter :

```powershell
flutter devices
```

**Résultat attendu :**
```
2 connected devices:

Chrome (chrome) • chrome • web-javascript • Google Chrome
SM-G991B (mobile) • R58M30ABCDE • android-arm64 • Android 13 (API 33)
```

✅ Si vous voyez votre téléphone dans la liste, c'est **parfait** !

❌ Si vous ne voyez pas le téléphone :
- Vérifiez le câble USB
- Vérifiez que le débogage USB est activé
- Essayez un autre câble USB
- Sur Windows, installez les drivers USB Android si nécessaire

---

## 🚀 Lancer l'Application sur le Téléphone

### Option 1 : Lancement Direct

```powershell
flutter run -d android
```

Flutter choisira automatiquement votre téléphone Android.

### Option 2 : Spécifier le Device ID

```powershell
flutter run -d <device-id>
```

Remplacer `<device-id>` par l'ID de votre téléphone (ex: `R58M30ABCDE`)

---

## ⏱️ Première Installation

La **première fois**, cela prendra **5-10 minutes** car :
- ✅ Compilation de l'application Android
- ✅ Installation de l'APK sur le téléphone
- ✅ Configuration de la base de données SQLite

**Les fois suivantes**, c'est plus rapide (30 secondes - 2 minutes).

---

## 📱 Après le Lancement

### Ce que vous verrez :

1. ✅ L'application s'installe automatiquement sur votre téléphone
2. ✅ L'application s'ouvre automatiquement
3. ✅ **Page de connexion** (admin/admin)
4. ✅ **Carte interactive** avec toutes les fonctionnalités
5. ✅ **SQLite fonctionne réellement** - les données sont sauvegardées !

### Pour Recharger l'Application :

Appuyez sur **`R`** dans le terminal PowerShell pour recharger (Hot Reload)

Appuyez sur **`r`** pour Hot Restart (redémarre l'app)

---

## 🛠️ Résolution de Problèmes

### ❌ "No devices found"

**Solutions :**
1. Vérifiez que le téléphone est branché
2. Vérifiez que le débogage USB est activé
3. Débranchez et rebranchez le câble
4. Essayez un autre câble USB
5. Sur le téléphone : **Révoquer les autorisations USB** → rebranchez

### ❌ "Device unauthorized"

**Solutions :**
1. Sur le téléphone : **Autoriser le débogage USB** quand l'alerte apparaît
2. Cochez **Toujours autoriser à partir de cet ordinateur**
3. Cliquez **OK**

### ❌ L'application ne se compile pas

**Solutions :**
```powershell
flutter clean
flutter pub get
flutter run -d android
```

### ❌ Erreur "adb devices" ne montre rien

**Solutions :**
1. Installez **Android Platform Tools** si nécessaire
2. Vérifiez que le service ADB fonctionne :
   ```powershell
   adb devices
   ```

---

## ✅ Checklist Rapide

- [ ] Mode développeur activé
- [ ] Débogage USB activé
- [ ] Téléphone branché en USB
- [ ] Autorisation USB accordée sur le téléphone
- [ ] `flutter devices` montre le téléphone
- [ ] `flutter run -d android` lance l'application

---

## 🎉 Résultat Final

Une fois lancé, vous aurez :

- ✅ **Application SIG Mobile complète**
- ✅ **Base de données SQLite réelle**
- ✅ **Toutes les fonctionnalités avancées**
- ✅ **Géolocalisation GPS réelle**
- ✅ **Performances natives**

**L'application est prête pour votre projet !** 🎓
