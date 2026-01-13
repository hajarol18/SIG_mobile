import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class PolygonDrawerScreen extends StatefulWidget {
  const PolygonDrawerScreen({super.key});

  @override
  State<PolygonDrawerScreen> createState() => _PolygonDrawerScreenState();
}

class _PolygonDrawerScreenState extends State<PolygonDrawerScreen> {
  final MapController _mapController = MapController();
  List<LatLng> _points = [];
  LatLng? _currentPosition;
  bool _isDrawing = true;

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
          _currentPosition = const LatLng(33.5731, -7.5898); // Casablanca par défaut
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _currentPosition = const LatLng(33.5731, -7.5898);
          });
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      _mapController.move(_currentPosition!, 15.0);
    } catch (e) {
      setState(() {
        _currentPosition = const LatLng(33.5731, -7.5898);
      });
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    if (_isDrawing) {
      setState(() {
        _points.add(point);
      });
    }
  }

  void _removeLastPoint() {
    if (_points.isNotEmpty) {
      setState(() {
        _points.removeLast();
      });
    }
  }

  void _clearAllPoints() {
    setState(() {
      _points.clear();
    });
  }

  void _finishDrawing() {
    if (_points.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Un polygone doit avoir au moins 3 points'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Convertir les coordonnées en format [longitude, latitude] pour GeoJSON
    final coordinates = _points.map((point) => [point.longitude, point.latitude]).toList();

    Navigator.pop(context, coordinates);
  }

  void _cancel() {
    Navigator.pop(context);
  }

  List<Polygon> _getPolygons() {
    if (_points.length < 2) return [];

    return [
      Polygon(
        points: _points,
        color: Colors.blue.withOpacity(0.3),
        borderColor: Colors.blue,
        borderStrokeWidth: 2,
        isFilled: true,
      ),
    ];
  }

  List<Marker> _getMarkers() {
    return _points.map((point) {
      return Marker(
        point: point,
        width: 12,
        height: 12,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dessiner un Polygone'),
        actions: [
          if (_points.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: _removeLastPoint,
              tooltip: 'Retirer le dernier point',
            ),
          if (_points.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearAllPoints,
              tooltip: 'Effacer tout',
            ),
        ],
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentPosition!,
                    initialZoom: 15.0,
                    minZoom: 5.0,
                    maxZoom: 18.0,
                    onTap: _onMapTap,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.sig_mobile',
                    ),
                    PolygonLayer(
                      polygons: _getPolygons(),
                    ),
                    MarkerLayer(
                      markers: _getMarkers(),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isDrawing
                                ? 'Mode dessin actif'
                                : 'Mode navigation',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _points.isEmpty
                                ? 'Appuyez sur la carte pour ajouter des points'
                                : '${_points.length} point(s) ajouté(s)',
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                          if (_points.length < 3 && _points.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Minimum 3 points requis pour un polygone',
                                style: TextStyle(
                                  color: Colors.orange[700],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _cancel,
                                  child: const Text('Annuler'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed:
                                      _points.length >= 3 ? _finishDrawing : null,
                                  child: const Text('Terminer'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
                Positioned(
                  top: 20,
                  right: 20,
                  child: FloatingActionButton(
                    heroTag: 'draw_mode',
                    onPressed: () {
                      setState(() {
                        _isDrawing = !_isDrawing;
                      });
                    },
                    tooltip: _isDrawing ? 'Mode navigation' : 'Mode dessin',
                    backgroundColor: _isDrawing ? Colors.blue : Colors.grey,
                    child: Icon(_isDrawing ? Icons.edit : Icons.navigation),
                  ),
                ),
              ],
            ),
    );
  }
}
