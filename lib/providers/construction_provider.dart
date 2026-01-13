import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/construction.dart';

class ConstructionProvider with ChangeNotifier {
  List<Construction> _constructions = [];
  bool _isLoading = false;

  List<Construction> get constructions => _constructions;
  bool get isLoading => _isLoading;

  Future<void> loadConstructions() async {
    _isLoading = true;
    notifyListeners();

    try {
      _constructions = await DatabaseHelper.instance.getAllConstructions();
    } catch (e) {
      debugPrint('Erreur lors du chargement des constructions: $e');
      // Mode développement web : initialiser une liste vide
      _constructions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addConstruction(Construction construction) async {
    try {
      final id = await DatabaseHelper.instance.insertConstruction(construction);
      if (id > 0) {
        await loadConstructions();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Erreur lors de l\'ajout de la construction: $e');
      // Mode développement web : ajouter en mémoire seulement
      final newId = _constructions.isEmpty ? 1 : (_constructions.map((c) => c.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
      _constructions.insert(0, Construction(
        id: newId,
        adresse: construction.adresse,
        contact: construction.contact,
        type: construction.type,
        geometry: construction.geometry,
        dateCreation: construction.dateCreation,
        notes: construction.notes,
      ));
      notifyListeners();
      return true;
    }
  }

  Future<bool> updateConstruction(Construction construction) async {
    try {
      final rowsAffected =
          await DatabaseHelper.instance.updateConstruction(construction);
      if (rowsAffected > 0) {
        await loadConstructions();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour de la construction: $e');
      return false;
    }
  }

  Future<bool> deleteConstruction(int id) async {
    try {
      final rowsAffected =
          await DatabaseHelper.instance.deleteConstruction(id);
      if (rowsAffected > 0) {
        await loadConstructions();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Erreur lors de la suppression de la construction: $e');
      return false;
    }
  }

  Future<List<Construction>> searchConstructions({
    String? type,
    String? adresse,
  }) async {
    try {
      return await DatabaseHelper.instance.searchConstructions(
        type: type,
        adresse: adresse,
      );
    } catch (e) {
      debugPrint('Erreur lors de la recherche: $e');
      return [];
    }
  }
}
