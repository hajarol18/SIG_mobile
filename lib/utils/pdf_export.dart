import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../models/construction.dart';
import 'route_calculator.dart';

/// Utilitaire pour exporter les données en PDF
class PdfExport {
  static Future<pw.Document> generateReport({
    required List<Construction> constructions,
    String? title,
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd/MM/yyyy à HH:mm');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // En-tête
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    title ?? 'Rapport des Constructions',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    dateFormat.format(DateTime.now()),
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Résumé
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey300,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Résumé',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text('Total de constructions: ${constructions.length}'),
                  pw.Text('Date de génération: ${dateFormat.format(DateTime.now())}'),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Statistiques par type
            _buildStatisticsSection(constructions),
            pw.SizedBox(height: 20),

            // Liste des constructions
            pw.Text(
              'Détails des Constructions',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 10),
            ...constructions.map((construction) => _buildConstructionCard(construction, dateFormat)),
          ];
        },
      ),
    );

    return pdf;
  }

  static pw.Widget _buildStatisticsSection(List<Construction> constructions) {
    final Map<String, int> typeCounts = {};
    for (var construction in constructions) {
      final typeLabel = construction.type.label;
      typeCounts[typeLabel] = (typeCounts[typeLabel] ?? 0) + 1;
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Répartition par Type',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          ...typeCounts.entries.map((entry) {
            final percentage = (entry.value / constructions.length * 100).toStringAsFixed(1);
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 4),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(entry.key),
                  pw.Text('${entry.value} (${percentage}%)'),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  static pw.Widget _buildConstructionCard(
    Construction construction,
    DateFormat dateFormat,
  ) {
    try {
      final List<dynamic> coords = jsonDecode(construction.geometry);
      final List<LatLng> points = coords.map((coord) {
        return LatLng(coord[1] as double, coord[0] as double);
      }).toList();

      final double area = RouteCalculator.calculatePolygonArea(points);
      final LatLng center = RouteCalculator.calculatePolygonCenter(points);

      return pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 12),
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey400),
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Construction #${construction.id ?? "N/A"}',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey200,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    construction.type.label,
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Text('Adresse: ${construction.adresse}'),
            if (construction.contact != null)
              pw.Text('Contact: ${construction.contact}'),
            pw.Text('Date: ${dateFormat.format(construction.dateCreation)}'),
            pw.Text('Surface: ${RouteCalculator.formatArea(area)}'),
            pw.Text(
              'Centre: ${center.latitude.toStringAsFixed(6)}, ${center.longitude.toStringAsFixed(6)}',
            ),
            if (construction.notes != null) ...[
              pw.SizedBox(height: 4),
              pw.Text(
                'Notes: ${construction.notes}',
                style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic),
              ),
            ],
          ],
        ),
      );
    } catch (e) {
      return pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 12),
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.red),
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Text('Erreur lors de l\'export: $e'),
      );
    }
  }
}
