# 🚀 Instructions Pour Lancer l'Application

## ⚠️ Important : Vous Devez Être dans le Bon Dossier

Le fichier `lancer-chrome-simple.ps1` est dans le dossier du projet.

## ✅ Solution Rapide

### Dans PowerShell, exécutez ces 2 commandes :

```powershell
cd C:\Users\Hajar\Desktop\projet_mobilr
powershell -ExecutionPolicy Bypass -File .\lancer-chrome-simple.ps1
```

**OU en une seule ligne :**

```powershell
cd C:\Users\Hajar\Desktop\projet_mobilr; powershell -ExecutionPolicy Bypass -File .\lancer-chrome-simple.ps1
```

## 📋 Étapes Détaillées

1. **Ouvrez PowerShell**
2. **Tapez** : `cd C:\Users\Hajar\Desktop\projet_mobilr`
3. **Appuyez sur Entrée**
4. **Tapez** : `powershell -ExecutionPolicy Bypass -File .\lancer-chrome-simple.ps1`
5. **Appuyez sur Entrée**
6. **Attendez 2-3 minutes**
7. **Chrome s'ouvrira automatiquement !**

## 🎯 Alternative : Commande Directe

Si vous préférez, vous pouvez aussi exécuter directement :

```powershell
cd C:\Users\Hajar\Desktop\projet_mobilr
$env:Path += ";C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter\bin"
flutter run -d chrome
```

## ⏱️ Temps d'Attente

- **Première fois** : 2-3 minutes (compilation complète)
- **Suivantes** : 30-60 secondes

## ✅ Une Fois Que Chrome S'Ouvre

1. **Connectez-vous** avec :
   - Username : `admin`
   - Password : `admin`

2. **Vous verrez la carte** avec OpenStreetMap

3. **Testez les boutons** :
   - "Nouveau Relevé" (bouton bleu en bas à droite)
   - Liste (📋) en haut à droite

## 🎉 C'est Tout !

**Exécutez simplement les 2 commandes ci-dessus et attendez !** 🚀
