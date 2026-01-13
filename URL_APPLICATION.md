# 🌐 URL de l'Application

## 🎯 URL à Ouvrir dans Chrome

L'application Flutter utilise généralement l'un de ces ports :

### Ports Communs :
- **http://localhost:8080**
- **http://localhost:8090**
- **http://localhost:8100**
- **http://localhost:8200**
- **http://localhost:8300**

## 📋 Comment Trouver le Bon Port

### Méthode 1 : Regarder dans le Terminal

Quand vous lancez `flutter run -d chrome`, vous verrez dans le terminal :

```
Launching lib\main.dart on Chrome in debug mode...
Building web application...
Flutter run key commands.
...
Flutter DevTools: http://localhost:XXXXX
```

**Le port est dans cette ligne !**

### Méthode 2 : Ouvrir Chrome Automatiquement

Normalement, Chrome s'ouvre **automatiquement** avec la bonne URL.

### Méthode 3 : Essayer les Ports Communs

Si Chrome ne s'ouvre pas automatiquement, essayez ces URLs une par une :

1. **http://localhost:8080**
2. **http://localhost:8090**
3. **http://localhost:8100**
4. **http://localhost:8200**
5. **http://localhost:8300**

## ✅ Une Fois Que Vous Trouvez l'URL

1. **Ouvrez Chrome**
2. **Collez l'URL** dans la barre d'adresse
3. **Appuyez sur Entrée**
4. **L'application s'affiche !**

## 🔍 Vérifier le Port Utilisé

Dans PowerShell, exécutez :

```powershell
netstat -ano | Select-String -Pattern "LISTENING" | Select-String -Pattern "127.0.0.1"
```

Vous verrez tous les ports utilisés. Cherchez un port entre 8080 et 9000.

## 🎯 Solution Rapide

**Essayez simplement :**
1. Ouvrez Chrome
2. Tapez : `http://localhost:8080`
3. Si ça ne marche pas, essayez : `http://localhost:8090`
4. Continuez jusqu'à trouver le bon port !

**L'application devrait s'afficher !** 🚀
