import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../providers/construction_provider.dart';
import '../providers/auth_provider.dart';
import '../models/construction.dart';
import 'construction_form_screen.dart';
import 'construction_list_screen.dart';
import 'route_screen.dart';
import 'measurement_screen.dart';
import 'proximity_search_screen.dart';

class MapScreen extends StatefulWidget {
  final int? constructionIdToFocus;
  
  const MapScreen({super.key, this.constructionIdToFocus});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng? _currentPosition;
  bool _isLoadingPosition = true;
  List<Polygon> _constructionPolygons = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadConstructions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Si une construction spécifique doit être centrée, le faire après le chargement
    if (widget.constructionIdToFocus != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusOnConstruction(widget.constructionIdToFocus!);
      });
    }
    // Mettre à jour les polygones quand les constructions changent
    final provider = Provider.of<ConstructionProvider>(context, listen: false);
    if (provider.constructions.length != _constructionPolygons.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updatePolygons();
      });
    }
  }

  void _focusOnConstruction(int constructionId) {
    final provider = Provider.of<ConstructionProvider>(context, listen: false);
    final construction = provider.constructions.firstWhere(
      (c) => c.id == constructionId,
      orElse: () => provider.constructions.isNotEmpty ? provider.constructions.first : throw StateError('No construction found'),
    );
    
    try {
      final List<dynamic> coords = jsonDecode(construction.geometry);
      if (coords.isNotEmpty) {
        // Calculer le centre du polygone
        double sumLat = 0;
        double sumLng = 0;
        for (var coord in coords) {
          sumLat += coord[1] as double;
          sumLng += coord[0] as double;
        }
        final center = LatLng(sumLat / coords.length, sumLng / coords.length);
        _mapController.move(center, 16.0);
      }
    } catch (e) {
      debugPrint('Erreur lors du centrage sur la construction: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _isLoadingPosition = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLoadingPosition = false);
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoadingPosition = false;
      });

      // Centrer la carte sur la position actuelle
      _mapController.move(_currentPosition!, 15.0);
    } catch (e) {
      setState(() => _isLoadingPosition = false);
      // Position par défaut (exemple: Casablanca, Maroc)
      _currentPosition = const LatLng(33.5731, -7.5898);
    }
  }

  Future<void> _loadConstructions() async {
    final provider = Provider.of<ConstructionProvider>(context, listen: false);
    await provider.loadConstructions();
    _updatePolygons();
  }

  void _updatePolygons() {
    final provider = Provider.of<ConstructionProvider>(context, listen: false);
    setState(() {
      _constructionPolygons = provider.constructions.map((construction) {
        try {
          final List<dynamic> coords = jsonDecode(construction.geometry);
          final List<LatLng> points = coords
              .map((coord) => LatLng(coord[1] as double, coord[0] as double))
              .toList();

          return Polygon(
            points: points,
            color: Color(construction.type.colorValue).withOpacity(0.5),
            borderColor: Color(construction.type.colorValue),
            borderStrokeWidth: 2,
            isFilled: true,
          );
        } catch (e) {
          return Polygon(
            points: [],
            color: Colors.transparent,
            borderColor: Colors.transparent,
          );
        }
      }).toList();
    });
  }

  List<Marker> _getConstructionMarkers() {
    final provider = Provider.of<ConstructionProvider>(context, listen: false);
    return provider.constructions.map((construction) {
      try {
        final List<dynamic> coords = jsonDecode(construction.geometry);
        if (coords.isEmpty) return Marker(point: const LatLng(0, 0), width: 0, height: 0, child: const SizedBox());
        
        // Calculer le centre du polygone
        double sumLat = 0;
        double sumLng = 0;
        for (var coord in coords) {
          sumLat += coord[1] as double;
          sumLng += coord[0] as double;
        }
        final center = LatLng(sumLat / coords.length, sumLng / coords.length);
        
        return Marker(
          point: center,
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () => _showConstructionInfo(construction),
            child: Container(
              decoration: BoxDecoration(
                color: Color(construction.type.colorValue),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                _getIconForType(construction.type),
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        );
      } catch (e) {
        return Marker(point: const LatLng(0, 0), width: 0, height: 0, child: const SizedBox());
      }
    }).toList();
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

  void _showConstructionInfo(Construction construction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${construction.type.label} - ${construction.adresse}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (construction.contact != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.phone, size: 18),
                      const SizedBox(width: 8),
                      Text(construction.contact!),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 8),
                    Text(DateFormat('dd/MM/yyyy à HH:mm').format(construction.dateCreation)),
                  ],
                ),
              ),
              if (construction.notes != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(construction.notes!),
                    ],
                  ),
                ),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RouteScreen(
                    construction: construction,
                    currentPosition: _currentPosition,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.navigation, size: 18),
            label: const Text('Itinéraire'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeasurementScreen(construction: construction),
                ),
              );
            },
            icon: const Icon(Icons.square_foot, size: 18),
            label: const Text('Mesures'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConstructionFormScreen(constructionToEdit: construction),
                ),
              );
            },
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Modifier'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToForm(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ConstructionFormScreen(),
      ),
    ).then((value) => value as bool?);

    if (result == true) {
      await _loadConstructions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Construction ajoutée avec succès'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _navigateToList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ConstructionListScreen(),
      ),
    );
  }

  void _logout() {
    Provider.of<AuthProvider>(context, listen: false).logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ConstructionProvider>(
          builder: (context, provider, _) {
            final total = provider.constructions.length;
            return Text('Carte des Constructions${total > 0 ? ' ($total)' : ''}');
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Plus d\'options',
            onSelected: (value) {
              if (value == 'toggle_theme') {
                // Toggle theme - sera géré par un provider ou state
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Changement de thème disponible dans les paramètres'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'toggle_theme',
                child: Row(
                  children: [
                    Icon(Icons.dark_mode, size: 20),
                    SizedBox(width: 8),
                    Text('Thème sombre'),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _navigateToList,
            tooltip: 'Liste des constructions',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: _isLoadingPosition
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Chargement de la carte...'),
                ],
              ),
            )
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentPosition ?? const LatLng(33.5731, -7.5898),
                    initialZoom: 15.0,
                    minZoom: 5.0,
                    maxZoom: 18.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.sig_mobile',
                    ),
                    PolygonLayer(
                      polygons: _constructionPolygons,
                    ),
                    // Marqueurs pour le centre de chaque construction
                    MarkerLayer(
                      markers: _getConstructionMarkers(),
                    ),
                  ],
                ),
                // Boutons flottants en bas à droite
                Positioned(
                  bottom: 80,
                  right: 20,
                  child: AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: FloatingActionButton.extended(
                      heroTag: 'add',
                      onPressed: () => _navigateToForm(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Nouveau Relevé'),
                      backgroundColor: Colors.blue,
                      elevation: 4,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                        heroTag: 'proximity',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProximitySearchScreen(),
                            ),
                          );
                        },
                        tooltip: 'Recherche par proximité',
                        backgroundColor: Colors.green,
                        child: const Icon(Icons.near_me),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton(
                        heroTag: 'location',
                        onPressed: () {
                          if (_currentPosition != null) {
                            _mapController.move(_currentPosition!, 15.0);
                          }
                        },
                        tooltip: 'Ma position',
                        child: const Icon(Icons.my_location),
                      ),
                    ],
                  ),
                ),
                // Légende améliorée en bas à gauche
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.info_outline, size: 18, color: Colors.blue),
                            SizedBox(width: 6),
                            Text(
                              'Légende',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...ConstructionType.values.map((type) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Color(type.colorValue),
                                    border: Border.all(color: Colors.black, width: 1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  type.label,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                // Ancienne légende (à supprimer si elle existe)
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Légende',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...ConstructionType.values.map((type) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Color(type.colorValue),
                                      border: Border.all(color: Colors.black),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    type.label,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      // Les FloatingActionButton sont dans le Stack (Positioned en bas à droite)
    );
  }
}
