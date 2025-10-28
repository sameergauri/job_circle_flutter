// file: utils/date_utils.dart
class DateUtilsHelper {
  static String getMonthName(int? month) {
    if (month == null) return '';

    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return (month >= 1 && month <= 12) ? months[month] : '';
  }
}


// file: utils/month_name_converter.dart
class MonthNameConverter {
  static String getShortMonthName(String? monthName) {
    if (monthName == null || monthName.isEmpty) return '';

    final monthsMap = {
      'january': 'Jan',
      'february': 'Feb',
      'march': 'Mar',
      'april': 'Apr',
      'may': 'May',
      'june': 'Jun',
      'july': 'Jul',
      'august': 'Aug',
      'september': 'Sep',
      'october': 'Oct',
      'november': 'Nov',
      'december': 'Dec',
    };

    final lowerCaseMonth = monthName.toLowerCase().trim();

    return monthsMap[lowerCaseMonth] ?? '';
  }
}


// file: utils/month_range_formatter.dart
class MonthRangeFormatter {
  static final Map<String, String> _monthShortMap = {
    'january': 'Jan',
    'february': 'Feb',
    'march': 'Mar',
    'april': 'Apr',
    'may': 'May',
    'june': 'Jun',
    'july': 'Jul',
    'august': 'Aug',
    'september': 'Sep',
    'october': 'Oct',
    'november': 'Nov',
    'december': 'Dec',
  };

  static String formatMonthRange(String input) {
    if (input.isEmpty) return '';

    // Split by "to" if present
    final parts = input.split('to');

    // Format each part (e.g., "February 2017" → "Feb 2017")
    final formattedParts = parts.map((part) {
      String trimmed = part.trim();
      for (final entry in _monthShortMap.entries) {
        if (trimmed.toLowerCase().startsWith(entry.key)) {
          trimmed = trimmed.replaceFirst(
            RegExp(entry.key, caseSensitive: false),
            entry.value,
          );
          break;
        }
      }
      return trimmed;
    }).toList();

    // Join them back with " to "
    return formattedParts.join(' to ');
  }
}
