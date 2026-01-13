# 🌐 Guide : Tester l'Application sur Chrome

## 🚀 Méthode Rapide (Recommandée)

### Étape 1 : Ouvrir PowerShell dans le Dossier du Projet

```powershell
cd C:\Users\Hajar\Desktop\projet_mobilr
```

### Étape 2 : Ajouter Flutter au PATH (si nécessaire)

```powershell
$env:Path += ";C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter\bin"
```

### Étape 3 : Lancer l'Application sur Chrome

```powershell
flutter run -d chrome
```

**C'est tout !** L'application va :
1. Compiler le code
2. Ouvrir Chrome automatiquement
3. Afficher l'application

---

## 📋 Étapes Détaillées

### Option 1 : Commande Simple

```powershell
# Dans le dossier du projet
$env:Path += ";C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter\bin"
flutter run -d chrome
```

### Option 2 : Script Automatique

Créez un fichier `lancer-chrome.ps1` :

```powershell
# Ajouter Flutter au PATH
$env:Path += ";C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter\bin"

# Lancer sur Chrome
flutter run -d chrome
```

Puis exécutez :
```powershell
.\lancer-chrome.ps1
```

---

## ⏱️ Temps d'Attente

- **Première fois** : 2-5 minutes (compilation complète)
- **Suivantes** : 30-60 secondes (compilation incrémentale)

---

## ✅ Ce que Vous Devriez Voir

1. **Dans le Terminal** :
   ```
   Launching lib\main.dart on Chrome in debug mode...
   Building web application...
   ```

2. **Dans Chrome** :
   - L'application s'ouvre automatiquement
   - URL : `http://localhost:XXXXX` (port aléatoire)
   - Écran de login s'affiche

---

## 🧪 Test Complet sur Chrome

### 1. **Connexion**
- Username : `admin`
- Password : `admin`
- Cliquez sur "Se connecter"

### 2. **Vérifier la Carte**
- ✅ La carte OpenStreetMap s'affiche
- ✅ Vous pouvez zoomer (molette de la souris)
- ✅ Vous pouvez déplacer la carte (clic + glisser)

### 3. **Vérifier les Boutons**
- ✅ **"Nouveau Relevé"** : Bouton bleu étendu en bas à droite
- ✅ **Liste (📋)** : Icône en haut à droite
- ✅ **Légende** : Boîte blanche en bas à gauche

### 4. **Tester le Formulaire**
- Cliquez sur "Nouveau Relevé"
- Remplissez le formulaire :
  - Adresse : "123 Rue Test, Casablanca"
  - Contact : "0612345678" (optionnel)
  - Type : Choisissez un type
  - Notes : "Test" (optionnel)
- Cliquez sur "Dessiner sur la carte"
- Cliquez 3-4 fois sur la carte pour créer un polygone
- Cliquez sur "Terminer"
- Cliquez sur "Enregistrer"

### 5. **Vérifier la Liste**
- Cliquez sur l'icône Liste (📋)
- Votre construction devrait apparaître
- Cliquez sur une construction pour voir les détails

### 6. **Tester la Recherche**
- Dans la liste, cliquez sur l'icône Recherche (🔍)
- Recherchez par adresse ou type
- Vérifiez les résultats

---

## 🔧 Commandes Utiles

### Vérifier que Chrome est Disponible

```powershell
flutter devices
```

Vous devriez voir :
```
Chrome (web) • chrome • web-javascript • Google Chrome
```

### Arrêter l'Application

Dans le terminal, appuyez sur :
- `q` : Quitter
- `Ctrl+C` : Arrêter

### Recharger l'Application (Hot Reload)

Dans le terminal, appuyez sur :
- `r` : Hot reload (recharge rapide)
- `R` : Hot restart (redémarrage complet)

### Voir les Erreurs

Si l'application ne démarre pas :
1. Regardez les erreurs dans le terminal
2. Ouvrez Chrome (F12) → Console
3. Regardez les erreurs en rouge

---

## ⚠️ Problèmes Courants

### 1. "Chrome not found"

**Solution** :
- Vérifiez que Chrome est installé
- Essayez : `flutter doctor` pour voir l'état

### 2. "Port already in use"

**Solution** :
```powershell
# Fermer tous les processus Chrome
Get-Process chrome | Stop-Process -Force

# Relancer
flutter run -d chrome
```

### 3. "Page blanche"

**Solution** :
1. Ouvrez Chrome (F12) → Console
2. Regardez les erreurs
3. Essayez :
   ```powershell
   flutter clean
   flutter pub get
   flutter run -d chrome
   ```

### 4. "Flutter not found"

**Solution** :
```powershell
# Ajouter Flutter au PATH
$env:Path += ";C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter\bin"

# Vérifier
flutter --version
```

---

## 🎯 Commandes Rapides

### Lancer sur Chrome

```powershell
$env:Path += ";C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter\bin"
flutter run -d chrome
```

### Lancer en Mode Release (Plus Rapide)

```powershell
flutter run -d chrome --release
```

### Lancer avec Port Spécifique

```powershell
flutter run -d chrome --web-port=8080
```

---

## 📝 Notes Importantes

### Mode Web (Développement)

Sur Chrome, l'application fonctionne en **mode développement** :
- ✅ Toutes les fonctionnalités UI fonctionnent
- ✅ Navigation fonctionne
- ✅ Dessin de polygones fonctionne
- ⚠️ Base de données en mémoire (données perdues au refresh)
- ⚠️ Authentification : admin/admin fonctionne

### Mode Mobile (Production)

Sur mobile (Android/iOS), l'application fonctionne en **mode production** :
- ✅ Base de données SQLite réelle (données permanentes)
- ✅ Meilleure performance
- ✅ Toutes les fonctionnalités complètes

---

## ✅ Checklist de Test

- [ ] L'application s'ouvre dans Chrome
- [ ] L'écran de login s'affiche
- [ ] Connexion avec admin/admin fonctionne
- [ ] La carte s'affiche
- [ ] Les boutons sont visibles
- [ ] Le formulaire s'ouvre
- [ ] Le dessin de polygones fonctionne
- [ ] La liste s'affiche
- [ ] La recherche fonctionne

---

## 🚀 Prêt à Tester !

**Commande à exécuter :**

```powershell
cd C:\Users\Hajar\Desktop\projet_mobilr
$env:Path += ";C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter\bin"
flutter run -d chrome
```

**Attendez 1-2 minutes et Chrome s'ouvrira automatiquement !** 🎉
