import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/construction.dart';
import '../providers/construction_provider.dart';
import '../widgets/polygon_drawer.dart';

class ConstructionFormScreen extends StatefulWidget {
  const ConstructionFormScreen({super.key});

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
          content: Text('Veuillez dessiner un polygone sur la carte'),
          backgroundColor: Colors.red,
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
    final success = await provider.addConstruction(construction);

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Construction enregistrée avec succès'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de l\'enregistrement'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau Relevé'),
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
                      Text(
                        _polygonCoordinates == null
                            ? 'Aucun polygone dessiné'
                            : '${_polygonCoordinates!.length} points définis',
                        style: TextStyle(
                          color: _polygonCoordinates == null
                              ? Colors.red
                              : Colors.green,
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
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
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
              ElevatedButton(
                onPressed: _isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
