import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/construction.dart';
import '../providers/construction_provider.dart';
import '../utils/route_calculator.dart';
import 'map_screen.dart';

/// Écran de recherche par proximité géographique
class ProximitySearchScreen extends StatefulWidget {
  const ProximitySearchScreen({super.key});

  @override
  State<ProximitySearchScreen> createState() => _ProximitySearchScreenState();
}

class _ProximitySearchScreenState extends State<ProximitySearchScreen> {
  LatLng? _currentPosition;
  bool _isLoadingPosition = true;
  double _searchRadius = 5.0; // en kilomètres
  List<ConstructionWithDistance> _nearbyConstructions = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoadingPosition = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Service de localisation désactivé'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoadingPosition = false;
      });

      _searchNearby();
    } catch (e) {
      setState(() {
        _isLoadingPosition = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de localisation: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _searchNearby() {
    if (_currentPosition == null) return;

    setState(() {
      _isSearching = true;
    });

    final provider = Provider.of<ConstructionProvider>(context, listen: false);
    final allConstructions = provider.constructions;
    final List<ConstructionWithDistance> nearby = [];

    for (var construction in allConstructions) {
      try {
        final List<dynamic> coords = jsonDecode(construction.geometry);
        if (coords.isEmpty) continue;

        // Calculer le centre du polygone
        double sumLat = 0;
        double sumLng = 0;
        for (var coord in coords) {
          sumLat += coord[1] as double;
          sumLng += coord[0] as double;
        }
        final center = LatLng(sumLat / coords.length, sumLng / coords.length);

        // Calculer la distance
        final distance = RouteCalculator.calculateDistanceKm(
          _currentPosition!,
          center,
        );

        if (distance <= _searchRadius) {
          nearby.add(ConstructionWithDistance(
            construction: construction,
            distance: distance,
            center: center,
          ));
        }
      } catch (e) {
        // Ignorer les erreurs de parsing
      }
    }

    // Trier par distance
    nearby.sort((a, b) => a.distance.compareTo(b.distance));

    setState(() {
      _nearbyConstructions = nearby;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche par Proximité'),
      ),
      body: _isLoadingPosition
          ? const Center(child: CircularProgressIndicator())
          : _currentPosition == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_off, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Position actuelle non disponible',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _getCurrentLocation,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Contrôles de recherche
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.my_location, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Rayon de recherche: ${_searchRadius.toStringAsFixed(1)} km',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Slider(
                            value: _searchRadius,
                            min: 0.5,
                            max: 50.0,
                            divisions: 99,
                            label: '${_searchRadius.toStringAsFixed(1)} km',
                            onChanged: (value) {
                              setState(() {
                                _searchRadius = value;
                              });
                              _searchNearby();
                            },
                          ),
                          ElevatedButton.icon(
                            onPressed: _searchNearby,
                            icon: _isSearching
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.search),
                            label: Text(_isSearching ? 'Recherche...' : 'Rechercher'),
                          ),
                        ],
                      ),
                    ),

                    // Résultats
                    Expanded(
                      child: _isSearching
                          ? const Center(child: CircularProgressIndicator())
                          : _nearbyConstructions.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.search_off, size: 64, color: Colors.grey),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Aucune construction trouvée\n dans un rayon de ${_searchRadius.toStringAsFixed(1)} km',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(8),
                                  itemCount: _nearbyConstructions.length,
                                  itemBuilder: (context, index) {
                                    final item = _nearbyConstructions[index];
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Color(item.construction.type.colorValue).withOpacity(0.2),
                                          child: Icon(
                                            _getIconForType(item.construction.type),
                                            color: Color(item.construction.type.colorValue),
                                          ),
                                        ),
                                        title: Text(item.construction.adresse),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.construction.type.label,
                                              style: TextStyle(
                                                color: Color(item.construction.type.colorValue),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(Icons.straighten, size: 16, color: Colors.blue),
                                                const SizedBox(width: 4),
                                                Text(
                                                  RouteCalculator.formatDistance(item.distance * 1000),
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MapScreen(
                                                constructionIdToFocus: item.construction.id,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                    ),
                  ],
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
}

class ConstructionWithDistance {
  final Construction construction;
  final double distance; // en kilomètres
  final LatLng center;

  ConstructionWithDistance({
    required this.construction,
    required this.distance,
    required this.center,
  });
}
