import 'dart:convert';
import 'package:xml/xml.dart' as xml;
import '../models/construction.dart';

/// Utilitaire pour exporter/importer en format GPX (GPS Exchange Format)
class GpxExport {
  /// Exporte les constructions en format GPX
  static String exportToGpx(List<Construction> constructions, {String? name}) {
    final builder = xml.XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    builder.element('gpx', nest: () {
      builder.attribute('version', '1.1');
      builder.attribute('creator', 'SIG Mobile');
      builder.attribute('xmlns', 'http://www.topografix.com/GPX/1/1');
      
      builder.element('metadata', nest: () {
        builder.element('name', nest: name ?? 'Constructions SIG Mobile');
        builder.element('time', nest: DateTime.now().toIso8601String());
      });

      // Waypoints pour chaque construction
      for (var construction in constructions) {
        try {
          final List<dynamic> coords = jsonDecode(construction.geometry);
          if (coords.isEmpty) continue;

          // Calculer le centre
          double sumLat = 0;
          double sumLng = 0;
          for (var coord in coords) {
            sumLat += coord[1] as double;
            sumLng += coord[0] as double;
          }
          final centerLat = sumLat / coords.length;
          final centerLng = sumLng / coords.length;

          builder.element('wpt', nest: () {
            builder.attribute('lat', centerLat.toString());
            builder.attribute('lon', centerLng.toString());
            builder.element('name', nest: construction.adresse);
            builder.element('desc', nest: _buildDescription(construction));
            builder.element('type', nest: construction.type.label);
            builder.element('cmt', nest: construction.notes ?? '');
          });
        } catch (e) {
          // Ignorer les erreurs
        }
      }
    });

    final document = builder.buildDocument();
    return document.toXmlString(pretty: true);
  }

  static String _buildDescription(Construction construction) {
    final buffer = StringBuffer();
    buffer.writeln('Type: ${construction.type.label}');
    if (construction.contact != null) {
      buffer.writeln('Contact: ${construction.contact}');
    }
    buffer.writeln('Date: ${construction.dateCreation.toString()}');
    if (construction.notes != null) {
      buffer.writeln('Notes: ${construction.notes}');
    }
    return buffer.toString();
  }

  /// Importe un fichier GPX (basique)
  static List<Construction>? importFromGpx(String gpxContent) {
    try {
      final document = xml.XmlDocument.parse(gpxContent);
      final waypoints = document.findAllElements('wpt');
      final List<Construction> constructions = [];

      for (var waypoint in waypoints) {
        try {
          final lat = double.parse(waypoint.getAttribute('lat')!);
          final lon = double.parse(waypoint.getAttribute('lon')!);
          final name = waypoint.findElements('name').first.text;
          final typeStr = waypoint.findElements('type').firstOrNull?.text ?? 'autre';
          
          // Créer un polygone simple autour du point (carré de 100m)
          const double offset = 0.001; // ~100m
          final coordinates = [
            [lon - offset, lat - offset],
            [lon + offset, lat - offset],
            [lon + offset, lat + offset],
            [lon - offset, lat + offset],
          ];

          final geometry = jsonEncode(coordinates);

          final type = ConstructionType.values.firstWhere(
            (e) => e.name == typeStr.toLowerCase(),
            orElse: () => ConstructionType.autre,
          );

          constructions.add(Construction(
            adresse: name,
            type: type,
            geometry: geometry,
            dateCreation: DateTime.now(),
          ));
        } catch (e) {
          // Ignorer les erreurs
        }
      }

      return constructions;
    } catch (e) {
      return null;
    }
  }
}
