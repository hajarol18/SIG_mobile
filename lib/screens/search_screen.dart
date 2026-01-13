import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/construction.dart';
import '../providers/construction_provider.dart';
import '../widgets/construction_card.dart';
import 'map_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _adresseController = TextEditingController();
  ConstructionType? _selectedType;
  List<Construction> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _adresseController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSearching = true;
      _hasSearched = true;
    });

    final provider = Provider.of<ConstructionProvider>(context, listen: false);
    final results = await provider.searchConstructions(
      type: _selectedType?.name,
      adresse: _adresseController.text.trim().isEmpty
          ? null
          : _adresseController.text.trim(),
    );

    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _adresseController.clear();
      _selectedType = null;
      _searchResults = [];
      _hasSearched = false;
    });
  }

  void _navigateToMapWithConstruction(Construction construction) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MapScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche Multicritères'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _adresseController,
                    decoration: const InputDecoration(
                      labelText: 'Adresse',
                      hintText: 'Rechercher par adresse...',
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<ConstructionType?>(
                    value: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Type de construction',
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(),
                    ),
                    hint: const Text('Tous les types'),
                    items: [
                      const DropdownMenuItem<ConstructionType?>(
                        value: null,
                        child: Text('Tous les types'),
                      ),
                      ...ConstructionType.values.map((type) {
                        return DropdownMenuItem<ConstructionType?>(
                          value: type,
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Color(type.colorValue),
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(type.label),
                            ],
                          ),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedType = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSearching ? null : _search,
                          child: _isSearching
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Rechercher'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_hasSearched)
                        ElevatedButton(
                          onPressed: _clearSearch,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          child: const Text('Effacer'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _hasSearched
                    ? _searchResults.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Aucun résultat trouvé',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Essayez avec d\'autres critères',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final construction = _searchResults[index];
                              return ConstructionCard(
                                construction: construction,
                                onTap: () {
                                  // Afficher les détails ou naviguer vers la carte
                                  _navigateToMapWithConstruction(construction);
                                },
                                onMapTap: () =>
                                    _navigateToMapWithConstruction(construction),
                                onDelete: null, // Pas de suppression depuis la recherche
                              );
                            },
                          )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Effectuez une recherche',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Utilisez les critères ci-dessus pour rechercher',
                              style: TextStyle(
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
