import 'dart:convert';
import 'package:xml/xml.dart' as xml;
import 'package:latlong2/latlong.dart';
import '../models/construction.dart';
import 'route_calculator.dart';

/// Utilitaire pour exporter/importer en format KML (Google Earth)
class KmlExport {
  /// Exporte les constructions en format KML
  static String exportToKml(List<Construction> constructions, {String? name}) {
    final builder = xml.XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    builder.element('kml', nest: () {
      builder.attribute('xmlns', 'http://www.opengis.net/kml/2.2');
      builder.element('Document', nest: () {
        builder.element('name', nest: name ?? 'Constructions SIG Mobile');
        builder.element('description', nest: 'Export des constructions depuis SIG Mobile');
        
        // Style pour chaque type
        for (var type in ConstructionType.values) {
          builder.element('Style', nest: () {
            builder.attribute('id', 'style_${type.name}');
            builder.element('PolyStyle', nest: () {
              final color = _colorToKmlColor(type.colorValue);
              builder.element('color', nest: color);
              builder.element('colorMode', nest: 'normal');
              builder.element('fill', nest: '1');
              builder.element('outline', nest: '1');
            });
            builder.element('LineStyle', nest: () {
              builder.element('color', nest: 'ff000000'); // Noir
              builder.element('width', nest: '2');
            });
          });
        }

        // Placemarks pour chaque construction
        for (var construction in constructions) {
          try {
            final List<dynamic> coords = jsonDecode(construction.geometry);
            if (coords.isEmpty) continue;

            builder.element('Placemark', nest: () {
              builder.element('name', nest: construction.adresse);
              builder.element('description', nest: () {
                builder.cdata(_buildDescription(construction));
              });
              builder.element('styleUrl', nest: '#style_${construction.type.name}');
              builder.element('Polygon', nest: () {
                builder.element('outerBoundaryIs', nest: () {
                  builder.element('LinearRing', nest: () {
                    builder.element('coordinates', nest: () {
                      final coordsString = coords.map((coord) {
                        return '${coord[0]},${coord[1]},0'; // lng,lat,altitude
                      }).join(' ');
                      builder.text('$coordsString ${coords[0][0]},${coords[0][1]},0'); // Fermer le polygone
                    });
                  });
                });
              });
            });
          } catch (e) {
            // Ignorer les erreurs
          }
        }
      });
    });

    final document = builder.buildDocument();
    return document.toXmlString(pretty: true);
  }

  /// Convertit une couleur Flutter en format KML (AABBGGRR)
  static String _colorToKmlColor(int colorValue) {
    // Flutter: AARRGGBB, KML: AABBGGRR
    final a = ((colorValue >> 24) & 0xFF).toRadixString(16).padLeft(2, '0');
    final r = ((colorValue >> 16) & 0xFF).toRadixString(16).padLeft(2, '0');
    final g = ((colorValue >> 8) & 0xFF).toRadixString(16).padLeft(2, '0');
    final b = (colorValue & 0xFF).toRadixString(16).padLeft(2, '0');
    return '$a$b$g$r';
  }

  static String _buildDescription(Construction construction) {
    final buffer = StringBuffer();
    buffer.writeln('<![CDATA[');
    buffer.writeln('<h3>${construction.type.label}</h3>');
    buffer.writeln('<p><b>Adresse:</b> ${construction.adresse}</p>');
    if (construction.contact != null) {
      buffer.writeln('<p><b>Contact:</b> ${construction.contact}</p>');
    }
    buffer.writeln('<p><b>Date:</b> ${construction.dateCreation.toString()}</p>');
    
    try {
      final List<dynamic> coords = jsonDecode(construction.geometry);
      final List<LatLng> points = coords.map((coord) {
        return LatLng(coord[1] as double, coord[0] as double);
      }).toList();
      final double area = RouteCalculator.calculatePolygonArea(points);
      buffer.writeln('<p><b>Surface:</b> ${RouteCalculator.formatArea(area)}</p>');
    } catch (e) {
      // Ignorer
    }
    
    if (construction.notes != null) {
      buffer.writeln('<p><b>Notes:</b> ${construction.notes}</p>');
    }
    buffer.writeln(']]>');
    return buffer.toString();
  }

  /// Importe un fichier KML (basique)
  static List<Construction>? importFromKml(String kmlContent) {
    try {
      final document = xml.XmlDocument.parse(kmlContent);
      final placemarks = document.findAllElements('Placemark');
      final List<Construction> constructions = [];

      for (var placemark in placemarks) {
        try {
          final name = placemark.findElements('name').first.text;
          final coordinates = placemark
              .findElements('coordinates')
              .first
              .text
              .trim()
              .split(' ')
              .where((coord) => coord.isNotEmpty)
              .map((coord) {
                final parts = coord.split(',');
                return [double.parse(parts[0]), double.parse(parts[1])];
              })
              .toList();

          if (coordinates.length < 3) continue;

          // Convertir en format JSON
          final geometry = jsonEncode(coordinates);

          // Déterminer le type (basique, pourrait être amélioré)
          final type = ConstructionType.autre;

          constructions.add(Construction(
            adresse: name,
            type: type,
            geometry: geometry,
            dateCreation: DateTime.now(),
          ));
        } catch (e) {
          // Ignorer les erreurs de parsing
        }
      }

      return constructions;
    } catch (e) {
      return null;
    }
  }
}
