import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'screens/login_screen.dart';
import 'screens/map_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/construction_provider.dart';

// Import conditionnel de la base de données
import 'database/database_helper_stub.dart' 
    if (dart.library.io) 'database/database_helper.dart' 
    as db_helper;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Sur le web, on n'initialise pas la base de données
  if (kDebugMode && kIsWeb) {
    debugPrint('Mode Web détecté - Application en mode développement (sans base de données)');
  }
  
  if (!kIsWeb) {
    // Initialiser la base de données uniquement sur mobile
    try {
      await db_helper.DatabaseHelper.instance.database;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Erreur lors de l\'initialisation de la base de données: $e');
      }
    }
  }
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ConstructionProvider()),
      ],
      child: MaterialApp(
        title: 'SIG Mobile - Relevé Cartographique',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.web: FadeUpwardsPageTransitionsBuilder(),
            },
          ),
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.web: FadeUpwardsPageTransitionsBuilder(),
            },
          ),
        ),
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return authProvider.isAuthenticated
                ? const MapScreen()
                : const LoginScreen();
          },
        ),
      ),
    );
  }
}
