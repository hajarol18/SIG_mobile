import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/construction.dart';
import '../providers/construction_provider.dart';
import '../widgets/polygon_drawer.dart';

class ConstructionFormScreen extends StatefulWidget {
  final Construction? constructionToEdit;
  
  const ConstructionFormScreen({super.key, this.constructionToEdit});

  @override
  State<ConstructionFormScreen> createState() => _ConstructionFormScreenState();
}

class _ConstructionFormScreenState extends State<ConstructionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _adresseController = TextEditingController();
  final _contactController = TextEditingController();
  final _notesController = TextEditingController();
  ConstructionType _selectedType = ConstructionType.residentiel;
  List<List<double>>? _polygonCoordinates;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Si on édite une construction, pré-remplir les champs
    if (widget.constructionToEdit != null) {
      final construction = widget.constructionToEdit!;
      _adresseController.text = construction.adresse;
      _contactController.text = construction.contact ?? '';
      _notesController.text = construction.notes ?? '';
      _selectedType = construction.type;
      try {
        _polygonCoordinates = (jsonDecode(construction.geometry) as List)
            .map((coord) => [coord[0] as double, coord[1] as double])
            .toList()
            .cast<List<double>>();
      } catch (e) {
        _polygonCoordinates = null;
      }
    }
  }

  @override
  void dispose() {
    _adresseController.dispose();
    _contactController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _drawPolygon() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PolygonDrawerScreen(),
      ),
    );

    if (result != null && result is List<List<double>>) {
      setState(() {
        _polygonCoordinates = result;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_polygonCoordinates == null || _polygonCoordinates!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez dessiner un polygone sur la carte en cliquant sur le bouton "Dessiner sur la carte" ci-dessus.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }
    
    if (_polygonCoordinates!.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le polygone doit contenir au moins 3 points. Veuillez dessiner un nouveau polygone.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final construction = Construction(
      adresse: _adresseController.text.trim(),
      contact: _contactController.text.trim().isEmpty
          ? null
          : _contactController.text.trim(),
      type: _selectedType,
      geometry: jsonEncode(_polygonCoordinates),
      dateCreation: DateTime.now(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    final provider = Provider.of<ConstructionProvider>(context, listen: false);
    bool success;
    
    if (widget.constructionToEdit != null) {
      // Mode édition
      final updatedConstruction = Construction(
        id: widget.constructionToEdit!.id,
        adresse: construction.adresse,
        contact: construction.contact,
        type: construction.type,
        geometry: construction.geometry,
        dateCreation: widget.constructionToEdit!.dateCreation, // Garder la date originale
        notes: construction.notes,
      );
      success = await provider.updateConstruction(updatedConstruction);
    } else {
      // Mode création
      success = await provider.addConstruction(construction);
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.constructionToEdit == null 
              ? 'Construction enregistrée avec succès' 
              : 'Construction modifiée avec succès'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de l\'enregistrement. Veuillez vérifier vos données et réessayer.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.constructionToEdit == null ? 'Nouveau Relevé' : 'Modifier Construction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dessiner le polygone',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            _polygonCoordinates == null
                                ? Icons.warning
                                : Icons.check_circle,
                            color: _polygonCoordinates == null
                                ? Colors.red
                                : Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _polygonCoordinates == null
                                  ? 'Aucun polygone dessiné'
                                  : '${_polygonCoordinates!.length} points définis${_polygonCoordinates!.length >= 3 ? " ✓" : " (minimum 3 requis)"}',
                              style: TextStyle(
                                color: _polygonCoordinates == null
                                    ? Colors.red
                                    : _polygonCoordinates!.length >= 3
                                        ? Colors.green
                                        : Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_polygonCoordinates != null && _polygonCoordinates!.length >= 3)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green[200]!),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.green[700], size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Polygone valide ! Vous pouvez enregistrer.',
                                    style: TextStyle(
                                      color: Colors.green[700],
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _drawPolygon,
                        icon: const Icon(Icons.draw),
                        label: const Text('Dessiner sur la carte'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _adresseController,
                decoration: const InputDecoration(
                  labelText: 'Adresse *',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une adresse';
                  }
                  if (value.trim().length < 5) {
                    return 'L\'adresse doit contenir au moins 5 caractères';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact (optionnel)',
                  hintText: 'Ex: 0612345678',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    // Validation basique du format téléphone (chiffres, espaces, +, -)
                    final phoneRegex = RegExp(r'^[\d\s\+\-\(\)]+$');
                    if (!phoneRegex.hasMatch(value)) {
                      return 'Format de téléphone invalide';
                    }
                    if (value.replaceAll(RegExp(r'[\s\+\-\(\)]'), '').length < 8) {
                      return 'Le numéro doit contenir au moins 8 chiffres';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ConstructionType>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type de construction *',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: ConstructionType.values.map((type) {
                  return DropdownMenuItem(
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
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedType = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                icon: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_isLoading ? 'Enregistrement...' : (widget.constructionToEdit == null ? 'Enregistrer' : 'Modifier')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
