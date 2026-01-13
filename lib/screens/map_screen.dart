import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/construction_provider.dart';
import '../providers/auth_provider.dart';
import '../models/construction.dart';
import 'construction_form_screen.dart';
import 'construction_list_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

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

  Future<void> _navigateToForm(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ConstructionFormScreen(),
      ),
    );

    if (result == true) {
      await _loadConstructions();
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
        title: const Text('Carte des Constructions'),
        actions: [
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
          ? const Center(child: CircularProgressIndicator())
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
                  ],
                ),
                // Boutons flottants en bas à droite
                Positioned(
                  bottom: 80,
                  right: 20,
                  child: FloatingActionButton.extended(
                    heroTag: 'add',
                    onPressed: () => _navigateToForm(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Nouveau Relevé'),
                    backgroundColor: Colors.blue,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    heroTag: 'location',
                    onPressed: () {
                      if (_currentPosition != null) {
                        _mapController.move(_currentPosition!, 15.0);
                      }
                    },
                    tooltip: 'Ma position',
                    child: const Icon(Icons.my_location),
                  ),
                ),
                // Légende en bas à gauche
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Mettre à jour les polygones quand les constructions changent
    final provider = Provider.of<ConstructionProvider>(context, listen: false);
    if (provider.constructions.length != _constructionPolygons.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updatePolygons();
      });
    }
  }
}
