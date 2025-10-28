import 'package:intl/intl.dart';

class CvDurationCalculator {
  /// Calculates duration between [startDateStr] and [endDateStr].
  /// Accepts any common date format like '01-Jun-2022', '2022/06/01', etc.
  /// Returns duration as '2 y, 3 m', '5 m', or '12 days'.
  static String calculateDuration(String startDateStr, [String? endDateStr]) {
    final DateTime? startDate = _parseDate(startDateStr);
    final DateTime endDate = _parseDate(endDateStr) ?? DateTime.now();

    if (startDate == null) return "Invalid start date";

    int years = endDate.year - startDate.year;
    int months = endDate.month - startDate.month;
    int days = endDate.day - startDate.day;

    // Adjust negative day differences
    if (days < 0) {
      months -= 1;
      final previousMonth = DateTime(endDate.year, endDate.month, 0);
      days += previousMonth.day;
    }

    // Adjust negative month differences
    if (months < 0) {
      years -= 1;
      months += 12;
    }
    if (days == 0) {
      return "";
    } else if (years == 0 && months == 0) {
      return "($days days)";
    } else if (years == 0) {
      return "$months mos";
    } else if (months == 0) {
      return "($years yrs)";
    } else {
      return "($years yrs, $months mos)";
    }
  }

  /// Helper to safely parse date strings in multiple formats
  static DateTime? _parseDate(String? input) {
    if (input == null || input.trim().isEmpty) return null;

    try {
      input = input.replaceAll(RegExp(r'[–—]'), '-').trim();
      input = input.replaceAll(',', ' ');

      final possibleFormats = [
        'dd-MM-yyyy',
        'MM-dd-yyyy',
        'MM-yyyy',
        'MMM-yyyy',
        'MMMM-yyyy',
        'yyyy-MM-dd',
        'dd/MM/yyyy',
        'MM/dd/yyyy',
        'yyyy/MM/dd',
        'dd MMM yyyy',
        'MMM yyyy',
        'MMMM yyyy',
        'yyyy',
      ];

      for (final format in possibleFormats) {
        try {
          return DateFormat(format).parseLoose(input);
        } catch (_) {}
      }
    } catch (_) {}

    return null; // fallback if parsing fails
  }
}
