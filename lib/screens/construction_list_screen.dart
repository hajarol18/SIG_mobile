import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/construction.dart';
import '../providers/construction_provider.dart';
import '../widgets/construction_card.dart';
import 'search_screen.dart';
import 'map_screen.dart';

class ConstructionListScreen extends StatefulWidget {
  const ConstructionListScreen({super.key});

  @override
  State<ConstructionListScreen> createState() => _ConstructionListScreenState();
}

class _ConstructionListScreenState extends State<ConstructionListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadConstructions();
    });
  }

  Future<void> _loadConstructions() async {
    final provider = Provider.of<ConstructionProvider>(context, listen: false);
    await provider.loadConstructions();
  }

  Future<void> _navigateToSearch() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      ),
    );

    if (result == true) {
      _loadConstructions();
    }
  }

  void _navigateToMapWithConstruction(Construction construction) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MapScreen(),
      ),
    );
    // Note: Pour centrer la carte sur la construction, on peut passer
    // l'ID de la construction comme paramètre et gérer la navigation
    // dans MapScreen. Pour simplifier, on revient juste à la carte.
  }

  Future<void> _showConstructionDetails(Construction construction) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Construction #${construction.id}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Adresse', construction.adresse),
              if (construction.contact != null)
                _buildDetailRow('Contact', construction.contact!),
              _buildDetailRow(
                'Type',
                construction.type.label,
                color: Color(construction.type.colorValue),
              ),
              _buildDetailRow(
                'Date',
                DateFormat('dd/MM/yyyy à HH:mm').format(construction.dateCreation),
              ),
              if (construction.notes != null)
                _buildDetailRow('Notes', construction.notes!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToMapWithConstruction(construction);
            },
            child: const Text('Voir sur la carte'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: color != null
                ? Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: color,
                          border: Border.all(color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(value),
                    ],
                  )
                : Text(value),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteConstruction(Construction construction) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer cette construction ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final provider =
          Provider.of<ConstructionProvider>(context, listen: false);
      final success = await provider.deleteConstruction(construction.id!);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Construction supprimée avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la suppression'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Constructions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _navigateToSearch,
            tooltip: 'Recherche',
          ),
        ],
      ),
      body: Consumer<ConstructionProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.constructions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune construction enregistrée',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Commencez par faire un relevé cartographique',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadConstructions,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: provider.constructions.length,
              itemBuilder: (context, index) {
                final construction = provider.constructions[index];
                return ConstructionCard(
                  construction: construction,
                  onTap: () => _showConstructionDetails(construction),
                  onMapTap: () => _navigateToMapWithConstruction(construction),
                  onDelete: () => _deleteConstruction(construction),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
