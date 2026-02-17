import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:wayfarer_ai/domain/entities/trip.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;

class PdfService {
  static Future<void> generateAndShareItinerary(Trip trip) async {
    final pdf = pw.Document();

    // Add pages to PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Header
          _buildHeader(trip),
          pw.SizedBox(height: 20),
          
          // Trip Summary
          _buildSummarySection(trip),
          pw.SizedBox(height: 30),
          
          // Itinerary Title
          pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 10),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(
                  color: PdfColors.teal,
                  width: 2,
                ),
              ),
            ),
            child: pw.Text(
              'Day-by-Day Itinerary',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.teal,
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          
          // Days
          ...trip.itinerary.map((day) => _buildDaySection(day)).toList(),
        ],
      ),
    );

    // Generate PDF bytes
    final bytes = await pdf.save();
    final filename = '${trip.destination}_Itinerary_${DateFormat('yyyy-MM-dd').format(DateTime.now())}.pdf';
    
    // Share or save based on platform
    if (kIsWeb) {
      // Web: Download file
      _downloadPdfWeb(bytes, filename);
    } else {
      // Mobile/Desktop: Share PDF
      await Printing.sharePdf(bytes: bytes, filename: filename);
    }
  }

  static Future<void> saveItineraryToDevice(Trip trip) async {
    final pdf = pw.Document();

    // Add pages to PDF (same as above)
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildHeader(trip),
          pw.SizedBox(height: 20),
          _buildSummarySection(trip),
          pw.SizedBox(height: 30),
          pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 10),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.teal, width: 2),
              ),
            ),
            child: pw.Text(
              'Day-by-Day Itinerary',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.teal,
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          ...trip.itinerary.map((day) => _buildDaySection(day)).toList(),
        ],
      ),
    );

    final bytes = await pdf.save();
    final filename = '${trip.destination}_Itinerary_${DateFormat('yyyy-MM-dd').format(DateTime.now())}.pdf';

    if (kIsWeb) {
      // Web: Download file
      _downloadPdfWeb(bytes, filename);
    } else {
      // Mobile/Desktop: Use printing package to save/share
      await Printing.sharePdf(bytes: bytes, filename: filename);
    }
  }

  static void _downloadPdfWeb(List<int> bytes, String filename) {
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  static pw.Widget _buildHeader(Trip trip) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        gradient: const pw.LinearGradient(
          colors: [PdfColors.teal, PdfColors.teal700],
        ),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      trip.destination.toUpperCase(),
                      style: pw.TextStyle(
                        fontSize: 32,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      trip.country,
                      style: pw.TextStyle(
                        fontSize: 18,
                        color: PdfColors.white.shade(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Container(
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      '${trip.numberOfDays}',
                      style: pw.TextStyle(
                        fontSize: 36,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.teal,
                      ),
                    ),
                    pw.Text(
                      'DAYS',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.teal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummarySection(Trip trip) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                'Dates',
                '${DateFormat('MMM dd').format(trip.startDate)} - ${DateFormat('MMM dd, yyyy').format(trip.endDate)}',
              ),
              _buildSummaryItem(
                'Budget',
                '\$${trip.budget.toStringAsFixed(0)}',
              ),
            ],
          ),
          if (trip.preferences.isNotEmpty) ...[
            pw.SizedBox(height: 15),
            pw.Divider(color: PdfColors.grey300),
            pw.SizedBox(height: 15),
            pw.Row(
              children: [
                pw.Text(
                  'Interests: ',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    trip.preferences.join(', '),
                    style: const pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.grey700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryItem(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(
          label.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey600,
            letterSpacing: 1,
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildDaySection(day) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Day Header
          pw.Container(
            padding: const pw.EdgeInsets.all(15),
            decoration: pw.BoxDecoration(
              color: PdfColors.teal50,
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: PdfColors.teal, width: 1),
            ),
            child: pw.Row(
              children: [
                pw.Container(
                  width: 50,
                  height: 50,
                  decoration: pw.BoxDecoration(
                    color: PdfColors.teal,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Center(
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          'Day',
                          style: const pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.Text(
                          '${day.dayNumber}',
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(width: 15),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        DateFormat('EEEE, MMMM dd, yyyy').format(day.date),
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      if (day.summary != null) ...[
                        pw.SizedBox(height: 4),
                        pw.Text(
                          day.summary!,
                          style: const pw.TextStyle(
                            fontSize: 11,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ],
                      pw.SizedBox(height: 5),
                      pw.Text(
                        '${day.activities.length} activities • \$${day.estimatedCost.toStringAsFixed(0)}',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 10),
          
          // Activities
          ...day.activities.map((activity) => _buildActivityItem(activity)).toList(),
        ],
      ),
    );
  }

  static pw.Widget _buildActivityItem(activity) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(left: 20, bottom: 10),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey50,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.grey200),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      activity.name,
                      style: pw.TextStyle(
                        fontSize: 13,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: pw.BoxDecoration(
                        color: _getActivityTypeColor(activity.type.toString().split('.').last),
                        borderRadius: pw.BorderRadius.circular(3),
                      ),
                      child: pw.Text(
                        activity.type.toString().split('.').last.toUpperCase(),
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (activity.estimatedCost != null)
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.teal100,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    '\$${activity.estimatedCost!.toStringAsFixed(0)}',
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.teal900,
                    ),
                  ),
                ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey200,
                  borderRadius: pw.BorderRadius.circular(3),
                ),
                child: pw.Text(
                  'TIME',
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey700,
                  ),
                ),
              ),
              pw.SizedBox(width: 5),
              pw.Text(
                activity.time,
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey700,
                ),
              ),
              if (activity.duration != null) ...[
                pw.SizedBox(width: 15),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey200,
                    borderRadius: pw.BorderRadius.circular(3),
                  ),
                  child: pw.Text(
                    'DURATION',
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey700,
                    ),
                  ),
                ),
                pw.SizedBox(width: 5),
                pw.Text(
                  '${activity.duration} min',
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ],
          ),
          if (activity.description != null) ...[
            pw.SizedBox(height: 5),
            pw.Text(
              activity.description!,
              style: const pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey700,
              ),
            ),
          ],
          if (activity.location.address.isNotEmpty) ...[
            pw.SizedBox(height: 5),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey200,
                    borderRadius: pw.BorderRadius.circular(3),
                  ),
                  child: pw.Text(
                    'LOCATION',
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey700,
                    ),
                  ),
                ),
                pw.SizedBox(width: 5),
                pw.Expanded(
                  child: pw.Text(
                    activity.location.address,
                    style: const pw.TextStyle(
                      fontSize: 9,
                      color: PdfColors.grey700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  static PdfColor _getActivityTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'sightseeing':
        return PdfColors.blue700;
      case 'restaurant':
        return PdfColors.orange700;
      case 'hotel':
        return PdfColors.purple700;
      case 'shopping':
        return PdfColors.pink700;
      case 'entertainment':
        return PdfColors.red700;
      case 'transport':
        return PdfColors.green700;
      default:
        return PdfColors.grey700;
    }
  }
}

