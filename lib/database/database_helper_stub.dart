// Stub file pour le web - remplace database_helper.dart sur le web
// Ce fichier évite l'import de sqflite sur le web

import '../models/user.dart';
import '../models/construction.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  
  DatabaseHelper._init();
  
  // Sur le web, ces méthodes ne font rien
  Future<dynamic> get database async => throw UnimplementedError('Database not available on web');
  
  Future<User?> authenticateUser(String username, String password) async {
    throw UnimplementedError('Database not available on web');
  }
  
  Future<User?> createUser(String username, String password) async {
    throw UnimplementedError('Database not available on web');
  }
  
  Future<int> insertConstruction(Construction construction) async {
    throw UnimplementedError('Database not available on web');
  }
  
  Future<List<Construction>> getAllConstructions() async {
    throw UnimplementedError('Database not available on web');
  }
  
  Future<List<Construction>> searchConstructions({String? type, String? adresse}) async {
    throw UnimplementedError('Database not available on web');
  }
  
  Future<Construction?> getConstructionById(int id) async {
    throw UnimplementedError('Database not available on web');
  }
  
  Future<int> updateConstruction(Construction construction) async {
    throw UnimplementedError('Database not available on web');
  }
  
  Future<int> deleteConstruction(int id) async {
    throw UnimplementedError('Database not available on web');
  }
  
  Future<void> close() async {
    // Nothing to close on web
  }
}
