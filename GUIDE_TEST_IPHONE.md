# 📱 Guide pour Tester sur iPhone

## ✅ Configuration Prête

Votre application est **déjà configurée** pour iOS :
- ✅ Permissions de localisation (`NSLocationWhenInUseUsageDescription`)
- ✅ Configuration iOS complète
- ✅ Base de données SQLite fonctionnelle
- ✅ Toutes les fonctionnalités disponibles

## 🎯 Options pour Tester sur iPhone

### Option 1 : iPhone Physique via Mac (Recommandé)

**Prérequis :**
- Mac avec Xcode installé
- iPhone avec iOS 13.0 ou supérieur
- Câble USB

**Étapes :**

1. **Connecter l'iPhone au Mac**
   ```bash
   # Connectez votre iPhone via USB
   # Sur l'iPhone : Faites confiance à cet ordinateur
   ```

2. **Configurer Xcode**
   - Ouvrez Xcode
   - Allez dans `Window > Devices and Simulators`
   - Sélectionnez votre iPhone
   - Cliquez sur `Use for Development`
   - Si nécessaire, configurez votre compte Apple Developer (gratuit)

3. **Lancer l'application**
   ```bash
   # Dans le terminal (sur Mac)
   cd /chemin/vers/projet_mobilr
   flutter devices  # Vérifier que l'iPhone est détecté
   flutter run -d <device-id>
   ```

### Option 2 : Codemagic (Recommandé si pas de Mac)

**Avantages :**
- ✅ Gratuit pour les projets open source
- ✅ Pas besoin de Mac
- ✅ Build automatique depuis GitHub
- ✅ TestFlight ou installation directe

**Étapes :**

1. **Créer un compte Codemagic**
   - Allez sur https://codemagic.io
   - Créez un compte (gratuit)

2. **Connecter votre repository**
   - Cliquez sur "Add application"
   - Sélectionnez votre repository GitHub
   - Choisissez "Flutter" comme type

3. **Configurer le workflow iOS**
   ```yaml
   # Codemagic détectera automatiquement votre projet Flutter
   # Vous devrez juste :
   # 1. Ajouter votre certificat Apple Developer (gratuit)
   # 2. Configurer le bundle identifier
   ```

4. **Lancer le build**
   - Cliquez sur "Start new build"
   - Sélectionnez la branche
   - Le build prendra 10-15 minutes

5. **Installer sur iPhone**
   - Téléchargez l'IPA généré
   - Installez via TestFlight ou directement

### Option 3 : Simulateur iOS (Sur Mac uniquement)

**Étapes :**

1. **Installer Xcode**
   ```bash
   # Téléchargez Xcode depuis l'App Store (gratuit mais volumineux ~10GB)
   ```

2. **Installer les simulateurs**
   - Ouvrez Xcode
   - Allez dans `Xcode > Settings > Platforms`
   - Téléchargez un simulateur iOS (ex: iPhone 14, iPhone 15)

3. **Lancer le simulateur**
   ```bash
   flutter devices  # Vérifier les simulateurs disponibles
   flutter run -d ios
   ```

## 🔧 Configuration Requise

### Pour iPhone Physique :
- **iOS 13.0 minimum** (votre app est configurée pour iOS 13.0+)
- **Compte Apple Developer** (gratuit pour développement)
- **Xcode** (sur Mac uniquement)

### Pour Codemagic :
- **Repository GitHub** (déjà fait ✅)
- **Compte Codemagic** (gratuit)
- **Certificat Apple Developer** (gratuit pour développement)

## 📋 Checklist Avant de Tester

- [x] Permissions de localisation configurées
- [x] Configuration iOS complète
- [x] Base de données SQLite prête
- [ ] Mac avec Xcode OU compte Codemagic
- [ ] iPhone avec iOS 13.0+
- [ ] Câble USB (pour option physique)

## 🚀 Fonctionnalités Disponibles sur iPhone

Une fois installée, l'application aura **TOUTES** les fonctionnalités :

✅ **Base de données SQLite** (fonctionne sur iOS)
✅ **Géolocalisation GPS** (avec permissions)
✅ **Relevé de polygones** (dessin sur carte)
✅ **Formulaire de saisie** (adresse, contact, type, notes)
✅ **Liste des constructions** (avec tri et filtres)
✅ **Recherche multicritères**
✅ **Export de données** (JSON)
✅ **Statistiques** (par type de construction)
✅ **Marqueurs interactifs** sur la carte
✅ **Mode sombre/clair**

## ⚠️ Notes Importantes

1. **Sur iPhone, la base de données fonctionne** (contrairement au web)
2. **La géolocalisation nécessite des permissions** (déjà configurées)
3. **Les données sont persistantes** (stockées localement sur l'iPhone)
4. **Pas besoin de connexion internet** pour utiliser l'application

## 🆘 Dépannage

### iPhone non détecté
```bash
# Vérifier la connexion
flutter devices

# Si non détecté :
# 1. Vérifiez le câble USB
# 2. Faites confiance à l'ordinateur sur l'iPhone
# 3. Déverrouillez l'iPhone
```

### Erreur de signature
```
# Sur Mac, dans Xcode :
# 1. Sélectionnez le projet Runner
# 2. Allez dans "Signing & Capabilities"
# 3. Cochez "Automatically manage signing"
# 4. Sélectionnez votre équipe Apple Developer
```

### Build échoue sur Codemagic
```
# Vérifiez :
# 1. Le bundle identifier est unique
# 2. Les certificats sont valides
# 3. Les permissions sont configurées
```

## 📞 Support

Si vous rencontrez des problèmes :
1. Vérifiez les logs dans le terminal
2. Consultez la documentation Flutter iOS
3. Vérifiez les permissions dans les réglages iPhone

---

**Recommandation :** Si vous n'avez pas de Mac, utilisez **Codemagic** (Option 2). C'est gratuit et très simple à utiliser !
