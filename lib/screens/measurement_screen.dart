import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/construction.dart';
import '../utils/route_calculator.dart';

/// Écran pour afficher les mesures d'une construction (distance, surface)
class MeasurementScreen extends StatelessWidget {
  final Construction construction;

  const MeasurementScreen({
    super.key,
    required this.construction,
  });

  @override
  Widget build(BuildContext context) {
    try {
      final List<dynamic> coords = jsonDecode(construction.geometry);
      if (coords.isEmpty) {
        return Scaffold(
          appBar: AppBar(title: const Text('Mesures')),
          body: const Center(
            child: Text('Aucune géométrie disponible'),
          ),
        );
      }

      final List<LatLng> points = coords.map((coord) {
        return LatLng(coord[1] as double, coord[0] as double);
      }).toList();

      // Calculer les mesures
      final double area = RouteCalculator.calculatePolygonArea(points);
      final double perimeter = _calculatePerimeter(points);
      final LatLng center = RouteCalculator.calculatePolygonCenter(points);

      return Scaffold(
        appBar: AppBar(
          title: const Text('Mesures'),
        ),
        body: Column(
          children: [
            // Carte avec polygone
            Expanded(
              flex: 2,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: center,
                  initialZoom: 15.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.sig_mobile',
                  ),
                  PolygonLayer(
                    polygons: [
                      Polygon(
                        points: points,
                        color: Colors.blue.withOpacity(0.3),
                        borderColor: Colors.blue,
                        borderStrokeWidth: 2.0,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: center,
                        width: 30,
                        height: 30,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Informations de mesure
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mesures de la construction',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildMeasurementCard(
                    context,
                    Icons.square_foot,
                    'Surface',
                    RouteCalculator.formatArea(area),
                    Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildMeasurementCard(
                    context,
                    Icons.straighten,
                    'Périmètre',
                    RouteCalculator.formatDistance(perimeter),
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildMeasurementCard(
                    context,
                    Icons.location_on,
                    'Centre',
                    '${center.latitude.toStringAsFixed(6)}, ${center.longitude.toStringAsFixed(6)}',
                    Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildMeasurementCard(
                    context,
                    Icons.place,
                    'Nombre de points',
                    '${points.length}',
                    Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mesures')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Erreur: $e'),
            ],
          ),
        ),
      );
    }
  }

  double _calculatePerimeter(List<LatLng> points) {
    if (points.length < 2) return 0.0;

    double perimeter = 0.0;
    for (int i = 0; i < points.length; i++) {
      int nextIndex = (i + 1) % points.length;
      perimeter += RouteCalculator.calculateDistance(
        points[i],
        points[nextIndex],
      );
    }
    return perimeter;
  }

  Widget _buildMeasurementCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
