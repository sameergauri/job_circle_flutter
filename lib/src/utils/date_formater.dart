// ignore_for_file: avoid_print

import 'package:intl/intl.dart';

class CvParseExpDateFormatter {
  /// Converts any date string (like 'Jun 2022', '2022-06-01', '01/06/22')
  /// into the format 'dd MMM yyyy' (e.g., '01 Jun 2022').
  /// If parsing fails, returns the original input.
  static String? formatDate(String? input, bool? isDate) {
    if (input == null || input.trim().isEmpty) return null;

    try {
      // Normalize unusual characters (like en dash)
      // ✅ Normalize the text safely
      input = input
          .trim()
          // remove day suffixes (st, nd, rd, th) but keep the number
          .replaceAllMapped(
            RegExp(r'(\d+)(st|nd|rd|th)'),
            (match) => match.group(1)!,
          )
          .replaceAll(RegExp(r'[–—]'), '-') // normalize dash
          .replaceAll(',', ' ') // remove commas
          .replaceAll(RegExp(r'\s+'), ' '); // normalize spaces

      // Try multiple formats
      final possibleFormats = [
        'dd-MM-yyyy',
        'dd-MMM-yyyy',
        'dd MMM yyyy',
        'dd MM yyyy',
        'MM-dd-yyyy',
        'MMM-yyyy',
        'MMMM-yyyy',
        'MM-yyyy',
        'yyyy-MM-dd',
        'dd/MM/yyyy',
        'MM/dd/yyyy',
        'yyyy/MM/dd',
        'dd MMM yyyy',
        'MMM yyyy',
        'MMMM yyyy',
        'yyyy',
      ];

      DateTime? parsedDate;

      for (final format in possibleFormats) {
        try {
          parsedDate = DateFormat(format).parseLoose(input);
          break;
        } catch (_) {}
      }

      if (parsedDate == null) return input;

      // ✅ Always return in format "dd MMM yyyy"
      if (isDate != null && isDate == true) {
        return DateFormat('MMM yyyy').format(parsedDate);
      } else {
        return DateFormat('dd MMM yyyy').format(parsedDate);
      }
    } catch (e) {
      print('⚠️ Date parsing failed for "$input": $e');
      return input;
    }
  }
}

class CvParseDateToApiFormat {
  /// Converts any date string into 'yyyy-MM-dd' format.
  /// Returns original input if parsing fails.
  static String? formatDate(String? input) {
    if (input == null || input.isEmpty) return null;

    try {
      // Normalize dash symbols (–, — → -)
      input = input.replaceAll(RegExp(r'[–—]'), '-').trim();

      // Remove unwanted commas
      input = input.replaceAll(',', ' ');

      // Handle words like "Present" or "Currently"
      if (RegExp(r'present|current', caseSensitive: false).hasMatch(input)) {
        return input;
      }

      // Common possible input formats
      final possibleFormats = [
        'dd MMM yyyy',
        'dd MM yyyy',
        'dd-MMM-yyyy',
        'dd-MM-yyyy',
        'MM-dd-yyyy',
        'MMM-yyyy',
        'MMMM-yyyy',
        'MM-yyyy',
        'yyyy-MM-dd',
        'dd/MM/yyyy',
        'MM/dd/yyyy',
        'yyyy/MM/dd',
        'dd MMM yyyy',
        'MMM yyyy',
        'MMMM yyyy',
        'yyyy-MMM-dd',
        'yyyy-MM-dd',
        'yyyy-MMMM-dd',
        'yyyy',
      ];

      DateTime? parsedDate;

      for (var format in possibleFormats) {
        try {
          parsedDate = DateFormat(format).parseLoose(input);
          break;
        } catch (_) {}
      }

      if (parsedDate == null) return input; // fallback if parsing fails

      // ✅ Convert to API-safe format: yyyy-MM-dd
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      print('⚠️ Date parsing failed for "$input": $e');
      return input; // fallback
    }
  }
}
