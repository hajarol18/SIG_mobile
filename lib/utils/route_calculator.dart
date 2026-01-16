import 'dart:math' as math;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

/// Utilitaire pour calculer les itinéraires et distances
class RouteCalculator {
  static const Distance _distance = Distance();

  /// Calcule la distance en mètres entre deux points
  static double calculateDistance(LatLng point1, LatLng point2) {
    return _distance.as(
      LengthUnit.Meter,
      point1,
      point2,
    );
  }

  /// Calcule la distance en kilomètres
  static double calculateDistanceKm(LatLng point1, LatLng point2) {
    return calculateDistance(point1, point2) / 1000;
  }

  /// Formate la distance pour affichage
  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(2)} km';
    }
  }

  /// Calcule le temps de trajet estimé (en minutes)
  /// Vitesse moyenne : 50 km/h en ville
  static int estimateTravelTime(double distanceInKm) {
    const double averageSpeedKmh = 50.0;
    final double timeInHours = distanceInKm / averageSpeedKmh;
    return (timeInHours * 60).round();
  }

  /// Calcule le centre d'un polygone
  static LatLng calculatePolygonCenter(List<LatLng> points) {
    if (points.isEmpty) {
      return const LatLng(0, 0);
    }

    double sumLat = 0;
    double sumLng = 0;

    for (var point in points) {
      sumLat += point.latitude;
      sumLng += point.longitude;
    }

    return LatLng(
      sumLat / points.length,
      sumLng / points.length,
    );
  }

  /// Calcule la surface d'un polygone en m² (formule de Shoelace)
  static double calculatePolygonArea(List<LatLng> points) {
    if (points.length < 3) return 0.0;

    double area = 0.0;
    for (int i = 0; i < points.length; i++) {
      int j = (i + 1) % points.length;
      area += points[i].longitude * points[j].latitude;
      area -= points[j].longitude * points[i].latitude;
    }
    area = area.abs() / 2.0;

    // Convertir en m² (approximation pour petites surfaces)
    // Pour une précision plus élevée, utiliser une projection
    const double metersPerDegreeLat = 111320.0;
    final double cosLat = points.isNotEmpty ? 
        math.cos(points[0].latitude * math.pi / 180) : 1.0;
    final double metersPerDegreeLng = 111320.0 * cosLat;
    
    return area * metersPerDegreeLat * metersPerDegreeLng;
  }

  /// Formate la surface pour affichage
  static String formatArea(double areaInSquareMeters) {
    if (areaInSquareMeters < 10000) {
      return '${areaInSquareMeters.toStringAsFixed(0)} m²';
    } else {
      return '${(areaInSquareMeters / 10000).toStringAsFixed(2)} hectares';
    }
  }

  /// Génère une URL pour navigation GPS (Google Maps)
  static String generateNavigationUrl(LatLng destination) {
    return 'https://www.google.com/maps/dir/?api=1&destination=${destination.latitude},${destination.longitude}';
  }

  /// Génère une URL pour navigation GPS avec point de départ
  static String generateNavigationUrlWithOrigin(LatLng origin, LatLng destination) {
    return 'https://www.google.com/maps/dir/?api=1&origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}';
  }
}
