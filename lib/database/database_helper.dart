import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/construction.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sig_mobile.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Table des utilisateurs
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Table des constructions
    await db.execute('''
      CREATE TABLE constructions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        adresse TEXT NOT NULL,
        contact TEXT,
        type TEXT NOT NULL,
        geometry TEXT NOT NULL,
        date_creation TEXT NOT NULL,
        notes TEXT
      )
    ''');

    // Insérer un utilisateur par défaut (admin/admin)
    await db.insert('users', User(
      username: 'admin',
      password: 'admin', // En production, utiliser un hash
    ).toMap());
  }

  // Méthodes pour les utilisateurs
  Future<User?> authenticateUser(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isEmpty) return null;
    return User.fromMap(result.first);
  }

  Future<User?> createUser(String username, String password) async {
    final db = await database;
    try {
      final id = await db.insert('users', User(
        username: username,
        password: password,
      ).toMap());
      return User(id: id, username: username, password: password);
    } catch (e) {
      return null; // Utilisateur existe déjà
    }
  }

  // Méthodes pour les constructions
  Future<int> insertConstruction(Construction construction) async {
    final db = await database;
    return await db.insert('constructions', construction.toMap());
  }

  Future<List<Construction>> getAllConstructions() async {
    final db = await database;
    final result = await db.query('constructions', orderBy: 'date_creation DESC');
    return result.map((map) => Construction.fromMap(map)).toList();
  }

  Future<List<Construction>> searchConstructions({
    String? type,
    String? adresse,
  }) async {
    final db = await database;
    String whereClause = '1=1';
    List<dynamic> whereArgs = [];

    if (type != null && type.isNotEmpty) {
      whereClause += ' AND type = ?';
      whereArgs.add(type);
    }

    if (adresse != null && adresse.isNotEmpty) {
      whereClause += ' AND adresse LIKE ?';
      whereArgs.add('%$adresse%');
    }

    final result = await db.query(
      'constructions',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'date_creation DESC',
    );

    return result.map((map) => Construction.fromMap(map)).toList();
  }

  Future<Construction?> getConstructionById(int id) async {
    final db = await database;
    final result = await db.query(
      'constructions',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) return null;
    return Construction.fromMap(result.first);
  }

  Future<int> updateConstruction(Construction construction) async {
    final db = await database;
    return await db.update(
      'constructions',
      construction.toMap(),
      where: 'id = ?',
      whereArgs: [construction.id],
    );
  }

  Future<int> deleteConstruction(int id) async {
    final db = await database;
    return await db.delete(
      'constructions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
