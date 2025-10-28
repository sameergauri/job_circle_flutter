// ignore_for_file: avoid_print

import 'package:intl/intl.dart';

class AgeCalculator {
  /// Converts any date string to 'dd MMM yyyy' format (e.g. '01 Oct 2007')
  /// and optionally calculates age.
  static String? calculateAge(String? input) {
    if (input == null || input.isEmpty) return null;

    try {
      // Clean and normalize input
      String normalized = input
          .replaceAll(
            RegExp(r'(\d+)(st|nd|rd|th)'),
            r'1',
          ) // remove 1st, 2nd, 3rd, 4th
          .replaceAll(RegExp(r'[–—]'), '-') // normalize dash
          .replaceAll(',', ' ') // remove commas
          .trim();

      // Possible date formats
      final possibleFormats = [
        'dd-MMM-yyyy',
        'dd-MM-yyyy',
        'MM-dd-yyyy',
        'yyyy-MM-dd',
        'dd/MM/yyyy',
        'MM/dd/yyyy',
        'yyyy/MM/dd',
        'dd MMM yyyy',
        'dd MMMM yyyy',
        'MMM yyyy',
        'MMMM yyyy',
        'yyyy',
      ];

      DateTime? parsedDate;

      for (var format in possibleFormats) {
        try {
          parsedDate = DateFormat(format).parseLoose(normalized);
          break;
        } catch (_) {}
      }

      if (parsedDate == null) return null;

      // ✅ Format as 'dd MMM yyyy'
      // ✅ Calculate age
      DateTime today = DateTime.now();
      int age = today.year - parsedDate.year;
      if (today.month < parsedDate.month ||
          (today.month == parsedDate.month && today.day < parsedDate.day)) {
        age--;
      }

      return "($age yrs)";
    } catch (e) {
      print("⚠️ Age parsing failed for '$input': $e");
      return null;
    }
  }
}
