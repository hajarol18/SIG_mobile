import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/construction.dart';
import '../utils/route_calculator.dart';

/// Écran pour afficher l'itinéraire vers une construction
class RouteScreen extends StatefulWidget {
  final Construction construction;
  final LatLng? currentPosition;

  const RouteScreen({
    super.key,
    required this.construction,
    this.currentPosition,
  });

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  LatLng? _currentPosition;
  bool _isLoadingPosition = true;
  List<LatLng> _routePoints = [];
  double? _distance;
  int? _estimatedTime;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _initializePosition();
  }

  Future<void> _initializePosition() async {
    if (widget.currentPosition != null) {
      setState(() {
        _currentPosition = widget.currentPosition;
        _isLoadingPosition = false;
      });
      _calculateRoute();
    } else {
      await _getCurrentLocation();
    }
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

      _calculateRoute();
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

  void _calculateRoute() {
    if (_currentPosition == null) return;

    try {
      // Calculer le centre du polygone de construction
      final List<dynamic> coords = jsonDecode(widget.construction.geometry);
      if (coords.isEmpty) return;

      final List<LatLng> polygonPoints = coords.map((coord) {
        return LatLng(coord[1] as double, coord[0] as double);
      }).toList();

      final LatLng destination = RouteCalculator.calculatePolygonCenter(polygonPoints);

      // Calculer la distance
      final double distanceInMeters = RouteCalculator.calculateDistance(
        _currentPosition!,
        destination,
      );

      // Calculer le temps estimé
      final int timeInMinutes = RouteCalculator.estimateTravelTime(
        distanceInMeters / 1000,
      );

      // Créer une route simple (ligne droite pour l'instant)
      // Dans une vraie app, utiliser un service d'itinéraire (OSRM, Google Maps, etc.)
      setState(() {
        _routePoints = [_currentPosition!, destination];
        _distance = distanceInMeters;
        _estimatedTime = timeInMinutes;
      });

      // Centrer la carte sur l'itinéraire
      _mapController.fitCamera(
        CameraFit.coordinates(
          coordinates: _routePoints,
          padding: const EdgeInsets.all(50),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du calcul de l\'itinéraire: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openNavigationApp() async {
    if (_currentPosition == null) return;

    try {
      final List<dynamic> coords = jsonDecode(widget.construction.geometry);
      if (coords.isEmpty) return;

      final List<LatLng> polygonPoints = coords.map((coord) {
        return LatLng(coord[1] as double, coord[0] as double);
      }).toList();

      final LatLng destination = RouteCalculator.calculatePolygonCenter(polygonPoints);
      final String url = RouteCalculator.generateNavigationUrlWithOrigin(
        _currentPosition!,
        destination,
      );

      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Impossible d\'ouvrir l\'application de navigation'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
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
        title: const Text('Itinéraire'),
        actions: [
          if (_currentPosition != null && _distance != null)
            IconButton(
              icon: const Icon(Icons.navigation),
              onPressed: _openNavigationApp,
              tooltip: 'Ouvrir dans l\'app de navigation',
            ),
        ],
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
                    // Informations de l'itinéraire
                    if (_distance != null && _estimatedTime != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildInfoCard(
                              Icons.straighten,
                              'Distance',
                              RouteCalculator.formatDistance(_distance!),
                            ),
                            _buildInfoCard(
                              Icons.access_time,
                              'Temps estimé',
                              '$_estimatedTime min',
                            ),
                          ],
                        ),
                      ),

                    // Carte avec itinéraire
                    Expanded(
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _currentPosition!,
                          initialZoom: 13.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.sig_mobile',
                          ),
                          // Marqueur position actuelle
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _currentPosition!,
                                width: 40,
                                height: 40,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                  ),
                                  child: const Icon(
                                    Icons.my_location,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Marqueur destination
                          if (_routePoints.isNotEmpty)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: _routePoints.last,
                                  width: 40,
                                  height: 40,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 3),
                                    ),
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          // Ligne d'itinéraire
                          if (_routePoints.length >= 2)
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: _routePoints,
                                  strokeWidth: 4.0,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
