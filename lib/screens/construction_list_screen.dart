import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import '../models/construction.dart';
import '../providers/construction_provider.dart';
import '../widgets/construction_card.dart';
import '../utils/pdf_export.dart';
import 'search_screen.dart';
import 'map_screen.dart';
import 'construction_form_screen.dart';
import 'statistics_screen.dart';
import '../utils/kml_export.dart';
import '../utils/gpx_export.dart';

class ConstructionListScreen extends StatefulWidget {
  const ConstructionListScreen({super.key});

  @override
  State<ConstructionListScreen> createState() => _ConstructionListScreenState();
}

class _ConstructionListScreenState extends State<ConstructionListScreen> {
  String _sortBy = 'date'; // 'date', 'adresse', 'type'
  bool _sortAscending = false;
  ConstructionType? _filterType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadConstructions();
    });
  }

  List<Construction> _getFilteredAndSortedConstructions(List<Construction> constructions) {
    var filtered = constructions;
    
    // Filtre par type
    if (_filterType != null) {
      filtered = filtered.where((c) => c.type == _filterType).toList();
    }
    
    // Tri
    filtered.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'date':
          comparison = a.dateCreation.compareTo(b.dateCreation);
          break;
        case 'adresse':
          comparison = a.adresse.compareTo(b.adresse);
          break;
        case 'type':
          comparison = a.type.label.compareTo(b.type.label);
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });
    
    return filtered;
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

  Future<void> _editConstruction(Construction construction) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConstructionFormScreen(constructionToEdit: construction),
      ),
    );

    if (result == true) {
      await _loadConstructions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Construction modifiée avec succès'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _navigateToMapWithConstruction(Construction construction) {
    if (construction.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible de localiser cette construction'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(constructionIdToFocus: construction.id),
      ),
    );
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
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _editConstruction(construction);
            },
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Modifier'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _navigateToMapWithConstruction(construction);
            },
            icon: const Icon(Icons.map, size: 18),
            label: const Text('Voir sur la carte'),
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
            content: Text('Erreur lors de la suppression. Veuillez réessayer.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ConstructionProvider>(
          builder: (context, provider, _) {
            final total = provider.constructions.length;
            return Text('Liste des Constructions${total > 0 ? ' ($total)' : ''}');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsScreen(),
                ),
              );
            },
            tooltip: 'Statistiques avancées',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Plus d\'options',
            onSelected: (value) {
              if (value == 'export') {
                _exportData(context);
              } else               if (value == 'export_pdf') {
                _exportPdf(context);
              } else if (value == 'export_kml') {
                _exportKml(context);
              } else if (value == 'export_gpx') {
                _exportGpx(context);
              } else if (value.startsWith('sort_')) {
                setState(() {
                  _sortBy = value.substring(5);
                });
              } else if (value == 'filter_clear') {
                setState(() {
                  _filterType = null;
                });
              } else if (value.startsWith('filter_')) {
                final typeName = value.substring(7);
                setState(() {
                  _filterType = ConstructionType.values.firstWhere(
                    (e) => e.name == typeName,
                    orElse: () => ConstructionType.autre,
                  );
                });
              } else if (value == 'toggle_order') {
                setState(() {
                  _sortAscending = !_sortAscending;
                });
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export_pdf',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Exporter en PDF'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export_kml',
                child: Row(
                  children: [
                    Icon(Icons.map, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Exporter en KML (Google Earth)'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export_gpx',
                child: Row(
                  children: [
                    Icon(Icons.explore, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Exporter en GPX (GPS)'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download, size: 20),
                    SizedBox(width: 8),
                    Text('Exporter les données'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'sort_header',
                enabled: false,
                child: Text('Trier par:', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              PopupMenuItem(
                value: 'sort_date',
                child: Row(
                  children: [
                    Icon(_sortBy == 'date' ? Icons.check : null, size: 18),
                    const SizedBox(width: 8),
                    const Text('Date'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'sort_adresse',
                child: Row(
                  children: [
                    Icon(_sortBy == 'adresse' ? Icons.check : null, size: 18),
                    const SizedBox(width: 8),
                    const Text('Adresse'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'sort_type',
                child: Row(
                  children: [
                    Icon(_sortBy == 'type' ? Icons.check : null, size: 18),
                    const SizedBox(width: 8),
                    const Text('Type'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'toggle_order',
                child: Row(
                  children: [
                    Icon(_sortAscending ? Icons.arrow_upward : Icons.arrow_downward, size: 18),
                    const SizedBox(width: 8),
                    Text(_sortAscending ? 'Croissant' : 'Décroissant'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'filter_header',
                enabled: false,
                child: Text('Filtrer par type:', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ...ConstructionType.values.map((type) => PopupMenuItem(
                value: 'filter_${type.name}',
                child: Row(
                  children: [
                    Icon(_filterType == type ? Icons.check : null, size: 18),
                    const SizedBox(width: 8),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Color(type.colorValue),
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(type.label),
                  ],
                ),
              )),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'filter_clear',
                child: Row(
                  children: [
                    Icon(Icons.clear, size: 18),
                    SizedBox(width: 8),
                    Text('Effacer le filtre'),
                  ],
                ),
              ),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            tooltip: 'Trier et filtrer',
            onSelected: (value) {
              setState(() {
                if (value == 'toggle_order') {
                  _sortAscending = !_sortAscending;
                } else if (value.startsWith('sort_')) {
                  _sortBy = value.substring(5);
                } else if (value == 'filter_clear') {
                  _filterType = null;
                } else if (value.startsWith('filter_')) {
                  final typeName = value.substring(7);
                  _filterType = ConstructionType.values.firstWhere(
                    (e) => e.name == typeName,
                    orElse: () => ConstructionType.autre,
                  );
                }
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'sort_header',
                enabled: false,
                child: Text('Trier par:', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              PopupMenuItem(
                value: 'sort_date',
                child: Row(
                  children: [
                    Icon(_sortBy == 'date' ? Icons.check : null, size: 18),
                    const SizedBox(width: 8),
                    const Text('Date'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'sort_adresse',
                child: Row(
                  children: [
                    Icon(_sortBy == 'adresse' ? Icons.check : null, size: 18),
                    const SizedBox(width: 8),
                    const Text('Adresse'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'sort_type',
                child: Row(
                  children: [
                    Icon(_sortBy == 'type' ? Icons.check : null, size: 18),
                    const SizedBox(width: 8),
                    const Text('Type'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'toggle_order',
                child: Row(
                  children: [
                    Icon(_sortAscending ? Icons.arrow_upward : Icons.arrow_downward, size: 18),
                    const SizedBox(width: 8),
                    Text(_sortAscending ? 'Croissant' : 'Décroissant'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'filter_header',
                enabled: false,
                child: Text('Filtrer par type:', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ...ConstructionType.values.map((type) => PopupMenuItem(
                value: 'filter_${type.name}',
                child: Row(
                  children: [
                    Icon(_filterType == type ? Icons.check : null, size: 18),
                    const SizedBox(width: 8),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Color(type.colorValue),
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(type.label),
                  ],
                ),
              )),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'filter_clear',
                child: Row(
                  children: [
                    Icon(Icons.clear, size: 18),
                    SizedBox(width: 8),
                    Text('Effacer le filtre'),
                  ],
                ),
              ),
            ],
          ),
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
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Chargement des constructions...'),
                ],
              ),
            );
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

          // Statistiques par type
          final stats = <ConstructionType, int>{};
          for (var construction in provider.constructions) {
            stats[construction.type] = (stats[construction.type] ?? 0) + 1;
          }

          // Constructions filtrées et triées
          final filteredConstructions = _getFilteredAndSortedConstructions(provider.constructions);

          return RefreshIndicator(
            onRefresh: _loadConstructions,
            child: Column(
              children: [
                // Statistiques améliorées
                if (stats.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[50]!, Colors.blue[100]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[300]!, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue[200]!.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.analytics, color: Colors.blue[700], size: 24),
                            const SizedBox(width: 8),
                            const Text(
                              'Statistiques',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue[700],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Total: ${provider.constructions.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: stats.entries.map((entry) {
                            final percentage = (entry.value / provider.constructions.length * 100).toStringAsFixed(1);
                            return Chip(
                              avatar: CircleAvatar(
                                backgroundColor: Color(entry.key.colorValue).withOpacity(0.3),
                                child: Icon(
                                  _getIconForType(entry.key),
                                  size: 18,
                                  color: Color(entry.key.colorValue),
                                ),
                              ),
                              label: Text('${entry.key.label}: ${entry.value} ($percentage%)'),
                              backgroundColor: Color(entry.key.colorValue).withOpacity(0.15),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                // Indicateur de filtre actif amélioré
                if (_filterType != null)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange[50]!, Colors.orange[100]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.orange[300]!, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange[200]!.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.orange[700],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.filter_alt, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Filtre actif',
                                style: TextStyle(
                                  color: Colors.orange[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                _filterType!.label,
                                style: TextStyle(
                                  color: Colors.orange[700],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _filterType = null;
                            });
                          },
                          icon: const Icon(Icons.close, size: 20),
                          color: Colors.orange[700],
                          tooltip: 'Effacer le filtre',
                        ),
                      ],
                    ),
                  ),
                // Liste des constructions
                Expanded(
                  child: filteredConstructions.isEmpty && _filterType != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.filter_alt_off, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'Aucune construction de type "${_filterType!.label}"',
                                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _filterType = null;
                                  });
                                },
                                child: const Text('Effacer le filtre'),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: filteredConstructions.length,
                          itemBuilder: (context, index) {
                            final construction = filteredConstructions[index];
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              child: ConstructionCard(
                                construction: construction,
                                onTap: () => _showConstructionDetails(construction),
                                onMapTap: () => _navigateToMapWithConstruction(construction),
                                onEdit: () => _editConstruction(construction),
                                onDelete: () => _deleteConstruction(construction),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getIconForType(ConstructionType type) {
    switch (type) {
      case ConstructionType.residentiel:
        return Icons.home;
      case ConstructionType.commercial:
        return Icons.store;
      case ConstructionType.industriel:
        return Icons.factory;
      case ConstructionType.administratif:
        return Icons.business;
      case ConstructionType.educatif:
        return Icons.school;
      case ConstructionType.sanitaire:
        return Icons.local_hospital;
      case ConstructionType.autre:
        return Icons.location_city;
    }
  }

  Future<void> _exportData(BuildContext context) async {
    final provider = Provider.of<ConstructionProvider>(context, listen: false);
    if (provider.constructions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune donnée à exporter'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      // Créer un JSON avec toutes les constructions
      final exportData = {
        'export_date': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        'total_constructions': provider.constructions.length,
        'constructions': provider.constructions.map((c) => {
          'id': c.id,
          'adresse': c.adresse,
          'contact': c.contact,
          'type': c.type.name,
          'type_label': c.type.label,
          'geometry': c.geometry,
          'date_creation': DateFormat('yyyy-MM-dd HH:mm:ss').format(c.dateCreation),
          'notes': c.notes,
        }).toList(),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);
      
      // Afficher le JSON dans un dialog
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.download, color: Colors.blue),
                SizedBox(width: 8),
                Text('Export des données'),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: SelectableText(
                  jsonString,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fermer'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Copier dans le presse-papier
                  // Note: Sur web, on peut utiliser Clipboard.setData
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Copiez le texte ci-dessus pour sauvegarder les données'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copier'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'export: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _exportPdf(BuildContext context) async {
    final provider = Provider.of<ConstructionProvider>(context, listen: false);
    if (provider.constructions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune donnée à exporter'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      if (context.mounted) {
        // Afficher un indicateur de chargement
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Générer le PDF
        final pdf = await PdfExport.generateReport(
          constructions: provider.constructions,
          title: 'Rapport des Constructions',
        );

        // Fermer le dialog de chargement
        if (context.mounted) {
          Navigator.pop(context);
        }

        // Afficher le PDF
        if (context.mounted) {
          await Printing.layoutPdf(
            onLayout: (PdfPageFormat format) async => pdf.save(),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        // Fermer le dialog de chargement s'il est ouvert
        Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'export PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _exportKml(BuildContext context) async {
    final provider = Provider.of<ConstructionProvider>(context, listen: false);
    if (provider.constructions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune donnée à exporter'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final kmlContent = KmlExport.exportToKml(
        provider.constructions,
        name: 'Constructions SIG Mobile',
      );

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.map, color: Colors.green),
                SizedBox(width: 8),
                Text('Export KML'),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: SelectableText(
                  kmlContent,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 10),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fermer'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Copier dans le presse-papier
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Copiez le contenu KML ci-dessus pour sauvegarder'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copier'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'export KML: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _exportGpx(BuildContext context) async {
    final provider = Provider.of<ConstructionProvider>(context, listen: false);
    if (provider.constructions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune donnée à exporter'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final gpxContent = GpxExport.exportToGpx(
        provider.constructions,
        name: 'Constructions SIG Mobile',
      );

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.explore, color: Colors.blue),
                SizedBox(width: 8),
                Text('Export GPX'),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: SelectableText(
                  gpxContent,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 10),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fermer'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Copier dans le presse-papier
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Copiez le contenu GPX ci-dessus pour sauvegarder'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copier'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'export GPX: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
