# 📱 Tester sur iPhone depuis Windows

## ⚠️ Limitation Windows

**Sur Windows, vous NE POUVEZ PAS :**
- ❌ Compiler directement pour iOS
- ❌ Lancer un simulateur iOS
- ❌ Connecter un iPhone directement

**MAIS vous POUVEZ :**
- ✅ Tester sur Chrome (pour l'UI et les fonctionnalités)
- ✅ Utiliser Codemagic (service cloud gratuit) pour builder iOS
- ✅ Utiliser GitHub Actions pour builder iOS automatiquement

## 🎯 Solution Recommandée : Codemagic

### Pourquoi Codemagic ?
- ✅ **Gratuit** pour les projets open source
- ✅ **Pas besoin de Mac**
- ✅ **Automatique** : build depuis GitHub
- ✅ **Simple** : configuration en quelques clics
- ✅ **TestFlight** : installation facile sur iPhone

### Étapes pour Configurer Codemagic

#### 1. Créer un Compte Codemagic
1. Allez sur **https://codemagic.io**
2. Cliquez sur **"Sign up"** (gratuit)
3. Connectez avec votre compte **GitHub**

#### 2. Ajouter votre Application
1. Cliquez sur **"Add application"**
2. Sélectionnez votre repository : **`hajarol18/SIG_mobile`**
3. Choisissez **"Flutter"** comme type de projet
4. Cliquez sur **"Finish"**

#### 3. Configurer le Build iOS
1. Dans Codemagic, allez dans **"Configuration"**
2. Sélectionnez **"iOS"** comme plateforme
3. Codemagic détectera automatiquement votre projet Flutter
4. Configurez le **Bundle Identifier** (ex: `com.example.sigMobile`)

#### 4. Configurer les Certificats (Gratuit)
1. **Compte Apple Developer** (gratuit) :
   - Allez sur https://developer.apple.com
   - Créez un compte (gratuit pour développement)
   - Générez un certificat de développement

2. **Dans Codemagic** :
   - Ajoutez votre certificat Apple Developer
   - Configurez le provisioning profile
   - Codemagic guide vous pas à pas

#### 5. Lancer le Build
1. Cliquez sur **"Start new build"**
2. Sélectionnez la branche **`main`** ou **`master`**
3. Le build prendra **10-15 minutes**
4. Vous recevrez une notification quand c'est prêt

#### 6. Installer sur iPhone
1. **Option A : TestFlight** (Recommandé)
   - Téléchargez l'IPA depuis Codemagic
   - Uploadez sur TestFlight
   - Installez via l'app TestFlight sur iPhone

2. **Option B : Installation Directe**
   - Téléchargez l'IPA
   - Utilisez un outil comme **AltStore** ou **3uTools**
   - Installez directement sur iPhone

## 🚀 Alternative : GitHub Actions

Je peux créer un workflow GitHub Actions qui build automatiquement iOS à chaque push.

**Avantages :**
- ✅ Gratuit
- ✅ Automatique
- ✅ Pas besoin de service externe

**Inconvénients :**
- ⚠️ Nécessite un Mac runner (payant) OU utilise un service externe

## 💻 Tester sur Chrome (En Attendant)

En attendant de configurer Codemagic, vous pouvez tester sur Chrome :

```powershell
.\lancer-chrome-simple.ps1
```

**Fonctionnalités disponibles sur Chrome :**
- ✅ Toutes les fonctionnalités UI
- ✅ Carte interactive
- ✅ Relevé de polygones
- ✅ Formulaire de saisie
- ✅ Liste et recherche
- ⚠️ Base de données en mémoire (temporaire)

## 📋 Checklist pour iPhone depuis Windows

- [ ] Compte Codemagic créé
- [ ] Repository GitHub connecté
- [ ] Compte Apple Developer (gratuit) créé
- [ ] Certificat configuré dans Codemagic
- [ ] Build iOS lancé
- [ ] IPA téléchargé
- [ ] Installé sur iPhone

## 🆘 Besoin d'Aide ?

Je peux vous aider à :
1. ✅ Configurer Codemagic étape par étape
2. ✅ Créer un workflow GitHub Actions
3. ✅ Préparer les fichiers de configuration nécessaires

**Dites-moi ce que vous préférez et je vous guide !** 🚀
