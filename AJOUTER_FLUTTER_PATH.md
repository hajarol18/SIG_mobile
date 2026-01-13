# Comment Ajouter Flutter au PATH Permanemment

## 🎯 Situation Actuelle

Flutter est actuellement installé dans :
```
C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter
```

Flutter fonctionne dans votre session actuelle, mais pour l'utiliser dans n'importe quel terminal, vous devez l'ajouter au PATH de manière permanente.

## ✅ Méthode 1 : Via l'Interface Windows (Recommandé)

### Étape 1 : Ouvrir les Variables d'Environnement

1. Appuyez sur **`Windows + R`**
2. Tapez : **`sysdm.cpl`**
3. Appuyez sur **Entrée**

### Étape 2 : Accéder aux Variables d'Environnement

1. Cliquez sur l'onglet **"Avancé"** (Advanced)
2. Cliquez sur le bouton **"Variables d'environnement"** (Environment Variables)

### Étape 3 : Modifier le PATH Système

1. Dans la section **"Variables système"** (System variables), cherchez **"Path"**
2. Sélectionnez **"Path"** puis cliquez sur **"Modifier"** (Edit)

### Étape 4 : Ajouter Flutter

1. Cliquez sur **"Nouveau"** (New)
2. Ajoutez exactement ce chemin :
   ```
   C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter\bin
   ```
3. Cliquez sur **"OK"** pour fermer cette fenêtre
4. Cliquez sur **"OK"** pour fermer la fenêtre des Variables d'environnement
5. Cliquez sur **"OK"** pour fermer la fenêtre Propriétés système

### Étape 5 : Redémarrer le Terminal

**IMPORTANT** : Fermez tous vos terminaux PowerShell/CMD et rouvrez-en un nouveau pour que les changements prennent effet.

### Étape 6 : Vérifier

Dans un nouveau terminal, tapez :
```powershell
flutter --version
```

Si cela fonctionne, Flutter est maintenant dans le PATH de manière permanente ! ✅

## ✅ Méthode 2 : Via PowerShell (En tant qu'Administrateur)

Si vous préférez utiliser la ligne de commande :

1. **Ouvrez PowerShell EN TANT QU'ADMINISTRATEUR**
   - Clic droit sur PowerShell → "Exécuter en tant qu'administrateur"

2. Exécutez cette commande :
   ```powershell
   [Environment]::SetEnvironmentVariable("Path", [Environment]::GetEnvironmentVariable("Path", "Machine") + ";C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter\bin", "Machine")
   ```

3. **Redémarrez votre terminal**

4. Vérifiez :
   ```powershell
   flutter --version
   ```

## 🔍 Comment Vérifier que Flutter est dans le PATH

Dans un nouveau terminal PowerShell :
```powershell
where.exe flutter
```

Vous devriez voir :
```
C:\Users\Hajar\Downloads\flutter_windows_3.38.6-stable\flutter\bin\flutter.bat
```

## ⚠️ Si Vous Avez Choisi de Déplacer Flutter Vers C:\src\flutter

Si vous souhaitez déplacer Flutter vers `C:\src\flutter` (recommandé) :

1. Exécutez à nouveau le script :
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\setup-flutter.ps1
   ```

2. Cette fois, répondez **`O`** (Oui) quand on vous demande de déplacer

3. Le chemin à ajouter au PATH sera alors :
   ```
   C:\src\flutter\bin
   ```

## 📝 Prochaines Étapes Après Ajout au PATH

Une fois Flutter ajouté au PATH :

```powershell
# Vérifier Flutter
flutter --version

# Vérifier la configuration
flutter doctor

# Vérifier le projet
cd C:\Users\Hajar\Desktop\projet_mobilr
flutter pub get

# Lancer l'application (nécessite un appareil/émulateur)
flutter run
```

## 🎉 C'est Tout !

Une fois Flutter ajouté au PATH, vous pouvez utiliser `flutter` depuis n'importe quel terminal sans avoir à spécifier le chemin complet.
